Return-Path: <linux-kernel-owner+w=401wt.eu-S1755917AbXKTAxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917AbXKTAxY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 19:53:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752548AbXKTAxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 19:53:15 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42808
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752350AbXKTAxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 19:53:14 -0500
Date: Mon, 19 Nov 2007 16:53:13 -0800 (PST)
Message-Id: <20071119.165313.163834190.davem@davemloft.net>
To: eranian@hpl.hp.com
Cc: paulus@samba.org, hch@infradead.org, akpm@linux-foundation.org,
       gregkh@suse.de, mucci@cs.utk.edu, wcohen@redhat.com,
       robert.richter@amd.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071119224845.GA27766@frankl.hpl.hp.com>
References: <20071119.050843.48408777.davem@davemloft.net>
	<18242.900.101842.261763@cargo.ozlabs.ibm.com>
	<20071119224845.GA27766@frankl.hpl.hp.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Eranian <eranian@hpl.hp.com>
Date: Mon, 19 Nov 2007 14:48:46 -0800

> Looks like we will have to use bytes (u8) instead.  This may have some
> performance impact as well. Several bitmaps are used in the context/interrupt
> routines. Even with u8, there is still a problem with the bitmap*() macros.
> Now, only a small subset of the bitmap() macros are used, so it may be okay
> to duplicate them for u8.

I think it would be fine to just create a set of bitop interfaces that
operate on u32 objects instead of "unsigned long".

Currently perfmon2 does not need the atomic variants at all, and those
could thus be provided entirely under include/asm-generic/bitops/
