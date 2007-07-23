Return-Path: <linux-kernel-owner+w=401wt.eu-S934035AbXGWXwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934035AbXGWXwj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 19:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758293AbXGWXwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 19:52:30 -0400
Received: from mga03.intel.com ([143.182.124.21]:59025 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757631AbXGWXw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 19:52:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,572,1175497200"; 
   d="scan'208";a="253807658"
Message-ID: <46A53F3A.7060509@intel.com>
Date: Mon, 23 Jul 2007 16:52:26 -0700
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
X-OriginalArrivalTime: 23 Jul 2007 23:52:27.0794 (UTC) FILETIME=[866BD720:01C7CD84]
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
>       only apply printk checks where there is a string literal
>       allow suppression of errors for when no patch is found
>       warn about multiple assignments
>       warn on declaration of multiple variables
>       check for kfree() with needless null check
>       check for single statement braced blocks
>       check for aggregate initialisation on the next line
>       handle the => operator
>       check for spaces between function name and open parenthesis
>       move to explicit Check: entries in feature-removal-schedule.txt
>       handle pointer attributes

within the last 3 weeks, this script went from *really usable* to *a big noise 
maker*.

I am testing this with new drivers (igb, e1000e, ixgbe) and the amount of 
warnings it throws was in the order of 10 last week, but now I'm at hundreds 
again, and my code has not changed.

The superfluous braces error should definately be fixed.

Warning on multiple declarations on a line is nice, but IMO really too verbose 
(why is "int i, j;" bad? Did C somehow change syntax today?).

Some of the new features are plain broken as I posted before. A lot of it now is 
purely false positives only.

Bottom line: I really wish that I could have the script run in the old behaviour 
before. While this level of verbosity is great for single-line patches, it 
really completely wastes my time when I'm trying to get a grasp for a 200k hunk 
piece of code.

The best way to implement this is that I can somehow select / omit some of these 
checks when running the script. With more and more checks added to the script it 
will be very quick for new driver writers to stop using it because of the sheer 
volume that the script currently outputs.

Auke
