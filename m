Return-Path: <linux-kernel-owner+w=401wt.eu-S932226AbXBSN0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226AbXBSN0J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 08:26:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932227AbXBSN0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 08:26:08 -0500
Received: from jdi.jdi-ict.nl ([82.94.239.5]:37628 "EHLO jdi.jdi-ict.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932226AbXBSN0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 08:26:07 -0500
Date: Mon, 19 Feb 2007 14:25:14 +0100 (CET)
From: Igmar Palsenberg <i.palsenberg@jdi-ict.nl>
X-X-Sender: igmar@jdi.jdi-ict.nl
To: erich <erich@areca.com.tw>
cc: Andrew Morton <akpm@osdl.org>, linux kernel <linux-kernel@vger.kernel.org>,
       npiggin@suse.de
Subject: Re: 2.6.16.32 stuck in generic_file_aio_write()
In-Reply-To: <000501c74998$79b41490$4e00a8c0@erich2003>
Message-ID: <Pine.LNX.4.58.0702191416120.9979@jdi.jdi-ict.nl>
References: <Pine.LNX.4.58.0611291329060.18799@jdi.jdi-ict.nl>
 <20061130212248.1b49bd32.akpm@osdl.org> <Pine.LNX.4.58.0612010926030.31655@jdi.jdi-ict.nl>
 <Pine.LNX.4.58.0612042201001.14643@jdi.jdi-ict.nl>
 <Pine.LNX.4.58.0612061615550.24526@jdi.jdi-ict.nl> <20061206074008.2f308b2b.akpm@osdl.org>
 <Pine.LNX.4.58.0612070940590.28683@jdi.jdi-ict.nl>
 <Pine.LNX.4.58.0612071328030.9115@jdi.jdi-ict.nl>
 <Pine.LNX.4.58.0612140912010.30202@jdi.jdi-ict.nl> <20061214004213.13149a48.akpm@osdl.org>
 <Pine.LNX.4.58.0612140953080.9623@jdi.jdi-ict.nl> <20061214011042.7b279be6.akpm@osdl.org>
 <Pine.LNX.4.58.0702051118230.30521@jdi.jdi-ict.nl> <000501c74998$79b41490$4e00a8c0@erich2003>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (jdi.jdi-ict.nl [127.0.0.1]); Mon, 19 Feb 2007 14:25:15 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

> I can not make sure it is hardware problem, but I have interest in this 
> case's reproducing.
> If you tell me your platform's construction, I will try it and give you good 
> solution.
> Does your RAID adapter's firmware version work on 1.42?
> Areca firmware had fix some hardware bugs and rare sg length handle in this 
> version.

I've hacked up the sysrq code so that it gives me another command : j , 
which dumps the current IRQ status on the console :

SysRq : Show IRQ status
......
Showing info for IRQ 14
status         :
depth          : 0
wake_depth     : 0
irq_count      : 38717
irqs_unhandled : 0

Showing info for IRQ 15
status         : DISABLED
depth          : 1
wake_depth     : 0
irq_count      : 22
irqs_unhandled : 0

which is a the (incomplete) result on my machine after loading a module 
that does disable_irq(15) on module load.

I've put the patch at http://www.jdi-ict.nl/areca/sysrq-j.patch
I'll do a follow-up when anything usefull comes out.


Regards,


	Igmar

