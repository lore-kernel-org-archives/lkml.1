Return-Path: <linux-kernel-owner+w=401wt.eu-S933329AbYGQVcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933329AbYGQVcf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 17:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760272AbYGQVc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 17:32:26 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:6894 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760551AbYGQVcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 17:32:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Tc6uBB/v+dcYDXdIgz7lZt8cT64JgoVZRWmjRvmWbQDGM40o88YOit0GfNBMKjOM/Y
         OPlCF1poul2G597iJfKagroLCRViwW7S/mwdp3Z1R3n84Tv5j6oNtEwv3N+9VMF8k5Eb
         knvH6nBXi5V2skkDMBGTbXnfyk2zI0lOBHrr8=
Date: Fri, 18 Jul 2008 01:29:39 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, linux-kernel@vger.kernel.org,
       Davide Libenzi <davidel@xmailserver.org>, stable@kernel.org
Subject: Re: [PATCH] Fix build on COMPAT platforms when CONFIG_EPOLL is
	disabled.
Message-ID: <20080717212939.GA9945@martell.zuzino.mipt.ru>
References: <20080718.003108.128619119.anemo@mba.ocn.ne.jp> <20080717142314.1aeb2f58.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080717142314.1aeb2f58.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 02:23:14PM -0700, Andrew Morton wrote:
> On Fri, 18 Jul 2008 00:31:08 +0900 (JST)
> Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:
> 
> > Add missing cond_syscall() entry for compat_sys_epoll_pwait.
> > 
> > Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> > ---
> > diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
> > index 5b9b467..0fea0ee 100644
> > --- a/kernel/sys_ni.c
> > +++ b/kernel/sys_ni.c
> > @@ -59,6 +59,7 @@ cond_syscall(sys_epoll_create);
> >  cond_syscall(sys_epoll_ctl);
> >  cond_syscall(sys_epoll_wait);
> >  cond_syscall(sys_epoll_pwait);
> > +cond_syscall(compat_sys_epoll_pwait);
> >  cond_syscall(sys_semget);
> >  cond_syscall(sys_semop);
> >  cond_syscall(sys_semtimedop);
> 
> Interesting.  It appears that both 2.6.25.x and 2.6.26.x need this
> fix as well.

IIRC, this happens for other syscalls as well. IIRC, timerfd ones.

