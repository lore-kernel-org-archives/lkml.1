Return-Path: <linux-kernel-owner+w=401wt.eu-S1753156AbZKSOBE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156AbZKSOBE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 09:01:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752373AbZKSOBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 09:01:03 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47101 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752090AbZKSOBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 09:01:03 -0500
Date: Thu, 19 Nov 2009 14:02:59 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH 4/5] pata: Update experimental tags
Message-ID: <20091119140259.2fee86e2@lxorguk.ukuu.org.uk>
In-Reply-To: <200911182056.16517.bzolnier@gmail.com>
References: <20091117144450.15430.83450.stgit@localhost.localdomain>
	<20091118184125.623e063d@lxorguk.ukuu.org.uk>
	<200911182007.07405.bzolnier@gmail.com>
	<200911182056.16517.bzolnier@gmail.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> BTW we can immediately reclaim 300 LOC by simply merging drivers back..

LoC - lines of comments ? (at least half of them).

Been testing a bit before fixing up the pata_hpt drivers. Resume from S2R
doesn't work with drivers/ide/hpt366.c. So it may have code for resume
but it doesn't actually work for all the chips.

Reason is fairly obvious - the PCI speed detection logic is broken except
for the case of a PC boot where the ROM BIOS for the HPT3xx is run. That
doesn't occur on a resume from RAM so a 66MHz clocked motherboard device
comes back with the speed guessed wrongly.
