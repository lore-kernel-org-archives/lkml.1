Return-Path: <linux-kernel-owner+w=401wt.eu-S1754133AbZC2Pwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbZC2Pwi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 11:52:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751552AbZC2Pw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 11:52:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56060 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750749AbZC2Pw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 11:52:28 -0400
Date: Sun, 29 Mar 2009 08:47:17 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Pavel Machek <pavel@ucw.cz>
cc: Bodo Eggert <7eggert@gmx.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
In-Reply-To: <20090329144531.GA1408@ucw.cz>
Message-ID: <alpine.LFD.2.00.0903290830230.3994@localhost.localdomain>
References: <cklHL-5IW-23@gated-at.bofh.it> <ckm0Q-6o4-3@gated-at.bofh.it> <ckmaG-6AC-5@gated-at.bofh.it> <ckmWO-7Ro-5@gated-at.bofh.it> <ckn6L-84h-19@gated-at.bofh.it> <cknzG-ff-7@gated-at.bofh.it> <cknJk-IB-9@gated-at.bofh.it> <ckoFm-2eg-3@gated-at.bofh.it>
 <ckoYP-2DC-13@gated-at.bofh.it> <E1LnX6V-0001aA-AU@be1.7eggert.dyndns.org> <20090329144531.GA1408@ucw.cz>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 29 Mar 2009, Pavel Machek wrote:
> 
> Actually ext2 is more reliable in ext3 --  fsck tells you
> about errors on parts of disk that are not normallly used.

No. ext2 is not more reliable than ext3.

ext2 gets way more errors (that whole 5s + 30s thing), and has no 
"data=ordered" mode to even ask for more reliable behavior.

And even if compared to "data=writeback" (which approximates the ext2 
writeout ordering), and assuming that the errors are comparable, at least 
ext3 ends up automatically fixing up a lot of the errors that cause 
inabilities to boot etc.

So don't be silly. ext3 is way more reliable than ext2. In fact, ext3 with 
"data=ordered" is rather hard to screw up (but not impossible), and the 
only real complaint in this thread is just the fsync performance issue, 
not the reliability.

So don't go overboard. Ext3 works perfectly well, and has just that one 
(admittedly fairly annoying) major issue - and one that wasn't really 
historically even a big deal. I mean, nobody really did fsync() all that 
much, and traditionally people cared more about throughput than latency 
(or at least that was what all the benchmarks are about, which sadly seems 
to still continue).

I do agree that "data=writeback" is broken, but ext2 was equally broken. 

			Linus
