Return-Path: <linux-kernel-owner+w=401wt.eu-S1760777AbZDFWVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760777AbZDFWVa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 18:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760661AbZDFWVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 18:21:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33557 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755922AbZDFWVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 18:21:05 -0400
Date: Mon, 6 Apr 2009 15:17:28 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ray Lee <ray-lk@madrabbit.org>
cc: Hua Zhong <hzhong@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/8][RFC] IO latency/throughput fixes
In-Reply-To: <2c0942db0904061504l6504934bi446f7425fcd38470@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0904061509020.7443@localhost.localdomain>
References: <1239022088-29002-1-git-send-email-jens.axboe@oracle.com>  <alpine.LFD.2.00.0904060803141.4023@localhost.localdomain>  <20090406151054.GD5178@kernel.dk> <alpine.LFD.2.00.0904060840080.3863@localhost.localdomain>  <20090406183157.GD7376@mit.edu>
 <alpine.LFD.2.00.0904061255160.4134@localhost.localdomain>  <002501c9b6f3$f85b4910$e911db30$@com> <20090406211931.GB8586@mit.edu>  <003001c9b6ff$a9259ce0$fb70d6a0$@com> <2c0942db0904061504l6504934bi446f7425fcd38470@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 6 Apr 2009, Ray Lee wrote:
> 
> Your argument seems to be that someone may be relying upon default
> kernel behavior and, at the same time, is willing to continually
> upgrade their kernel.

No, I do think that the argument is valid per se: the crash behavior of 
"data=ordered" wrt "data=writeback" _is_ very different. And it's true 
that "data=ordered" has nicer behavior in the case of a crash.

But it is also true that with all the recent patches, "data=writeback" has 
become a _lot_ more attractive. It is slightly more ordered than it used 
to be, in a very particular way that makes one of the biggest downsides go 
away. And the latency improvements are really quite stunning (*). 

So I think Hua's argument is real, but at the same time we should balance 
it against the fact that a lot of people will just use whatever is the 
default - and as a result we should strive to make the default be the 
thing that we think people would be happiest with.

I think "ordered" was a reasonable default, but that was at least partly 
because _both_ ordered and writeback sucked (partly in different ways).

I do think we could make it a config option.

			Linus

(*) Admittedly with a very specific workload, but I suspect it's not that 
uncommon, and there will be people who never realized what their problem 
was and blamed jerky behavior on scheduler or something.
