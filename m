Return-Path: <linux-kernel-owner+w=401wt.eu-S1752776AbXCJBGC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776AbXCJBGC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 20:06:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767705AbXCJBGB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 20:06:01 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:50582 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752776AbXCJBGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 20:06:01 -0500
Date: Sat, 10 Mar 2007 02:04:18 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Use more gcc extensions in the Linux headers
In-Reply-To: <1173481052.32234.137.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.61.0703100156490.8799@yvahk01.tjqt.qr>
References: <1173419792.32234.131.camel@localhost.localdomain>
 <1173481052.32234.137.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 10 2007 09:57, Rusty Russell wrote:
>On Fri, 2007-03-09 at 16:56 +1100, Rusty Russell wrote:
>> __builtin_types_compatible_p() has been around since gcc 2.95, and we
>> don't use it anywhere.  This patch quietly fixes that.
>
>OK, many people complained that it needed a comment.  Good point!
>==
>Add comment to ARRAY_SIZE macro.
>
>Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>
>diff -r 933e410f204f include/linux/kernel.h
>--- a/include/linux/kernel.h	Sat Mar 10 09:55:31 2007 +1100
>+++ b/include/linux/kernel.h	Sat Mar 10 09:55:53 2007 +1100
>@@ -35,6 +35,7 @@ extern const char linux_proc_banner[];
> #define ALIGN(x,a)		__ALIGN_MASK(x,(typeof(x))(a)-1)
> #define __ALIGN_MASK(x,mask)	(((x)+(mask))&~(mask))
> 
>+/* GCC is awesome. */
> #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0])			      \
> 	+ sizeof(typeof(int[1 - 2*!!__builtin_types_compatible_p(typeof(arr), \
> 		 typeof(&arr[0]))]))*0)

Getting back at the macro, how would you like to have it merged?



Jan
-- 
