Return-Path: <linux-kernel-owner+w=401wt.eu-S1762709AbXGLXgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762709AbXGLXgd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 19:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758785AbXGLXg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 19:36:27 -0400
Received: from sceptre.pobox.com ([207.106.133.20]:44817 "EHLO
	sceptre.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755631AbXGLXg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 19:36:26 -0400
X-Greylist: delayed 97642 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Jul 2007 19:36:26 EDT
Date: Thu, 12 Jul 2007 18:37:19 -0500
From: Nathan Lynch <ntl@pobox.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: Weird oopses with 2.6.22-rc7
Message-ID: <20070712233719.GK17955@localdomain>
References: <alpine.DEB.0.99.0707130016270.18512@sheep.housecafe.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.0.99.0707130016270.18512@sheep.housecafe.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello-

Christian Kujau wrote:
> Hi there,
> 
> Since a few days I'm experiencing weird oopses on my iBook/G4 with 
> ubuntu's 2.6.22-7-powerpc and also with a vanilla 2.6.22-rc7-git8.
> 
> Now for the "weird" part: The oops happens when doing "make install" for 
> a piece of software (xine-ui media player) as *root*. No kidding, it 
> does NOT happen when I compile the software and do "make install" as a 
> normal user. This is 100% reproducible, here're some technical infos 
> before I go on describing whe I did:
> 
>  	http://nerdbynature.de/bits/2.6.22-rc7-git8/

Here's the first oops from the "dmesg" file:

 Unrecoverable FP Unavailable Exception 801 at efff20b0
 Oops: Unrecoverable FP Unavailable Exception, sig: 6 [#1]
 PREEMPT PowerMac
 Modules linked in:
 NIP: efff20b0 LR: c008dff4 CTR: efff20b0
 REGS: ef7cbd90 TRAP: 0801   Not tainted
t8)
 MSR: 00009032 <EE,ME,IR,DR>  CR: 28028428  XER: 00000000
 TASK = cfd9b800[1625] 'touch' THREAD: ef7ca000
 GPR00: efff20b0 ef7cbe40 cfd9b800 ec049240 00000002 ef7cbea0 00000000 0ff29604 
 GPR08: 00000001 eff78d00 ef7ca000 00000000 28022422 
 NIP [efff20b0] 0xefff20b0
 LR [c008dff4] permission+0x78/0x170
 Call Trace:
 [ef7cbe40] [00010942] 0x10942 (unreliable)
 [ef7cbe60] [c00ac440] do_utimes+0x1cc/0x1f4
 [ef7cbf10] [c00ac630] sys_utimensat+0xac/0x138
 [ef7cbf40] [c00118ec] ret_from_syscall+0x0/0x38


> Any ideas which magic syscall could cause these oopses?

Have you tried 2.6.22?  Linus committed a utimensat-related oops fix
right before releasing it:

http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=1e5de2837c166535f9bb4232bfe97ea1f9fc7a1c
