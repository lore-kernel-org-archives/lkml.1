Return-Path: <linux-kernel-owner+w=401wt.eu-S1757910AbXE0PFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910AbXE0PFa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 11:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754168AbXE0PFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 11:05:23 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:49332 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753701AbXE0PFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 11:05:22 -0400
Date: Sun, 27 May 2007 17:02:10 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Auke Kok <auke-jan.h.kok@intel.com>, randy.dunlap@oracle.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Scott Preece <sepreece@gmail.com>
Subject: Re: [PATCH] [condingstyle] Add chapter on tests
In-Reply-To: <4659978D.6020802@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.61.0705271655450.7344@yvahk01.tjqt.qr>
References: <20070525172509.5138.56430.stgit@localhost.localdomain>
 <20070525172515.5138.13652.stgit@localhost.localdomain>
 <Pine.LNX.4.61.0705262121150.7344@yvahk01.tjqt.qr>
 <Pine.LNX.4.61.0705262213000.7344@yvahk01.tjqt.qr> <4659978D.6020802@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 27 2007 16:37, Stefan Richter wrote:
>Jan Engelhardt wrote:
>> +	if (is_prime(number) == true)
>> +		return 0;
>> +	if (is_prime(number) == false)
>> +		return 1;
>> +
>> +should be:
>> +
>> +	if (is_prime(number))
>> +		return 0;
>> +	if (!is_prime(number))
>> +		return 1;
>> +
>> +As far as pointers or functions returning an integer are concerned,
>> +using long form tests helps to distinguish between pointers and bools
>> +or functions returning boolean or integer, respectively.
>> +Examples are:
>> +
>> +	if (p == NULL)
>> +		return 1;
>> +	if (!p)
>> +		return 0;
>> +
>> +	if (strcmp(haystack, needle) == 0)
>> +		return 1;
>> +	if (!strcmp(haystack, needle))
>> +		return 0;
>
>The latter two examples seem odd.  Didn't you mean the following?

See how much confusion it all makes!

Right, it was intended -- first the long form is shown and then the
shorter one (and "long form tests help to distinguish"):

	if (p == NULL)	/* this way please */
		return 1;
	if (!p)		/* Everytime you shorten it, God kills a kitten */
		return 0;
		/* so perhaps don't do it if you love animals or
		know someone who does. */

I seem to have forgotten more comments/explanation.

>	if (p == NULL)
>		return 1;
>	if (p)
>		return 0;
>
>	if (strcmp(haystack, needle) == 0)
>		return 1;
>	if (strcmp(haystack, needle))
>		return 0;
>
>Perhaps better:
>
>	if (p == NULL)
>		return NO_MEMORY;
>	if (p)
>		return MEMORY;
>
>	if (strcmp(haystack, needle) == 0)
>		return IS_SAME;
>	if (strcmp(haystack, needle))
>		return IS_DIFFERENT;
>
>However, to follow your argument about non-boolean expressions, the
>following would be more consequently going into your direction:
>
>I.e., why do the explicit comparison with 0 or NULL only when it is
>tested for equality, but not when testing for inequality?
>
>However, I agree with Scott Preece that these rules should be left out
>of CodingStyle because they are contentious.
>
>(Disclosure:  I am personally used to "if (p)" and "if (!p)" tests of
>pointers and many integer expressions, but I tend to the longer form in
>less obvious cases like "if (strcmp(a, b) != 0)".)



	Jan
-- 
