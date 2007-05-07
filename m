Return-Path: <linux-kernel-owner+w=401wt.eu-S966144AbXEGSe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966144AbXEGSe4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 14:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754675AbXEGSex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 14:34:53 -0400
Received: from terminus.zytor.com ([192.83.249.54]:56912 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096AbXEGSew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 14:34:52 -0400
Message-ID: <463F712F.90902@zytor.com>
Date: Mon, 07 May 2007 11:34:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH] deflate inflate_dynamic too
References: <4632AF57.1070102@goop.org>
In-Reply-To: <4632AF57.1070102@goop.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> inflate_dynamic() has piggy stack usage too, so heap allocate it too.
> I'm not sure it actually gets used, but it shows up large in "make
> checkstack".

It might be worth reverting some of the code back to the zlib original.
 The use of stack allocations here is actually a Linux divergence from
zlib (done by Linus), in order to reduce the number of dynamic allocations.

In general, the use of dynamic allocations is highly dangerous, because
any time you have dynamic allocations you have the choice of either
sleeping or failing, unless you have a pre-reserved memory pool.

	-hpa
