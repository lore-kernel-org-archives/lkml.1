Return-Path: <linux-kernel-owner+w=401wt.eu-S1756286AbZBTKYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286AbZBTKYA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 05:24:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753927AbZBTKXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 05:23:51 -0500
Received: from mtagate4.de.ibm.com ([195.212.29.153]:36412 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845AbZBTKXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 05:23:49 -0500
Date: Fri, 20 Feb 2009 11:23:39 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Frysinger <vapier.adi@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "Sachin P. Sant" <sachinp@in.ibm.com>, linux-s390@vger.kernel.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       heiko.carstens@de.ibm.com
Subject: Re: [s390] next Feb 18: defconfig build break
Message-ID: <20090220112339.7fd84556@de.ibm.com>
In-Reply-To: <200902190913.27653.rusty@rustcorp.com.au>
References: <20090218191640.0b023029.sfr@canb.auug.org.au>
	<20090218224541.fe6e0355.sfr@canb.auug.org.au>
	<8bd0f97a0902180910wafd35ceo47aeb9f3cc6733f3@mail.gmail.com>
	<200902190913.27653.rusty@rustcorp.com.au>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

On Thu, 19 Feb 2009 09:13:26 +1030
Rusty Russell <rusty@rustcorp.com.au> wrote:

> Here's the s390 fix:
> 
> Subject: s390: allow usage of string functions in linux/string.h

Thanks for the fix.
 
> Because when including asm/string.h from arch/s390/lib/string.c we
> don't declare the string ops we are about to define, and
> linux/string.h barfs.
> 
> The fix is to declare them in this IN_ARCH_STRING_C case, but in
> general I wonder if there's a neater fix.

The out-of-line version of the string functions in
arch/s390/lib/string.c needs EXPORT_SYMBOL and other stuff. To fix the
problem without the seperate out-of-line prototypes would required to
avoid the inclusing of linux/string.h. Which would be fragile if
possible at all. So I think your patch is the best way to deal with the
problem.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

