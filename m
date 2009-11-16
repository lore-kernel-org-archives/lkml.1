Return-Path: <linux-kernel-owner+w=401wt.eu-S1752783AbZKPQ53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbZKPQ53 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 11:57:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752494AbZKPQ53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 11:57:29 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55417 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbZKPQ52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 11:57:28 -0500
Date: Mon, 16 Nov 2009 16:57:16 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Brian Swetland <swetland@google.com>
Cc: Pavel Machek <pavel@ucw.cz>, Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/3] msm: add minimal board file for HTC Dream device
Message-ID: <20091116165716.GD3568@n2100.arm.linux.org.uk>
References: <20091102104949.GA23456@elf.ucw.cz> <20091116163659.GB3568@n2100.arm.linux.org.uk> <a55d774e0911160843h22938604s8966a58ee71992a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a55d774e0911160843h22938604s8966a58ee71992a@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 16, 2009 at 08:43:20AM -0800, Brian Swetland wrote:
> What's the best way to handle a situation where there is no valid
> debug uart?  Could the arch/platform require DEBUG_LL be unset via
> Kconfig directives if it is configured in a way where there is no
> valid debug uart?

You're the first to have that issue.  Everyone else has a UART they
can always direct stuff at.

However, I believe you're making the issue far larger than it really is.

1. If you define the DEBUG_LL macros to be empty, printascii() etc will
   not touch any mapping.

2. If no mapping is going to be touched by printascii(), does it matter
   whether a UART is mapped via this early mapping stuff?

The answer to (2) is no.

So, you can still arrange for these fields to be populated with a valid
value even if you don't intend to use the resulting mapping.  And so
there's no need to force DEBUG_LL to be unset.

If you really have no values you can use, make sure you set io_pg_offst
to 0x3ffc - the last offset in the L1 page table.  This will cause the
code to write a single dummy entry at the very top of the page table,
which will then be overwritten by the generic ARM arch code for its own
use.
