Return-Path: <linux-kernel-owner+w=401wt.eu-S1754140AbYHKAom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140AbYHKAom (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 20:44:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753134AbYHKAoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 20:44:34 -0400
Received: from tundra.namei.org ([65.99.196.166]:50986 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752879AbYHKAod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 20:44:33 -0400
Date: Mon, 11 Aug 2008 10:44:06 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: Grant Wilson <grant.wilson@zen.co.uk>,
       Jasper Bryant-Greene <jasper@amiton.co.nz>,
       Thomas Meyer <thomas@m3y3r.de>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux-Next <linux-next@vger.kernel.org>
Subject: Re: next-20080808: bash: fork: Resource temporarily unavailable
In-Reply-To: <22475.1218414070@redhat.com>
Message-ID: <alpine.LRH.1.10.0808111043240.3889@tundra.namei.org>
References: <20080810113044.19143b0a@worthy.swandive.local> <1218322518.3268.0.camel@luna.unix.geek.nz> <1218287473.3155.13.camel@dhcppc0> <1218281190.3155.5.camel@dhcppc0> <1218214935.3146.5.camel@dhcppc0> <alpine.LRH.1.10.0808090747150.29079@tundra.namei.org>
 <14476.1218286327@redhat.com> <15386.1218290826@redhat.com> <10251.1218361539@redhat.com>  <22475.1218414070@redhat.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Aug 2008, David Howells wrote:

> Grant Wilson <grant.wilson@zen.co.uk> wrote:
> 
> > [  223.039938] Rlimit EAGAIN (-1 >= 16375, uid 1000)
> > [  223.044744] copy_process() = -11
> > [  226.660319] Rlimit EAGAIN (-1 >= 16375, uid 1000)
> > [  226.664166] copy_process() = -11
> 
> Can you try the attached patch please?

This is working for me.  I'll push it to next-creds so it (hopefully) gets 
into the next linux-next for wider testing.


> 
> David
> ---
> CRED: Inc the user processes count on cred share return from copy_creds()
> 
> From: David Howells <dhowells@redhat.com>
> 
> Increment the user processes count in the case where copy_creds() returns after
> sharing the parent's credentials instead of allocating new ones.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  kernel/cred.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> 
> diff --git a/kernel/cred.c b/kernel/cred.c
> index f89c5e5..056ec90 100644
> --- a/kernel/cred.c
> +++ b/kernel/cred.c
> @@ -299,6 +299,7 @@ int copy_creds(struct task_struct *p, unsigned long clone_flags)
>  #endif
>  		p->real_cred = get_cred(p->cred);
>  		get_cred(p->cred);
> +		atomic_inc(&p->cred->user->processes);
>  		return 0;
>  	}
>  
> 

-- 
James Morris
<jmorris@namei.org>
