Return-Path: <linux-kernel-owner+w=401wt.eu-S1759249AbZFKND2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759249AbZFKND2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 09:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751238AbZFKNDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 09:03:20 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55414 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbZFKNDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 09:03:20 -0400
Date: Thu, 11 Jun 2009 09:03:18 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Theodore Tso <tytso@mit.edu>, Steven Rostedt <rostedt@goodmis.org>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
       Christoph Hellwig <hch@infradead.org>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Jiaying Zhang <jiayingz@google.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: Re: [PATCH 00/11] [GIT PULL] more updates for the tag format
Message-ID: <20090611130318.GB14220@infradead.org>
References: <20090610054206.510574695@goodmis.org> <20090610092644.GA20889@elte.hu> <c62985530906100411o5a178352n53f7d247f6e9dba9@mail.gmail.com> <20090610130127.GA6647@mit.edu> <alpine.DEB.2.00.0906100911190.30552@gandalf.stny.rr.com> <20090610160303.GA10240@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090610160303.GA10240@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 10, 2009 at 12:03:03PM -0400, Theodore Tso wrote:
> Yes, another approach for handling this case would be to take my
> "jbd2_dev_to_name" function and support it as a first-class tagged
> type; after all, I'm sure ext4 won't be the only place that would like
> to take a dev_t and print the device name.  So this could certainly be
> fixed by adding some kind of "<dev:xxx>" sort of tagged name.

We should absolutely agree on one way to represent block device for
tracers.  At this point xfs, gfs2 and the block tracer all use
major/minor.  I agree that having a name would be nicer for text output,
but I really want to keep the dev_t for the binary output.  We should
also make sure we agree on a field name so that filtering will work
the same for all block-related tracers (especially important if we want
to trace something from the filesystem down to the block layer).

