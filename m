Return-Path: <linux-kernel-owner+w=401wt.eu-S1751572AbXCKUEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572AbXCKUEj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 16:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932195AbXCKUEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 16:04:39 -0400
Received: from smtp.osdl.org ([65.172.181.24]:57211 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597AbXCKUEi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 16:04:38 -0400
Date: Sun, 11 Mar 2007 13:04:28 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Paul Rolland <rol@as2917.net>
cc: "'Tejun Heo'" <htejun@gmail.com>, "'Jeff Garzik'" <jeff@garzik.org>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       linux-ide@vger.kernel.org, "'LKML'" <linux-kernel@vger.kernel.org>,
       "'Eric D. Mudama'" <edmudama@gmail.com>
Subject: RE: [git patches] libata fixes
In-Reply-To: <017f01c7640b$fbcafab0$2101a8c0@donald>
Message-ID: <Pine.LNX.4.64.0703111257180.9690@woody.linux-foundation.org>
References: <017f01c7640b$fbcafab0$2101a8c0@donald>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 11 Mar 2007, Paul Rolland wrote:
> 
> Nope... I tried several patches from Tejun, and also some that Jeff posted
> to linux-ide, but no luck. The only way to have this DVD-RW working is to
> use irqpoll on the command line...

So it has *never* worked? That's what I'm trying to see - you had a 
"before" and "after" dmesg in one of your posts, and the "before" one 
looked fine (as if it was working) because it didn't have the error 
messages.

So I'm just trying to figure out where the regression started...

> To complete, here are some more output from the machine : 

What happens if you disable MSI entirely? Use "pci=nomsi" on the command 
line.

The

	ata2.00: qc timeout (cmd 0xec)
	ata2.00: failed to IDENTIFY (I/O error, err_mask=0x104)

messages happen for you on the controller that claims MSI:

	ata2: SATA max UDMA/133 cmd 0xffffc2000008a980 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 504

and quite frankly, we've had lots of bugs with MSI, both in hardware and 
in software.

		Linus
