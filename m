Return-Path: <linux-kernel-owner+w=401wt.eu-S1757558AbZGPO2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558AbZGPO2c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 10:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757548AbZGPO2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 10:28:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:34316 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757460AbZGPO2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 10:28:30 -0400
Subject: Re: [PATCH] mm: count only reclaimable lru pages
From: Peter Zijlstra <peterz@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       David Howells <dhowells@redhat.com>,
       "riel@redhat.com" <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "Barnes, Jesse" <jesse.barnes@intel.com>
In-Reply-To: <20090716142533.GA27165@localhost>
References: <20090716133454.GA20550@localhost>
	 <alpine.DEB.1.10.0907160959260.32382@gentwo.org>
	 <20090716142533.GA27165@localhost>
Content-Type: text/plain
Date: Thu, 16 Jul 2009 16:28:11 +0200
Message-Id: <1247754491.6586.23.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-16 at 22:25 +0800, Wu Fengguang wrote:
> > Reclaimable? Are all pages on the LRUs truly reclaimable?
> 
> No, only possibly reclaimable :)
> 
> What would you suggest?  In fact I'm not totally comfortable with it.
> Maybe it would be safer to simply stick with the old _lru_pages
> naming?

Nah, I like the reclaimable name, these pages are at least potentially
reclaimable.

lru_pages() is definately not correct anymore since you exclude the
unevictable and possibly the anon pages.

