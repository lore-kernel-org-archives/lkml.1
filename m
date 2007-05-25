Return-Path: <linux-kernel-owner+w=401wt.eu-S1764797AbXEYSpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764797AbXEYSpc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 14:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763907AbXEYSpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 14:45:25 -0400
Received: from dhazelton.dsl.enter.net ([216.193.185.50]:50285 "EHLO mail"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763741AbXEYSpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 14:45:25 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Richard Purdie <richard@openedhand.com>
Subject: Re: [RFC] LZO de/compression support - take 4
Date: Fri, 25 May 2007 14:45:16 -0400
User-Agent: KMail/1.9.6
Cc: Satyam Sharma <satyam.sharma@gmail.com>,
       Nitin Gupta <nitingupta910@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm-cc@laptop.org, Andrew Morton <akpm@linux-foundation.org>,
       Andrey Panin <pazke@donpac.ru>, Bret Towe <magnade@gmail.com>,
       Michael-Luke Jones <mlj28@cam.ac.uk>
References: <4cefeab80705250445m51736a9aj8c89af893d8c242c@mail.gmail.com> <1180100304.5864.60.camel@localhost.localdomain> <200705251255.22600.dhazelton@enter.net>
In-Reply-To: <200705251255.22600.dhazelton@enter.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705251445.18188.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 May 2007 12:55:21 Daniel Hazelton wrote:
<snip>
> As to the performance - I can see absolutely no reason why the minimal
> version shouldn't perform the same (or better). The kernel codes memset and
> memcpy routines have been heavily tested *and* optimized over the years and
> moving from macro's to inline functions shouldn't have impacted performance
> at all. I will be testing the two code bases myself in a little bit - I'm
> more than a little paranoid and don't like the idea of trusting anyone with
> a "competing project" for all testing.


I'll have to better instrument my test code (a real quick (userspace) hack) 
using the minimized LZO1X implementation (take 4 :) and the complete LZOv2 
library (lzo1x_1_11_compress and the *unsafe* version of the decompressor 
used) but preliminary testing using just "time ./test" - the differences I've 
seen might be because I'm directly including one version of the code and the 
other is in a shared library. But even if I discount the system and user 
time - going *only* by the "real" time value I get results across 10 runs 
that differ by less than 0.001s - the average across 10 runs of the stripped 
down LZO code is about 0.00133s where the LZO library (liblzo2) returns about 
even performance - average is 0.001s.

A total difference of *ONE* *THIRD* of *ONE* *THOUSANDTH* of a second. With 
the better performance being in-kernel should bring, I can see no reason for 
a "big" difference.

If anyone's interested in the code I used for the test, let me know and I'll 
make it available.

DRH
