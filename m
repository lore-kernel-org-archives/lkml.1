Return-Path: <linux-kernel-owner+w=401wt.eu-S1751807AbZGaOkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807AbZGaOkH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 10:40:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751317AbZGaOkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 10:40:06 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55792 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbZGaOkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 10:40:05 -0400
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Robert Hancock <hancockrwd@gmail.com>,
       Corrado Zoccolo <czoccolo@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
       venkatesh.pallipadi@intel.com
Subject: Re: Dynamic configure max_cstate
From: Andi Kleen <andi@firstfloor.org>
References: <20090727073338.GA12669@rhlx01.hs-esslingen.de>
	<1248748935.2560.669.camel@ymzhang>
	<4e5e476b0907280020x242d9ef7gfa05c3d7b66f941f@mail.gmail.com>
	<1248771635.2560.682.camel@ymzhang>
	<20090728101135.GA22358@rhlx01.hs-esslingen.de>
	<4A726844.7040505@gmail.com> <1249024006.2560.735.camel@ymzhang>
	<20090731080728.GA25049@rhlx01.hs-esslingen.de>
Date: Fri, 31 Jul 2009 16:40:01 +0200
In-Reply-To: <20090731080728.GA25049@rhlx01.hs-esslingen.de> (Andreas Mohr's message of "Fri, 31 Jul 2009 10:07:28 +0200")
Message-ID: <87prbg3ohq.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Mohr <andi@lisas.de> writes:

> Instead we should strive for a far-reaching _generic_ mechanism
> which gathers average latencies of various I/O activities/devices
> and then uses some formula to determine the maximum (not necessarily ACPI)
> idle latency that we're willing to endure (e.g. average device I/O reply latency
> divided by 10 or so).

The interrupt heuristics in the menu cpuidle governour are already
attempting this, based on interrupt rates (or rather
wakeup rates) which are supposed to roughly correspond with IO rates
and scheduling events together.

Apparently that doesn't work in this case. The challenge would
be to find out why and improve the menu algorithm to deal with it.
I doubt a completely new mechanism is needed or makes sense.

> And in addition to this, we should also take into account (read: skip)
> any idle states which kill busmaster DMA completely
> (in case of busmaster DMA I/O activities, that is)

This is already done.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
