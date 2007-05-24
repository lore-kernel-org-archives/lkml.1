Return-Path: <linux-kernel-owner+w=401wt.eu-S1752133AbXEXRzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133AbXEXRzq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 13:55:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750919AbXEXRzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 13:55:38 -0400
Received: from sj-iport-1-in.cisco.com ([171.71.176.70]:2420 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbXEXRzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 13:55:37 -0400
X-IronPort-AV: i="4.14,574,1170662400"; 
   d="scan'208"; a="982795:sNHT19355682"
To: Rob Landley <rob@landley.net>
Cc: Adrian Bunk <bunk@stusta.de>, Arjan van de Ven <arjan@linux.intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Status of CONFIG_FORCED_INLINING?
X-Message-Flag: Warning: May contain useful information
References: <200705231510.52932.rob@landley.net>
	<20070524171019.GA4470@stusta.de> <ada3b1m87pa.fsf@cisco.com>
	<200705241347.43727.rob@landley.net>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 24 May 2007 10:55:34 -0700
In-Reply-To: <200705241347.43727.rob@landley.net> (Rob Landley's message of "Thu, 24 May 2007 13:47:43 -0400")
Message-ID: <adahcq26r8p.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 24 May 2007 17:55:34.0741 (UTC) FILETIME=[BA764050:01C79E2C]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > And if you #include a non-inlined definition in two .c files, the compiler 
 > will emit two copies into two separate .o files.  What you're hoping is that 
 > the linker will notice they're identical and merge them, and last I checked I 
 > couldn't even reliably get it to do that with constant strings.

No, I don't care if the linker merges it or not.  In fact I hope that
maybe the compiler is smart enough to optimize the function for the
sites it's called from in a particular .c file.

But a function defined in a .h file had better be static, so it
shouldn't matter if there are two copies of it in the final linked
image (any more than it matters if there are 100 inlined copies of it).
