Return-Path: <linux-kernel-owner+w=401wt.eu-S1030200AbXA3ScO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030200AbXA3ScO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 13:32:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030201AbXA3ScO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 13:32:14 -0500
Received: from yumi.tdiedrich.de ([85.10.210.183]:3378 "EHLO yumi.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030200AbXA3ScN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 13:32:13 -0500
Date: Tue, 30 Jan 2007 19:32:08 +0100
From: Tobias Diedrich <ranma+kernel@tdiedrich.de>
To: linux-kernel@vger.kernel.org
Subject: Re: Forcedeth issues, loss of connectivity.  ASUS M2N32-SLI-D w/ AMD64
Message-ID: <20070130183208.GE11814@melchior.yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
	linux-kernel@vger.kernel.org
References: <45B91769.8060403@blue-labs.org> <loom.20070128T130718-569@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <loom.20070128T130718-569@post.gmane.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeroen Roodhart wrote:

> > Any "me toos" out there, any suggestions?
> 
> Big "me too" here. I use this board to run "workstation and home samba services"
> and it seems that under stress, the connection gets lost. Can't put my finger on
> the when/what/why too.

I've seen some issues with forcedeth too, but only with 2.6.20-rc5
and -rc6 as far as I can say.  The box stopped receiving packets, but a
"ifconfig eth0 promisc" 'fixed' it.
It happened rarely and I haven't been really able to reproduce it on
demand so far.
Looking through my syslog I think
|Jan 28 22:16:44 melchior kernel: [28411.397053] Losing some ticks... checking if CPU frequency changed.
|Jan 28 22:18:12 melchior kernel: [28488.534330] warning: many lost ticks.
|Jan 28 22:18:12 melchior kernel: [28488.534333] Your time source seems to be instable or some driver is hogging int
|Jan 28 22:18:12 melchior kernel: [28488.534350] rip nv_nic_irq_other+0x2/0x160 [forcedeth]
|Jan 28 22:18:12 melchior kernel: [28488.534352] Falling back to HPET
sounds suspicios.

|Jan 25 18:17:20 melchior kernel: [ 2875.164597] Losing some ticks... checking if CPU frequency changed.
|Jan 25 18:18:57 melchior kernel: [ 2929.230774] warning: many lost ticks.
|Jan 25 18:18:57 melchior kernel: [ 2929.230777] Your time source seems to be instable or some driver is hogging interupts
|Jan 25 18:18:57 melchior kernel: [ 2929.230785] rip handle_IRQ_event+0x1a/0x53
|Jan 25 18:18:57 melchior kernel: [ 2929.230787] Falling back to HPET

This is on an ASUS M2N-SLI Deluxe.

Right now, it again only works with eth0 promisc, but interrupts I
can at least see interrupts for all three registered eth0 msi
interrupt handlers:

|279:   13239534   PCI-MSI-edge      eth0
|280:    2515250   PCI-MSI-edge      eth0
|281:    6268650   PCI-MSI-edge      eth0
and "sleep 1" later:
|279:   13239635   PCI-MSI-edge      eth0
|280:    2515259   PCI-MSI-edge      eth0
|281:    6268661   PCI-MSI-edge      eth0

-- 
Tobias						PGP: http://9ac7e0bc.uguu.de
このメールは十割再利用されたビットで作られています。
