Return-Path: <linux-kernel-owner+w=401wt.eu-S1754080AbYHXH6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbYHXH6x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 03:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752058AbYHXH6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 03:58:44 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:50996 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbYHXH6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 03:58:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=worsptO7ThoXY/eB+mH8+ryGYDJdjWTuB8nAqzrpX7FIYpxlPXh5pS/9IgMPlLJxk2
         OmjvuqH3ZPzm+xZuB1mEzr1dc+8x43W64ZNLFGLjLmpMQ3of6uja9A6c5idJ9iPeU2xR
         hImMhSu1Qx+8kfmMyMW7SkWiNMU3SmwR/xcnw=
Message-ID: <19f34abd0808240058h3d286151x18cba0939f175edd@mail.gmail.com>
Date: Sun, 24 Aug 2008 09:58:42 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Johannes Weiner" <hannes@saeurebad.de>
Subject: Re: 9a2d43b: __alloc_bootmem_core(): zero-sized request
Cc: "Yinghai Lu" <yhlu.kernel@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <87myj4yzll.fsf@skyscraper.fehenstaub.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0808221224s4674e5aaq34bd0a874dfba699@mail.gmail.com>
	 <87myj4yzll.fsf@skyscraper.fehenstaub.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 23, 2008 at 9:12 AM, Johannes Weiner <hannes@saeurebad.de> wrote:
> "Vegard Nossum" <vegard.nossum@gmail.com> writes:
>>
>> I was trying out
>>
>> commit 9a2d43b7566caeeeb414aa628bc2759028897dbb
>> Date:   Tue Jul 15 21:21:43 2008 +0200
>>
>> ..as part of the debugging of a different issue, but I got this:
>>
>> __alloc_bootmem_core(): zero-sized request

[...]

>> I saw some bootmem errata lately, can I cherry-pick anything to fix
>> this?
>
> This behaviour hasn't changed after the rewrite.

Yep, the error is somewhere else.

Inserted a printk("nr_kernel_pages = %llu\n", nr_kernel_pages); and
this is the output:

nr_kernel_pages = 13869392367443771392

...it looks very, very big. I think this is initialized via
free_area_init_*() functions, which come from arch code. Does x86
experts know if any of this changed recently (i.e. after July 15)?

The whole dmesg and config can be seen here:
http://userweb.kernel.org/~vegard/bugs/20080824-numa/


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
