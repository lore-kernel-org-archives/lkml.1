Return-Path: <linux-kernel-owner+w=401wt.eu-S933169AbXAaMau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933169AbXAaMau (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 07:30:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933143AbXAaMau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 07:30:50 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:56368 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933170AbXAaMat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 07:30:49 -0500
Message-ID: <45C08BF7.4000605@garzik.org>
Date: Wed, 31 Jan 2007 07:30:47 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: James Ray <j.ray@qmul.ac.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: ahci SATA with Intel ESB2 on 2.6.20-rc6
References: <45C0708C.3000609@qmul.ac.uk>
In-Reply-To: <45C0708C.3000609@qmul.ac.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Ray wrote:
> [2.] Full description of the problem/report:
> 	Been having problems with the AHCI driver for this new server for quite
> some time now, it slowly seems to be getting better as the version
> numbers increase (2.6.15 seemed fine, though I didn't test much,
> 2.6.1[7-8] was unusable, 2.6.20-rc6 seems nearly perfect) but I still
> see some errors appearing on the system. I have swapped disks in the
> system and I see the problem with 3 different systems (all identical)
> and 3 different sets of disks.

Good to hear that we suck less, over time, I suppose :)

> This is the error message that appears:
> Jan 31 10:01:50 termite kernel: ata2.00: exception Emask 0x10 SAct
> 0x7fffffff SErr 0x80002 action 0x2 frozen
> Jan 31 10:01:50 termite kernel: ata2.00: (irq_stat 0x08000000, interface
> fatal error)
> Jan 31 10:01:50 termite kernel: ata2.00: cmd
> 61/00:00:51:8f:ab/04:00:02:00:00/40 tag 0 cdb 0x0 data 524288 out
> Jan 31 10:01:50 termite kernel:          res
> 40/00:4c:51:9b:ab/00:00:02:00:00/40 Emask 0x10 (ATA bus error)
> Jan 31 10:01:50 termite kernel: ata2.00: cmd
> 61/00:08:39:47:ab/04:00:02:00:00/40 tag 1 cdb 0x0 data 524288 out
> Jan 31 10:01:50 termite kernel:          res
> 40/00:4c:51:9b:ab/00:00:02:00:00/40 Emask 0x10 (ATA bus error)
> Jan 31 10:01:50 termite kernel: ata2.00: cmd
> 61/00:10:51:93:ab/04:00:02:00:00/40 tag 2 cdb 0x0 data 524288 out
> Jan 31 10:01:50 termite kernel:          res
> 40/00:4c:51:9b:ab/00:00:02:00:00/40 Emask 0x10 (ATA bus error)
> Jan 31 10:01:50 termite kernel: ata2.00: cmd
> 61/00:18:39:43:ab/04:00:02:00:00/40 tag 3 cdb 0x0 data 524288 out
> Jan 31 10:01:50 termite kernel:          res
> 40/00:4c:51:9b:ab/00:00:02:00:00/40 Emask 0x10 (ATA bus error)

This really looks like some sort of cable or power problem, or some 
other hardware problem.

HOWEVER...  once thing you might try is disabling NCQ 
(http://linux-ata.org/faq.html#ncq) in case its a device with a buggy 
NCQ implementation.

	Jeff


