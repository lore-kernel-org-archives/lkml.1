Return-Path: <linux-kernel-owner+w=401wt.eu-S1754230AbXLCBay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbXLCBay (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 20:30:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750813AbXLCBar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 20:30:47 -0500
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:40413 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751804AbXLCBaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 20:30:46 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=KrV4FuzMvpQzdkxHWTANWi54iSr2CAxBTD9ZJe/YxIgSbZE+ihsrRDmgeglCi+Eg22RSJHkR1Tu4tPvSdNlY2vlPQ3T3nooKmHOkPtY09icYNQbpvK00sQvnyR7lsxY+42/knydPSHcaUsM5c1Skr1bbuHFTKBPOG0IIVt4kTWc=  ;
X-YMail-OSG: jXOmYTMVM1lP7wFKWQtMVwZI3P8PkuMBXRoPG.IBqcgY9waJHk3HZgzcY8J3qjdImBT5DDXNDg--
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: blackfin compile error
Date: Sun, 2 Dec 2007 17:30:43 -0800
User-Agent: KMail/1.9.6
Cc: "Bryan Wu" <cooloney.lkml@gmail.com>, "Adrian Bunk" <bunk@kernel.org>,
       "Bryan Wu" <bryan.wu@analog.com>, linux-kernel@vger.kernel.org
References: <20071202004204.GE15974@stusta.de> <200712012259.06493.david-b@pacbell.net> <20071201230501.dac3b217.akpm@linux-foundation.org>
In-Reply-To: <20071201230501.dac3b217.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712021730.44208.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 01 December 2007, Andrew Morton wrote:
> I have all these:
> 
> spi-at25-driver-is-for-eeprom-not-flash.patch

I'd be tempted to merge that since it's documentation-only,
and I like to see such stuff merged ASAP.  But otherwise
it's non-essential.

> spi-use-mutex-not-semaphore.patch

Non-essential.

> spi-simplify-spi_sync-calling-convention.patch
> spi-use-simplified-spi_sync-calling-convention.patch

The first one fixes some minor bugs, so would be good to merge.

The second does minor associated cleanup ... non-essential.

> #
> spi-initial-bf54x-spi-support.patch
> spi-bfin-spi-uses-portmux-calls.patch
> spi-spi_bfin-cleanups-error-handling.patch
> spi-spi_bfin-handles-spi_transfercs_change.patch
> spi-spi_bfin-dont-bypass-spi-framework.patch
> spi-spi_bfin-uses-platform-device-resources.patch
> spi-spi_bfin-uses-portmux-for-additional-busses.patch
> spi-spi_bfin-rearrange-portmux-calls.patch
> spi-spi_bfin-change-handling-of-communication-parameters.patch
> spi-spi_bfin-relocate-spin-waits.patch
> spi-spi_bfin-handle-multiple-spi_masters.patch
> spi-spi_bfin-bugfix-for-816-bit-word-sizes.patch
> spi-spi_bfin-update-handling-of-delay-after-deselect.patch
> spi-spi_bfin-resequence-dma-start-stop.patch
> #
> blackfin-spi-driver-use-cpu_relax-to-replace-continue-in-while-busywait.patch
> blackfin-spi-driver-use-void-__iomem-for-regs_base.patch
> blackfin-spi-driver-move-hard-coded-pin_req-to-board-file.patch
> blackfin-spi-driver-reconfigure-speed_hz-and-bits_per_word-in-each-spi-transfer.patch

The fix to the compile error is in the next-to-last of these.
Bryan says they're highly interdependent, and they also
include quite a number of bugfixes (some "critical") that
have been used in Analog's treee for many months now.

That makes sense to me, since they've been bouncing around
for quite a while now.  I'd be OK with merging all of them;
if something breaks, it'd be no worse than the current state
(and would only affect Blackfin).


> atmel_spi-throughput-improvement.patch
> atmel_spi-chain-dma-transfers.patch
> atmel_spi-fix-dmachain-oops-with-debug-enabled.patch

Those can wait; they're performance updates.

 
> queued for 2.6.25.  If some of them need to be bumped up to 2.6.24: which
> ones and why?

I'd say all those Blackfin patches should go, and the one
calling convention patch, are appropriate as bugfixes.
And the doc patch, unless there's a reason to hold it back.

- Dave


