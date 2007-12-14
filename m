Return-Path: <linux-kernel-owner+w=401wt.eu-S934945AbXLNAd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934945AbXLNAd5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 19:33:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932916AbXLNAds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 19:33:48 -0500
Received: from mx1.suse.de ([195.135.220.2]:35049 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932513AbXLNAdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 19:33:47 -0500
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: RFC: remove __read_mostly
From: Andi Kleen <andi@firstfloor.org>
References: <20071213222044.GH21616@stusta.de>
	<20071213235432.GA26669@fattire.cabal.ca>
Date: Fri, 14 Dec 2007 01:33:45 +0100
In-Reply-To: <20071213235432.GA26669@fattire.cabal.ca> (Kyle McMartin's message of "Thu\, 13 Dec 2007 18\:54\:32 -0500")
Message-ID: <p73tzmmf72u.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle McMartin <kyle@mcmartin.ca> writes:

> I'd bet, in the __read_mostly case at least, that there's no
> improvement in almost all cases.

I bet you're wrong. Cache line behaviour is critical, much more
than pipeline behaviour (which unlikely affects). That is because
if you eat a cache miss it gets really expensive, which e.g.
a mispredicted jump is relatively cheap in comparison. We're talking
one or more orders of magnitude.

I admit I'm to blame for both (submitted unlikely and asked for
__read_mostly) and I now consider unlikely a mistake now by hindsight,
but still think __read_mostly was a good idea.

There is one potential problem in that if __read_mostly is used too
aggressively then the non __read_mostly variables will be all "write
mostly" with nothing inbetween and that could lead to more false
sharing, but so far this doesn't seem to be a big problem (and that
one could be solved too)

-Andi
