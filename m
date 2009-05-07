Return-Path: <linux-kernel-owner+w=401wt.eu-S1761790AbZEGOi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761790AbZEGOi5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 10:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755724AbZEGOir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 10:38:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:38887 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756212AbZEGOiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 10:38:46 -0400
Subject: Re: [PATCH -mm] vmscan: make mapped executable pages the first
 class citizen
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, Elladan <elladan@eskimo.com>,
       Nick Piggin <npiggin@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.1.10.0905071016410.24528@qirst.com>
References: <20090430072057.GA4663@eskimo.com>
	 <20090430174536.d0f438dd.akpm@linux-foundation.org>
	 <20090430205936.0f8b29fc@riellaptop.surriel.com>
	 <20090430181340.6f07421d.akpm@linux-foundation.org>
	 <20090430215034.4748e615@riellaptop.surriel.com>
	 <20090430195439.e02edc26.akpm@linux-foundation.org>
	 <49FB01C1.6050204@redhat.com>
	 <20090501123541.7983a8ae.akpm@linux-foundation.org>
	 <20090503031539.GC5702@localhost> <1241432635.7620.4732.camel@twins>
	 <20090507121101.GB20934@localhost>
	 <alpine.DEB.1.10.0905070935530.24528@qirst.com>
	 <1241705702.11251.156.camel@twins>
	 <alpine.DEB.1.10.0905071016410.24528@qirst.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 07 May 2009 16:38:01 +0200
Message-Id: <1241707081.11251.160.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-07 at 10:18 -0400, Christoph Lameter wrote:
> On Thu, 7 May 2009, Peter Zijlstra wrote:
> 
> > It re-instates the young bit for PROT_EXEC pages, so that they will only
> > be paged when they are really cold, or there is severe pressure.
> 
> But they are rescanned until then. Really cold means what exactly? I do a
> back up of a few hundred gigabytes and do not use firefox while the backup
> is ongoing. Will the firefox pages still be in memory or not?

Likely not.

What this patch does is check the young bit on active_file scan, if its
found to be set and the page is PROT_EXEC, put the page back on the
active_file list, otherwise drop it to the inactive_file list.

So if you haven't ran any firefox code, it should be gone from the
active list after 2 full cycles, and from the inactive list on the first
full inactive cycle after that.

If you don't understand the patch, what are you complaining about, whats
your point?
