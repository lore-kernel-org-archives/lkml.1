Return-Path: <linux-kernel-owner+w=401wt.eu-S1754579AbYHJLdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbYHJLdT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 07:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752998AbYHJLdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 07:33:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48906 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752896AbYHJLdC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 07:33:02 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080810113044.19143b0a@worthy.swandive.local>
References: <20080810113044.19143b0a@worthy.swandive.local> <1218322518.3268.0.camel@luna.unix.geek.nz> <1218287473.3155.13.camel@dhcppc0> <1218281190.3155.5.camel@dhcppc0> <1218214935.3146.5.camel@dhcppc0> <alpine.LRH.1.10.0808090747150.29079@tundra.namei.org> <14476.1218286327@redhat.com> <15386.1218290826@redhat.com> <10251.1218361539@redhat.com> 
To: Grant Wilson <grant.wilson@zen.co.uk>
Cc: dhowells@redhat.com, Jasper Bryant-Greene <jasper@amiton.co.nz>,
       Thomas Meyer <thomas@m3y3r.de>, James Morris <jmorris@namei.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux-Next <linux-next@vger.kernel.org>
Subject: Re: next-20080808: bash: fork: Resource temporarily unavailable
X-Mailer: MH-E 8.0.3+cvs; nmh 1.3; GNU Emacs 23.0.50
Date: Sun, 10 Aug 2008 12:31:52 +0100
Message-ID: <13299.1218367912@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Wilson <grant.wilson@zen.co.uk> wrote:

> On Sun, 10 Aug 2008 10:45:39 +0100
> David Howells <dhowells@redhat.com> wrote:
> 
> [snip]
> > 
> > Are you running as an unprivileged user?  If so, this may be the point
> > that's biting you.  Can you try applying the attached patch to find more
> > information?
> [snip]
> I'm also experiencing this on an X86_64 system as an unprivileged user.

Thanks for your help.

> With your patch applied I get the following repeated several times
> during the boot, but with no apparent ill effects:
> 
> [   31.033195] copy_process() = -513 

That's probably nothing to worry about.  It -ERESTARTNOINTR, indicating, I
would guess, that fork() was interrupted by a signal.

> When the fork call starts to fail after a few minutes the following is logged:
> 
> [  223.039938] Rlimit EAGAIN (-1 >= 16375, uid 1000)
> [  223.044744] copy_process() = -11
> [  226.660319] Rlimit EAGAIN (-1 >= 16375, uid 1000)
> [  226.664166] copy_process() = -11

Okay.  That's useful, thanks.  That indicates that my accounting of user
processes is incorrect somewhere.  This won't show up when running as a
privileged user only.

David
