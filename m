Return-Path: <linux-kernel-owner+w=401wt.eu-S1761296AbZEGOQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761296AbZEGOQX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 10:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760382AbZEGOP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 10:15:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:49737 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760822AbZEGOP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 10:15:56 -0400
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
In-Reply-To: <alpine.DEB.1.10.0905070935530.24528@qirst.com>
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
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 07 May 2009 16:15:02 +0200
Message-Id: <1241705702.11251.156.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-07 at 09:39 -0400, Christoph Lameter wrote:
> On Thu, 7 May 2009, Wu Fengguang wrote:
> 
> > Introduce AS_EXEC to mark executables and their linked libraries, and to
> > protect their referenced active pages from being deactivated.
> 
> 
> We already have support for mlock(). How is this an improvement? This is
> worse since the AS_EXEC pages stay on the active list and are continually
> rescanned.

It re-instates the young bit for PROT_EXEC pages, so that they will only
be paged when they are really cold, or there is severe pressure.

This simply gives them an edge over regular data. I don't think the
extra scanning is a problem, since you rarely have huge amounts of
executable pages around.

mlock()'ing all code just doesn't sound like a good alternative.
