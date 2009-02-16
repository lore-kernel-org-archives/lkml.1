Return-Path: <linux-kernel-owner+w=401wt.eu-S1753220AbZBPTWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220AbZBPTWW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 14:22:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751318AbZBPTWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 14:22:13 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:54256 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbZBPTWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 14:22:12 -0500
Message-ID: <4999BBE6.2080003@cs.helsinki.fi>
Date: Mon, 16 Feb 2009 21:17:58 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.19 (Macintosh/20081209)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Nick Piggin <nickpiggin@yahoo.com.au>, Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lin Ming <ming.m.lin@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [patch] SLQB slab allocator (try 2)
References: <20090123154653.GA14517@wotan.suse.de> <200902041748.41801.nickpiggin@yahoo.com.au> <20090204152709.GA4799@csn.ul.ie> <200902051459.30064.nickpiggin@yahoo.com.au> <20090216184200.GA31264@csn.ul.ie>
In-Reply-To: <20090216184200.GA31264@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,

Mel Gorman wrote:
> I haven't done much digging in here yet. Between the large page bug and
> other patches in my inbox, I haven't had the chance yet but that doesn't
> stop anyone else taking a look.

So how big does an improvement/regression have to be not to be 
considered within noise? I mean, I randomly picked one of the results 
("x86-64 speccpu integer tests") and ran it through my "summarize" 
script and got the following results:

		min      max      mean     std_dev
   slub		0.96     1.09     1.01     0.04
   slub-min	0.95     1.10     1.00     0.04
   slub-rvrt	0.90     1.08     0.99     0.05
   slqb		0.96     1.07     1.00     0.04

Apart from slub-rvrt (which seems to be regressing, interesting) all the 
allocators seem to perform equally well. Hmm?

Btw, Yanmin, do you have access to the tests Mel is running (especially 
the ones where slub-rvrt seems to do worse)? Can you see this kind of 
regression? The results make we wonder whether we should avoid reverting 
all of the page allocator pass-through and just add a kmalloc cache for 
8K allocations. Or not address the netperf regression at all. Double-hmm.

			Pekka
