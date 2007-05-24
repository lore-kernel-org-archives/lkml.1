Return-Path: <linux-kernel-owner+w=401wt.eu-S1751593AbXEXSc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751593AbXEXSc3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 14:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750789AbXEXScV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 14:32:21 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:57422 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbXEXScU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 14:32:20 -0400
X-IronPort-AV: i="4.14,574,1170662400"; 
   d="scan'208"; a="154010109:sNHT18038548431"
To: Adrian Bunk <bunk@stusta.de>
Cc: Rob Landley <rob@landley.net>, Arjan van de Ven <arjan@linux.intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Status of CONFIG_FORCED_INLINING?
X-Message-Flag: Warning: May contain useful information
References: <200705231510.52932.rob@landley.net>
	<20070524171019.GA4470@stusta.de> <ada3b1m87pa.fsf@cisco.com>
	<200705241347.43727.rob@landley.net> <adahcq26r8p.fsf@cisco.com>
	<20070524180704.GE4470@stusta.de>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 24 May 2007 11:32:07 -0700
In-Reply-To: <20070524180704.GE4470@stusta.de> (Adrian Bunk's message of "Thu, 24 May 2007 20:07:04 +0200")
Message-ID: <adawsyy5azc.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 24 May 2007 18:32:07.0679 (UTC) FILETIME=[D58E08F0:01C79E31]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > The problem is that inline functions in headers are intended to be 
 > called from different C files.
 > 
 > gcc might not inline it in the C files where it is called more than 
 > once.
 > 
 > But it will always inline it if it's called only once.
 > 
 > One of both will be suboptimal, but from gcc's perspective it was 
 > optimal.

Yes, we could probably get huge benefits from --combine and/or
-fwhole-program to let gcc see more than one file at a time.

But I still don't see the issue with having gcc do the best it can on
each file it compiles.  If you force the inlining, then that means
that on files where not inlining was better, you've forced gcc to
generate worse code.  (I don't see how not inlining could be locally
better on a single file but globally worse, even though it generated
better code on each compiled file)
