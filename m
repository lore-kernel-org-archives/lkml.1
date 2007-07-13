Return-Path: <linux-kernel-owner+w=401wt.eu-S937240AbXGMTkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937240AbXGMTkG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 15:40:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760675AbXGMTj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 15:39:56 -0400
Received: from ccerelrim03.cce.hp.com ([161.114.21.24]:37163 "EHLO
	ccerelrim03.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760235AbXGMTjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 15:39:55 -0400
From: "Paul Moore" <paul.moore@hp.com>
Subject: Re: The art of breaking userspace (was Re: [GIT] SELinux changes 	for 2.6.23 (updated))
Date: 13 Jul 2007 15:39:00 -0400
To: <sds@tycho.nsa.gov>
X-Mailer: ChatterEmail+ for Treo 6xx/700p (3.0.8)
Message-ID: <3267185975.233965@mail.hp.com>
Cc: <michal.k.k.piotrowski@gmail.com>, <jmorris@namei.org>,
       <torvalds@linux-foundation.org>, <linux-kernel@vger.kernel.org>
X-PMX-Version: 5.3.1.294258, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2007.7.13.122733
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----Original Message-----
From: Stephen Smalley <sds@tycho.nsa.gov>
Date: Friday, Jul 13, 2007 3:30 pm
Subject: Re: The art of breaking userspace (was Re: [GIT] SELinux changes 	for 2.6.23 (updated))
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
CC: Paul Moore <paul.moore@hp.com>, jmorris@namei.org,	torvalds@linux-foundation.org, linux-kernel@vger.kernel.org

On Fri, 2007-07-13 at 21:08 +0200, Michal Piotrowski wrote:
> Paul Moore pisze:
> [..]
> > On Fri, 13 Jul 2007, Michal Piotrowski wrote:
> >> My system is too secure, I can not login :)
> >>
> >> Do you have CONFIG_NETLABEL=y ?
> >>
> >> If so, please try disabling it.
> > 
> > Disabling NetLabel should solve the problem.
> 
> Disabling NetLabel solves the problem.
> 
> >  The recommended solution to this problem, as discussed on the SELinux list and mentioned in the patch description, is to upgrade your SELinux policy to the latest Reference Policy sources.  For those with custom SELinux policy, the patch description explains the changes to the SELinux policy required. 
> 
> I'm sorry to say this, but this kind of patches should not be accepted.
> 
> Patch
> 
> commit 9faf65fb6ee2b4e08325ba2d69e5ccf0c46453d0
> Author: Paul Moore <paul.moore@hp.com>
> Date:   Fri Jun 29 11:48:16 2007 -0400
> 
>     SELinux: use SECINITSID_NETMSG instead of SECINITSID_UNLABELED for NetLabel
> 
>     These changes will make NetLabel behave like labeled IPsec where there is an
>     access check for both labeled and unlabeled packets as well as providing the
>     ability to restrict domains to receiving only labeled packets when NetLabel
>     is in use.  The changes to the policy are straight forward with the
>     following necessary to receive labeled traffic (with SECINITSID_NETMSG
>     defined as "netlabel_peer_t"):
> 
>      allow mydom_t netlabel_peer_t:{ tcp_socket udp_socket rawip_socket } recvfrom;
> 
>     The policy for unlabeled traffic would be:
> 
>      allow mydom_t unlabeled_t:{ tcp_socket udp_socket rawip_socket } recvfrom;
> 
>     These policy changes, as well as more general NetLabel support, are included
>     in the SELinux Reference Policy SVN tree, r2352 or later.  Users who enable
>     NetLabel support in the kernel are strongly encouraged to upgrade their
>     policy to avoid network problems.
> 
>     Signed-off-by: Paul Moore <paul.moore@hp.com>
>     Signed-off-by: James Morris <jmorris@namei.org>
> 
> 
> breaks systems with recent selinux policy.
> 
> (rpm -qa selinux-policy-*
> selinux-policy-devel-2.6.4-25.fc7
> selinux-policy-targeted-2.6.4-25.fc7)
> 
> I will add this as a regression unless Linus says "Fsck it! We don't care about compatibility"
>
>Agreed, it needs to be fixed in the netlabel code.

I'm stuck in the airport right now but I will send a patch out later tonight.

. paul moore
. linux security @ hp


