Return-Path: <linux-kernel-owner+w=401wt.eu-S1754490AbZJZWkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490AbZJZWkc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 18:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753946AbZJZWkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 18:40:32 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58353
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753661AbZJZWkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 18:40:31 -0400
Date: Mon, 26 Oct 2009 15:40:55 -0700 (PDT)
Message-Id: <20091026.154055.07992945.davem@davemloft.net>
To: lethal@linux-sh.org
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Kill off -Wcast-align
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091026094729.GB13517@linux-sh.org>
References: <20091026054000.GA13517@linux-sh.org>
	<20091026062520.GA29580@elte.hu>
	<20091026094729.GB13517@linux-sh.org>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Mundt <lethal@linux-sh.org>
Date: Mon, 26 Oct 2009 18:47:30 +0900

> On Mon, Oct 26, 2009 at 07:25:20AM +0100, Ingo Molnar wrote:
>> 
>> * Paul Mundt <lethal@linux-sh.org> wrote:
>> 
>> > The present use of -Wcast-align causes the build to blow up on SH due to
>> > generating a "cast increases required alignment of target type" error on
>> > each invocation of list_for_each_entry().
>> > 
>> > It seems that this was previously reported and killed off in the ia64
>> > support patch, but nothing seems to have happened with that. Presumably
>> > the same problem still remains there, too.
>> > 
>> > Signed-off-by: Paul Mundt <lethal@linux-sh.org>
>> 
>> Is this a GCC bug producing false positive warnings? The GCC manpage 
>> says:
>> 
>>        -Wcast-align
>>            Warn whenever a pointer is cast such that the required alignment of the
>>            target is increased.  For example, warn if a "char *" is cast to an
>>            "int *" on machines where integers can only be accessed at two- or
>>            four-byte boundaries.
>> 
>> Which looks moderately useful - if it works.
>> 
> Well, both ia64 and sh have hit this in the current compilers, and it
> doesn't seem to pose any code generation issues. In the areas where it is
> generated it seems to relate to 64-bit data types in the data structures,
> which in itself doesn't seem inherently problematic.

sparc64 hits this too when building 32-bit perf binary, the first
thing I do after a pull is remove this warning option from the
Makefile :-)
