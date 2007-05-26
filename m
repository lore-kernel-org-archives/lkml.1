Return-Path: <linux-kernel-owner+w=401wt.eu-S1764635AbXEZT3B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764635AbXEZT3B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 15:29:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbXEZT2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 15:28:53 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:41506 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994AbXEZT2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 15:28:52 -0400
Date: Sat, 26 May 2007 21:27:45 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Auke Kok <auke-jan.h.kok@intel.com>
cc: randy.dunlap@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] [condingstyle] Add chapter on tests
In-Reply-To: <20070525172515.5138.13652.stgit@localhost.localdomain>
Message-ID: <Pine.LNX.4.61.0705262121150.7344@yvahk01.tjqt.qr>
References: <20070525172509.5138.56430.stgit@localhost.localdomain>
 <20070525172515.5138.13652.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 25 2007 10:25, Auke Kok wrote:
>diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
>index f518395..3635b38 100644
>--- a/Documentation/CodingStyle
>+++ b/Documentation/CodingStyle
>@@ -393,7 +393,7 @@ int fun(int a)
> 	int result = 0;
> 	char *buffer = kmalloc(SIZE);
> 
>-	if (buffer == NULL)
>+	if (!buffer)
> 		return -ENOMEM;

Please don't do this. With ==NULL/!=NULL, it is clear what
<randomvariable> could be (integer or pointer) without needing
to look it up. It also reads quite strange: "if not buffer".
For bools ('adjectives' / 'is a'), it works, not so much for ptrs.
Hence:

>+If you give your variables and pointers good names, there is never a need
>+to compare the value stored in that variable to NULL or true/false, so
>+omit all that and keep it short.

>+	ptr = s->next;
>+	if (!ptr)
>+		return;

Not agreed.

>+
>+	v = (read_byte(register));
>+	if (v & mask)
>+		return;

well, yes.

>+	if (is_prime(number))

Yes.


And I'd also like to mention one rather special case where I'd rather
like to see ==0 than ! for clarity (!strcmp looks like !streq, so
one needs to look twice to get it):

	if (!strcmp(hay, needle))


At least don't force the '!' doctrine.


	Jan
-- 
