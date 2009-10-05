Return-Path: <linux-kernel-owner+w=401wt.eu-S1758473AbZJED64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758473AbZJED64 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 23:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753636AbZJED6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 23:58:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60518
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752648AbZJED6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 23:58:54 -0400
Date: Sun, 04 Oct 2009 20:58:48 -0700 (PDT)
Message-Id: <20091004.205848.109978798.davem@davemloft.net>
To: david@fries.net
Cc: hancockrwd@gmail.com, linux-kernel@vger.kernel.org, d.stussy@yahoo.com,
       joao.ramos@inov.pt, torvalds@osdl.org, rjw@sisk.pl, vojtech@suse.cz
Subject: Re: [bisected] 2.6.31 regression sis5513 PIO Mode 0 hang
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091005025549.GA32331@spacedout.fries.net>
References: <20091003025415.GA28295@spacedout.fries.net>
	<4AC7F306.2040409@gmail.com>
	<20091005025549.GA32331@spacedout.fries.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Fries <david@fries.net>
Date: Sun, 4 Oct 2009 21:55:50 -0500

> First, if I'm going to do much debugging, how would I force the
> ethernet device to come up first so I have netconsole?
> 
> How is the problem patch,
> +       ide_port_for_each_dev(i, drive, hwif) {
> +               if (port_ops && port_ops->set_pio_mode)
> +                       port_ops->set_pio_mode(drive, 0);
> +       }
> 
> Different from using hdparm to set the mode?  I do this,
> hdparm -p 0 /dev/hda
> hdparm -X pio0 /dev/hda
> and the benchmarks give me about what I would expect 7MB/s instead of
> the normal 40MB/s.
> 
> Then I can re-enable with,
> hdparm -p 4 /dev/hda
> hdparm -X udma5 /dev/hda
> hdparm -d 1 /dev/hda
> hda: UDMA/100 mode selected
> and the drive is back up to speed, and obviously the kernel didn't
> freeze.  Should there be anything different between what the patch
> tried, and and hdparm's doing, other than kernel initiated and start
> and a user program later on?

>From your original hang trace I can only guess that the problematic
sequence is putting your CDROM into PIO0, then putting it into
PIO4, and then immediately reading the TOC.

This is what the ide-cd.c code does right about where you get the
hang.

Debugging this further is really totally pointless for a subsystem
that should be in deep maintainence mode, so I'm just going to
revert.

Thanks.
