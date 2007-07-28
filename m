Return-Path: <linux-kernel-owner+w=401wt.eu-S1754629AbXG1QdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629AbXG1QdY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 12:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752186AbXG1QdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 12:33:16 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:56834 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbXG1QdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 12:33:15 -0400
Date: Sat, 28 Jul 2007 10:32:47 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: How can we make page replacement smarter (was: swap-prefetch)
In-reply-to: <fa.0CL7DLsw6U7akTkW79pdCM5NPRk@ifi.uio.no>
To: Al Boldi <a1426z@gawab.com>
Cc: Chris Snook <csnook@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Message-id: <46AB6FAF.5030306@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.RQO1FPcnWSV7f0LbL9tuLuh/fYY@ifi.uio.no>
 <fa.FI89MRq1q0M+6SmmYNPsXQv2gC8@ifi.uio.no>
 <fa./S2LBynIjozRhHfPsYxB9mQDpKE@ifi.uio.no>
 <fa.0CL7DLsw6U7akTkW79pdCM5NPRk@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Boldi wrote:
> Chris Snook wrote:
>> Al Boldi wrote:
>>> Because it is hard to quantify the expected swap-in speed for random
>>> pages, let's first tackle the swap-in of consecutive pages, which should
>>> be at least as fast as swap-out.  So again, why is swap-in so slow?
>> If I'm writing 20 pages to swap, I can find a suitable chunk of swap and
>> write them all in one place.  If I'm reading 20 pages from swap, they
>> could be anywhere.  Also, writes get buffered at one or more layers of
>> hardware.
> 
> Ok, this explains swap-in of random pages.  Makes sense, but it doesn't 
> explain the awful tmpfs performance degradation of consecutive read-in runs 
> from swap, which should have at least stayed constant
> 
>> At best, reads can be read-ahead and cached, which is why
>> sequential swap-in sucks less.  On-demand reads are as expensive as I/O
>> can get.
> 
> Which means that it should be at least as fast as swap-out, even faster 
> because write to disk is usually slower than read on modern disks.  But 
> linux currently shows a distinct 2x slowdown for sequential swap-in wrt 
> swap-out.  And to prove this point, just try suspend to disk where you can 
> see sequential swap-out being reported at about twice the speed of 
> sequential swap-in on resume.  Why is that?

Depends if swap-in is doing any read-ahead. If it's reading one page at 
a time in from the disk then the performance will definitely suck 
because of all the overhead from the tiny I/O's. With random swap-in you 
then pay the horrible seek penalty for all the reads as well.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

