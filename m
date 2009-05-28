Return-Path: <linux-kernel-owner+w=401wt.eu-S1761582AbZE1I2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761582AbZE1I2c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 04:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754772AbZE1I2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 04:28:18 -0400
Received: from cantor.suse.de ([195.135.220.2]:50319 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754411AbZE1I2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 04:28:17 -0400
Date: Thu, 28 May 2009 10:28:18 +0200
From: Nick Piggin <npiggin@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Lee.Schermerhorn@hp.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       fengguang.wu@intel.com
Subject: Re: [PATCH] [9/16] HWPOISON: Use bitmask/action code for try_to_unmap behaviour
Message-ID: <20090528082818.GH6920@wotan.suse.de>
References: <200905271012.668777061@firstfloor.org> <20090527201235.9475E1D0292@basil.firstfloor.org> <20090528072703.GF6920@wotan.suse.de> <20090528080319.GA1065@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090528080319.GA1065@one.firstfloor.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 10:03:19AM +0200, Andi Kleen wrote:
> On Thu, May 28, 2009 at 09:27:03AM +0200, Nick Piggin wrote:
> > Not a bad idea, but I would prefer to have a set of flags which tell
> > try_to_unmap what to do, and then combine them with #defines for
> > callers. Like gfp flags.
> 
> That's exactly what the patch does?

There are a set of "actions" which is what the callers are, then a
set of modifiers. Just make it all modifiers and the callers can
use things that are | together.

 
> It just has actions and flags because the actions can be contradictory.
> 
> > And just use regular bitops rather than this TTU_ACTION macro.
> 
> TTU_ACTION does mask against multiple bits. None of the regular
> bitops do that. 

&, |  ?
