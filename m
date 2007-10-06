Return-Path: <linux-kernel-owner+w=401wt.eu-S1754067AbXJFFeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbXJFFeV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 01:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751560AbXJFFeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 01:34:13 -0400
Received: from stout.engsoc.carleton.ca ([134.117.69.22]:51552 "EHLO
	stout.engsoc.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbXJFFeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 01:34:12 -0400
Date: Sat, 6 Oct 2007 01:34:10 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Matthew Reppert <arashi@sacredchao.net>
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       airlied@linux.ie
Subject: Re: G33 graphics broken after 2.6.23-rc6
Message-ID: <20071006053410.GB14767@fattire.cabal.ca>
References: <4706D4B1.6050101@sacredchao.net> <20071006044221.GA14767@fattire.cabal.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071006044221.GA14767@fattire.cabal.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 06, 2007 at 12:42:21AM -0400, Kyle McMartin wrote:
> commit f443675affe3f16dd428e46f0f7fd3f4d703eeab
>     intel_agp: fix stolen mem range on G33
>     G33 GTT stolen memory is below graphics data stolen memory and be seperate,
>     so don't subtract it in stolen mem counting.
>     

Found it, without this corresponding change to xf86-video-intel, this
breaks utterly:

commit 2a8592f2ebcba86b1127aa889155d58a3dc186ca
Author: Zhenyu Wang <zhenyu.z.wang@intel.com>
Date:   Wed Sep 5 14:52:56 2007 +0800

    Fix G33 GTT stolen mem range
    
    G33 GTT table lives in seperate stolen mem with
    graphics data stolen mem.

I think this should be reverted for 2.6.23, it certainly doesn't seem to have
been appropriate for 2.6.23-rc6.

Cheers,
	Kyle M.
