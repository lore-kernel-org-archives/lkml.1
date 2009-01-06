Return-Path: <linux-kernel-owner+w=401wt.eu-S1753278AbZAFBaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbZAFBaP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 20:30:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbZAFB37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 20:29:59 -0500
Received: from mga01.intel.com ([192.55.52.88]:1449 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293AbZAFB36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 20:29:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,334,1228118400"; 
   d="scan'208";a="419911380"
Message-ID: <4962B414.8010601@intel.com>
Date: Mon, 05 Jan 2009 18:29:56 -0700
From: Dan Williams <dan.j.williams@intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
CC: "haavard.skinnemoen@atmel.com" <haavard.skinnemoen@atmel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "hskinnemoen@atmel.com" <hskinnemoen@atmel.com>,
       "Sosnowski, Maciej" <maciej.sosnowski@intel.com>,
       "ralf@linux-mips.org" <ralf@linux-mips.org>
Subject: Re: [PATCH] dmatest: flush and invalidate destination buffer before
 DMA
References: <20081227111037.3bd13adc@hskinnemoen-d830>	<20081229.025352.01917409.anemo@mba.ocn.ne.jp>	<e9c3a7c20901051031y528d0d31r18d44c5096c59e0@mail.gmail.com> <20090106.101425.109407744.nemoto@toshiba-tops.co.jp>
In-Reply-To: <20090106.101425.109407744.nemoto@toshiba-tops.co.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Atsushi Nemoto wrote:
> On Mon, 5 Jan 2009 11:31:57 -0700, "Dan Williams" <dan.j.williams@intel.com> wrote:
> Yes, MIPS and ARM do different thing on partial cache line.  But I
> suppose this belongs to "implementation dependent" area of DMA API so
> users of the API should not depend on it.  (Well, maybe I'm biased to
> MIPS ;-))
> 
> In general, drivers must not put normal data and DMA buffer on same
> cacheline anyway to avoid unexpected writeback and data loss.  So this
> ambiguity is not a problem.  IMHO writeback of the partial line for
> DMA_FROM_DEVICE just _hides_ abusing of the DMA API and potential data
> loss.

Hmm... one implementation does the right thing in all cases.  The other 
silently allows data corruption unless each callsite that accidentally 
or purposely passes cacheline-unaligned buffers adds extra maintenance 
code.  Which implementation are you biased towards now? :-).

--
Dan

