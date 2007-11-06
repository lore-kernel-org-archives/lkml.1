Return-Path: <linux-kernel-owner+w=401wt.eu-S1756754AbXKFBUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754AbXKFBUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 20:20:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755582AbXKFBUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 20:20:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51284 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755536AbXKFBUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 20:20:07 -0500
Message-ID: <472FC130.40605@zytor.com>
Date: Mon, 05 Nov 2007 17:19:44 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ray Lee <ray-lk@madrabbit.org>,
       =?ISO-8859-1?Q?Bo_Brant=E9n?= <bosse@acc.umu.se>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: x86_64 ten times slower than i386
References: <Pine.A41.4.64.0711031329490.397338@stalin.acc.umu.se> <20071103162640.GS17536@waste.org> <Pine.A41.4.64.0711032334170.770224@stalin.acc.umu.se> <Pine.A41.4.64.0711051110530.803034@stalin.acc.umu.se> <Pine.A41.4.64.0711051657440.291004@stalin.acc.umu.se> <2c0942db0711050832t5207ea8bib1f75e59e071ade2@mail.gmail.com> <20071106002647.GA27182@one.firstfloor.org>
In-Reply-To: <20071106002647.GA27182@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> Jesse Barnes (cc:d) wrote a patch to address this, I think (x86: trim
>> memory not covered by WB MTRRs), but as far as I can tell it hasn't
>> been merged yet. System is Intel, 4gb of RAM.
> 
> It wasn't merged because it broke booting on some systems.
> Besides the memory would be still lost -- all it did was to automate
> the "mem=XXXX" line.

There really are only two ways to deal with this -- drop the memory 
(which should be automated, and a warning printed) or adjust the MTRRs. 
  The problem is that at some point we run out of MTRRs, partially 
because they're masks instead of base/limit.

Even use of PAT doesn't trivially resolve this issue with less than 
doing MTRR emulation via PAT (setting the default MTRR to WB); however, 
that is bound to cause trouble with SMM.

	-hpa
