Return-Path: <linux-kernel-owner+w=401wt.eu-S1756013AbXE0Ohs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013AbXE0Ohs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 10:37:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbXE0Ohl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 10:37:41 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:41723 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373AbXE0Ohl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 10:37:41 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4659978D.6020802@s5r6.in-berlin.de>
Date: Sun, 27 May 2007 16:37:01 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: Auke Kok <auke-jan.h.kok@intel.com>, randy.dunlap@oracle.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Scott Preece <sepreece@gmail.com>
Subject: Re: [PATCH] [condingstyle] Add chapter on tests
References: <20070525172509.5138.56430.stgit@localhost.localdomain> <20070525172515.5138.13652.stgit@localhost.localdomain> <Pine.LNX.4.61.0705262121150.7344@yvahk01.tjqt.qr> <Pine.LNX.4.61.0705262213000.7344@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0705262213000.7344@yvahk01.tjqt.qr>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> +	if (is_prime(number) == true)
> +		return 0;
> +	if (is_prime(number) == false)
> +		return 1;
> +
> +should be:
> +
> +	if (is_prime(number))
> +		return 0;
> +	if (!is_prime(number))
> +		return 1;
> +
> +As far as pointers or functions returning an integer are concerned,
> +using long form tests helps to distinguish between pointers and bools
> +or functions returning boolean or integer, respectively.
> +Examples are:
> +
> +	if (p == NULL)
> +		return 1;
> +	if (!p)
> +		return 0;
> +
> +	if (strcmp(haystack, needle) == 0)
> +		return 1;
> +	if (!strcmp(haystack, needle))
> +		return 0;

The latter two examples seem odd.  Didn't you mean the following?

	if (p == NULL)
		return 1;
	if (p)
		return 0;

	if (strcmp(haystack, needle) == 0)
		return 1;
	if (strcmp(haystack, needle))
		return 0;

Perhaps better:

	if (p == NULL)
		return NO_MEMORY;
	if (p)
		return MEMORY;

	if (strcmp(haystack, needle) == 0)
		return IS_SAME;
	if (strcmp(haystack, needle))
		return IS_DIFFERENT;

However, to follow your argument about non-boolean expressions, the
following would be more consequently going into your direction:

	if (p == NULL)
		return NO_MEMORY;
	if (p != NULL)
		return MEMORY;

	if (strcmp(haystack, needle) == 0)
		return IS_SAME;
	if (strcmp(haystack, needle) != 0)
		return IS_DIFFERENT;

I.e., why do the explicit comparison with 0 or NULL only when it is
tested for equality, but not when testing for inequality?

However, I agree with Scott Preece that these rules should be left out
of CodingStyle because they are contentious.

(Disclosure:  I am personally used to "if (p)" and "if (!p)" tests of
pointers and many integer expressions, but I tend to the longer form in
less obvious cases like "if (strcmp(a, b) != 0)".)
-- 
Stefan Richter
-=====-=-=== -=-= ==-==
http://arcgraph.de/sr/
