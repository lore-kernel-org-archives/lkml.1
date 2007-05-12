Return-Path: <linux-kernel-owner+w=401wt.eu-S1757605AbXELFgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605AbXELFgV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 01:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754752AbXELFgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 01:36:06 -0400
Received: from terminus.zytor.com ([192.83.249.54]:34737 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756504AbXELFgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 01:36:05 -0400
Message-ID: <464551D5.2050709@zytor.com>
Date: Fri, 11 May 2007 22:34:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: Jonathan Corbet <corbet@lwn.net>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Johannes Stezenbach <js@linuxtv.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, Heikki Orsila <shdl@zakalwe.fi>,
       jimmy bahuleyan <knight.camelot@gmail.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] "volatile considered harmful", take 3
References: <12700.1178905000@lwn.net> <a781481a0705112021u7b6d32fcxb6318d7e2443c970@mail.gmail.com>
In-Reply-To: <a781481a0705112021u7b6d32fcxb6318d7e2443c970@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> 
>> +  - Pointers to data structures in coherent memory which might be
>> modified
>> +    by I/O devices can, sometimes, legitimately be volatile.  A ring
>> buffer
>> +    used by a network adapter, where that adapter changes pointers to
>> +    indicate which descriptors have been processed, is an example of
>> this
>> +    type of situation.
> 
> is a legitimate use case for volatile is still not clear to me (I
> agree with Alan's
> comment in a previous thread that this seems to be a case where a memory
> barrier would be applicable^Wbetter, actually). I could be wrong here, so
> would be nice if Peter explains why volatile is legitimate here.
> 
> Otherwise, it's fine with me.
> 

I don't see why Alan's way is necessarily better; it should work but is
more heavy-handed as it's disabling *all* optimization such as loop
invariants across the barrier.

	-hpa
