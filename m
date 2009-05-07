Return-Path: <linux-kernel-owner+w=401wt.eu-S1761224AbZEGO3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761224AbZEGO3t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 10:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757055AbZEGO3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 10:29:39 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:48135 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756884AbZEGO3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 10:29:38 -0400
Date: Thu, 7 May 2009 10:18:47 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, Elladan <elladan@eskimo.com>,
       Nick Piggin <npiggin@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH -mm] vmscan: make mapped executable pages the first class
 citizen
In-Reply-To: <1241705702.11251.156.camel@twins>
Message-ID: <alpine.DEB.1.10.0905071016410.24528@qirst.com>
References: <20090430072057.GA4663@eskimo.com>  <20090430174536.d0f438dd.akpm@linux-foundation.org>  <20090430205936.0f8b29fc@riellaptop.surriel.com>  <20090430181340.6f07421d.akpm@linux-foundation.org>  <20090430215034.4748e615@riellaptop.surriel.com> 
 <20090430195439.e02edc26.akpm@linux-foundation.org>  <49FB01C1.6050204@redhat.com>  <20090501123541.7983a8ae.akpm@linux-foundation.org>  <20090503031539.GC5702@localhost> <1241432635.7620.4732.camel@twins>  <20090507121101.GB20934@localhost> 
 <alpine.DEB.1.10.0905070935530.24528@qirst.com> <1241705702.11251.156.camel@twins>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 May 2009, Peter Zijlstra wrote:

> It re-instates the young bit for PROT_EXEC pages, so that they will only
> be paged when they are really cold, or there is severe pressure.

But they are rescanned until then. Really cold means what exactly? I do a
back up of a few hundred gigabytes and do not use firefox while the backup
is ongoing. Will the firefox pages still be in memory or not?

> This simply gives them an edge over regular data. I don't think the
> extra scanning is a problem, since you rarely have huge amounts of
> executable pages around.
>
> mlock()'ing all code just doesn't sound like a good alternative.

Another possibility may be to put the exec pages on the mlock list
and scan the list if under extreme duress?

