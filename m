Return-Path: <linux-kernel-owner+w=401wt.eu-S1751413AbZGaIHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751413AbZGaIHb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 04:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751006AbZGaIHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 04:07:30 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:47619 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbZGaIH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 04:07:28 -0400
Date: Fri, 31 Jul 2009 10:07:28 +0200
From: Andreas Mohr <andi@lisas.de>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Robert Hancock <hancockrwd@gmail.com>, Andreas Mohr <andi@lisas.de>,
       Corrado Zoccolo <czoccolo@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: Re: Dynamic configure max_cstate
Message-ID: <20090731080728.GA25049@rhlx01.hs-esslingen.de>
References: <20090727073338.GA12669@rhlx01.hs-esslingen.de> <1248748935.2560.669.camel@ymzhang> <4e5e476b0907280020x242d9ef7gfa05c3d7b66f941f@mail.gmail.com> <1248771635.2560.682.camel@ymzhang> <20090728101135.GA22358@rhlx01.hs-esslingen.de> <4A726844.7040505@gmail.com> <1249024006.2560.735.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249024006.2560.735.camel@ymzhang>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Jul 31, 2009 at 03:06:46PM +0800, Zhang, Yanmin wrote:
> On Thu, 2009-07-30 at 21:43 -0600, Robert Hancock wrote:
> > On 07/28/2009 04:11 AM, Andreas Mohr wrote:
> > > Oh, and about the places which submit I/O requests where one would have to
> > > flag this: are they in any way correlated with the scheduler I/O wait
> > > value? Would the I/O wait mechanism be a place to more easily and centrally
> > > indicate that we're waiting for a request to come back in "very soon"?
> > > OTOH I/O requests may have vastly differing delay expectations,
> > > thus specifically only short-term expected I/O replies should be flagged,
> > > otherwise we're wasting lots of ACPI deep idle opportunities.
> > 
> > Did the results show a big difference in performance between maximum C2 
> > and maximum C3? 
> No big difference. I tried different max cstate by processor.max_cstate.
> Mostly, processor.max_cstate=1 could get the similiar result like idle=poll.

OK, but I'd say that this doesn't mean that we should implement a
hard-coded mechanism which simply says "in such cases, don't do anything > C1".
Instead we should strive for a far-reaching _generic_ mechanism
which gathers average latencies of various I/O activities/devices
and then uses some formula to determine the maximum (not necessarily ACPI)
idle latency that we're willing to endure (e.g. average device I/O reply latency
divided by 10 or so).

And in addition to this, we should also take into account (read: skip)
any idle states which kill busmaster DMA completely
(in case of busmaster DMA I/O activities, that is).

_Lots_ of very nice opportunities for improvement here, I'd say...
(in the 5, 10 or even 40% range in the case of certain network I/O)

Andreas
