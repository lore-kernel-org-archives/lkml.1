Return-Path: <linux-kernel-owner+w=401wt.eu-S935606AbXGXLeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935606AbXGXLeY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 07:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765611AbXGXLeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 07:34:12 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:3778 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbXGXLeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 07:34:11 -0400
Message-ID: <46A5E39D.7030009@shadowen.org>
Date: Tue, 24 Jul 2007 12:33:49 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: "Kok, Auke" <auke-jan.h.kok@intel.com>, Andrew Morton <akpm@osdl.org>
CC: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] update checkpatch.pl to version 0.08
References: <740c90243aaa6f6d4640d71230c4fa27@pinky> <46A53F3A.7060509@intel.com>
In-Reply-To: <46A53F3A.7060509@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kok, Auke wrote:
> Andy Whitcroft wrote:
>> This version brings a number of new checks, and a number of bug
>> fixes.  Of note:
>>
>>   - warnings for multiple assignments per line
>>   - warnings for multiple declarations per line
>>   - checks for single statement blocks with braces
>>
>> This patch includes an update for feature-removal-schedule.txt to
>> better target checks.
>>
>> Andy Whitcroft (12):
>>       Version: 0.08
>>       only apply printk checks where there is a string literal
>>       allow suppression of errors for when no patch is found
>>       warn about multiple assignments
>>       warn on declaration of multiple variables
>>       check for kfree() with needless null check
>>       check for single statement braced blocks
>>       check for aggregate initialisation on the next line
>>       handle the => operator
>>       check for spaces between function name and open parenthesis
>>       move to explicit Check: entries in feature-removal-schedule.txt
>>       handle pointer attributes
> 
> within the last 3 weeks, this script went from *really usable* to *a big
> noise maker*.

She is developing for sure.  I for one don't want it to be worthless.  I
also want it to catch the things that Andrew is hottest on.  A difficult
path.  Always remember that this is a guide to style not definitive.

> I am testing this with new drivers (igb, e1000e, ixgbe) and the amount
> of warnings it throws was in the order of 10 last week, but now I'm at
> hundreds again, and my code has not changed.
> 
> The superfluous braces error should definately be fixed.

Yes, that was a misunderstanding my end, and I have loosened that check.
for the next version.  Not sure if its much use anymore but it should no
longer winge all over your patch.

> Warning on multiple declarations on a line is nice, but IMO really too
> verbose (why is "int i, j;" bad? Did C somehow change syntax today?).

No the normal response is two fold:

1) "what the heck are i and j those are meaningless names"
2) "please can we have some comments for those variables"

which normally leads to the suggestion that it be the following form:

	int source;		/* source clock hand */
	int destination;	/* destination clock hand */

and all is well.  That was the background for the checks.  However,
there is much upsetedness over it and push for i, j, k, l being a handy
form.

I am inclined to drop this check completely.  Andrew this was one of
your requests?

> Some of the new features are plain broken as I posted before. A lot of
> it now is purely false positives only.
> 
> Bottom line: I really wish that I could have the script run in the old
> behaviour before. While this level of verbosity is great for single-line
> patches, it really completely wastes my time when I'm trying to get a
> grasp for a 200k hunk piece of code.

I can only shudder at the thought of a 200k patch, but ok.

> The best way to implement this is that I can somehow select / omit some
> of these checks when running the script. With more and more checks added
> to the script it will be very quick for new driver writers to stop using
> it because of the sheer volume that the script currently outputs.

Yeah I have been feeling that we might want to say "--no-check" etc so
you can only get the more serious errors etc.  Will think on that.

-apw
