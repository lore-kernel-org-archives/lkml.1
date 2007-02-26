Return-Path: <linux-kernel-owner+w=401wt.eu-S1030326AbXBZRLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030326AbXBZRLP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 12:11:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030342AbXBZRLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 12:11:15 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:37162 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030326AbXBZRLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 12:11:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=srtWPe+enPXG+v+mi7fIcaUdQX3WcLisHe0TncqYTMK1O5wT8YCjCU9YEJDqfbidy8woMwF8Klsmei1eyWBRro5x+BlL2et1EwjeW4ufLuVCR7tiv/ixNolTjCGwZCiTqKLhY/F6GhPWdI/+9G4s0cS7kuVJRLu3JuQU3rC6LLo=
Date: Mon, 26 Feb 2007 20:08:10 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Dan Aloni <da-x@monatomic.org>
Cc: linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: Re: e2b2rom_init_one():  Unable to register resource
Message-ID: <20070226170810.GA10223@cvg>
References: <20070217212918.GA26554@localdomain> <20070219155829.GA10111@cvg> <45DA139D.7070807@monatomic.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45DA139D.7070807@monatomic.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 19, 2007 at 11:16:13PM +0200, Dan Aloni wrote:
| Cyrill Gorcunov wrote:
| >Hi, Dan
| >
| >did you try setup forsed 8MB value on window->phys?
| >
| >  
| Actually, I tried to force it at 4MB starting at 0xff800000 since it 
| made much sense looking at the e820 map. Or maybe I misunderstood 
| something. It crashed with this:
| 
| <7>[ 9237.432181] esb2rom: esb2rom_init_one(): Unable to register 
| resource 0xff800000-0xffbfffff - kernel bug?
| <1>[ 9237.432262] Unable to handle kernel paging request at 
| ffffc20010500000 RIP:
| <1>[ 9237.436910] [<ffffffff8041f7ba>] cfi_probe_chip+0x14a/0x10e0
| <4>[ 9237.445246] PGD 12fc20067 PUD 12fc21067 PMD 12fcf6067 PTE 0
| <0>[ 9237.451057] Oops: 0002 [1] SMP
| <0>[ 9237.454346] do_IRQ: 1.251 No irq handler for vector
| 
| I can dump here the disassembly of cfi_probe_chip if it's interesting...
| 
| -- 
| Dan Aloni
| XIV LTD, http://www.xivstorage.com
| da-x (at) monatomic.org, dan (at) xiv.co.il
| 

Hi Dan,

what's new with the problem? Did you get any solution? Btw, I've read
the comments in esb2rom.c and because it's grown from ichxrom.c it seems
esb2rom.c has a bug in esb2rom_init_one(). Actually I think you should
receive a message like this:

	"Rom window is closed"

as it's done in ichxrom.c because you've got

	pci_read_config_byte : 4

and that's not the number esb2rom_init_one is expecting to process with...

		Cyrill

