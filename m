Return-Path: <linux-kernel-owner+w=401wt.eu-S1763676AbXGWXg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763676AbXGWXg2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 19:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754884AbXGWXgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 19:36:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:5976 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbXGWXgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 19:36:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,572,1175497200"; 
   d="scan'208";a="271786381"
Message-ID: <46A53B70.1010903@intel.com>
Date: Mon, 23 Jul 2007 16:36:16 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070623)
MIME-Version: 1.0
To: Andy Whitcroft <apw@shadowen.org>
CC: Andrew Morton <akpm@osdl.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.08
References: <740c90243aaa6f6d4640d71230c4fa27@pinky>
In-Reply-To: <740c90243aaa6f6d4640d71230c4fa27@pinky>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Jul 2007 23:36:17.0623 (UTC) FILETIME=[44277E70:01C7CD82]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Whitcroft wrote:
> This version brings a number of new checks, and a number of bug
> fixes.  Of note:
> 
>   - warnings for multiple assignments per line
>   - warnings for multiple declarations per line
>   - checks for single statement blocks with braces
> 
> This patch includes an update for feature-removal-schedule.txt to
> better target checks.
> 
> Andy Whitcroft (12):
>       Version: 0.08
>       check for spaces between function name and open parenthesis
> 

> +# check for spaces between functions and their parentheses.
> +		if ($line =~ /($Ident)\s+\(/ &&
> +		    $1 !~ /^(?:if|for|while|switch|return|volatile)$/ &&
> +		    $line !~ /$Type\s+\(/ && $line !~ /^.\#\s*define\b/) {
> +			ERROR("no space between function name and open parenthesis '('\n" . $herecurr);
> +		}


this somehow seems to match something completely non-related (a function pointer 
declaration case):

ERROR: no space between function name and open parenthesis '('
#7278: FILE: drivers/net/e1000e/hw.h:434:
+       bool (*check_mng_mode)(struct e1000_hw *);

even if I put a space between ")(", it still complains.


Auke
