Return-Path: <linux-kernel-owner+w=401wt.eu-S1755331AbZHNVJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331AbZHNVJb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 17:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755260AbZHNVJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 17:09:31 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41903 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754867AbZHNVJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 17:09:30 -0400
Date: Fri, 14 Aug 2009 22:10:38 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: How to disable DMA for compact-flash disk?
Message-ID: <20090814221038.19e868a0@lxorguk.ukuu.org.uk>
In-Reply-To: <4A85CDCF.3060802@candelatech.com>
References: <4A81BDA6.4080804@candelatech.com>
	<20090811201206.14556624@lxorguk.ukuu.org.uk>
	<4A85CDCF.3060802@candelatech.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This worked fine, but now I'm having some more issues.  Using libata is 1/2
> as fast as using IDE mode.  I *think* the problem might be that libsata
> may not be using 32-bit PIO mode, but I'm not certain of that.  It seems
> that ide mode uses PIO2 v/s PIO4 for libsata too.

As of 2.6.29 libata doesn't use 32bit PIO (it shouldn't make a difference
for most chipsets but it does for some). 2.6.30 does for some and you can
turn it on for others if you want to test by inheriting
ata_bmdma32_port_ops instead of ata_bmdma_port_ops

> hdb: Ridata CF, CFA DISK drive
> hdb: host max PIO5 wanted PIO255(auto-tune) selected PIO2
> hdb: host max PIO5 wanted PIO255(auto-tune) selected PIO2

Very odd it picked PIO2, but the numbers you quote for hdparm doesn't
sound like PIO2 so its hard to guess.

> ata1.01: configured for PIO4

So libata picked a faster rate (PIO4 is the fastest the controller is
properly specced for according to my docs - it probably can do PIO5 (CF
specific))

> /dev/sda1:
>   Timing cached reads:   280 MB in  2.00 seconds = 139.98 MB/sec
>   Timing buffered disk reads:   10 MB in  3.69 seconds =   2.71 MB/sec

Would be very interested to know if bmdma32_port_ops gives you the speed.
