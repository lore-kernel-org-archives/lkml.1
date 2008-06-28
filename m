Return-Path: <linux-kernel-owner+w=401wt.eu-S1753592AbYF1OBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592AbYF1OBi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 10:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753368AbYF1OBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 10:01:25 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:49805 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757888AbYF1OBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 10:01:23 -0400
Date: Sat, 28 Jun 2008 16:01:21 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, kernel@avr32linux.org,
       shannon.nelson@intel.com, David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH v4 6/6] Atmel MCI: Driver for Atmel on-chip MMC
 controllers
Message-ID: <20080628160121.10c7c1b0@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <20080628154515.0eb002f6@mjolnir.drzeus.cx>
References: <1214486603-23655-1-git-send-email-haavard.skinnemoen@atmel.com>
	<1214486603-23655-2-git-send-email-haavard.skinnemoen@atmel.com>
	<1214486603-23655-3-git-send-email-haavard.skinnemoen@atmel.com>
	<1214486603-23655-4-git-send-email-haavard.skinnemoen@atmel.com>
	<1214486603-23655-5-git-send-email-haavard.skinnemoen@atmel.com>
	<1214486603-23655-6-git-send-email-haavard.skinnemoen@atmel.com>
	<1214486603-23655-7-git-send-email-haavard.skinnemoen@atmel.com>
	<20080627211014.0e80db04@siona.local>
	<20080627215627.5d75639c@mjolnir.drzeus.cx>
	<20080628144313.353bbf18@hskinnemo-gx745.norway.atmel.com>
	<20080628154515.0eb002f6@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jun 2008 14:01:09.0503 (UTC) FILETIME=[6A9300F0:01C8D927]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman <drzeus-list@drzeus.cx> wrote:
> On Sat, 28 Jun 2008 14:43:13 +0200
> Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:
> 
> > Tests 15 and 17 return -EILSEQ instead of -ETIMEDOUT. The at91_mci
> > driver has the same problem, and I think it's a hardware issue -- the
> > controller wrongly flags a CRC error instead of a data timeout error
> > if the card doesn't respond with any CRC status after a write. I don't
> > know how to work around that problem.  
> 
> If that's how the hardware behaves, then EILSEQ will have to do. The
> test is more about forcing people to do proper error management in the
> driver than anything else. Have a check that you don't report a bad
> bytes_xfered though.

bytes_xfered is 0 if any block failed. If I understand correctly, this
is good enough, but not optimal. I want to improve this later, but I
might need some more feedback from the DMA engine subsystem (e.g.
adding "actual" and "status" fields to the descriptor.)

The DMA slave interface isn't perfect yet, but I think the current
incarnation is actually useful and performs well even though it's very
basic. We can make incremental improvements later to improve error
reporting, offer more advanced control over the transfers, and support
other use cases better (e.g. audio.)

Haavard
