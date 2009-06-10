Return-Path: <linux-kernel-owner+w=401wt.eu-S1757831AbZFJNCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757831AbZFJNCS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 09:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754667AbZFJNCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 09:02:10 -0400
Received: from thunk.org ([69.25.196.29]:48807 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752818AbZFJNCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 09:02:09 -0400
Date: Wed, 10 Jun 2009 09:01:27 -0400
From: Theodore Tso <tytso@mit.edu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
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
Message-ID: <20090610130127.GA6647@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	=?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
	Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
	Christoph Hellwig <hch@infradead.org>,
	Rik van Riel <riel@redhat.com>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	Peter Zijlstra <peterz@infradead.org>,
	Mathieu Desnoyers <compudj@krystal.dyndns.org>,
	Lai Jiangshan <laijs@cn.fujitsu.com>,
	Zhaolei <zhaolei@cn.fujitsu.com>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Jason Baron <jbaron@redhat.com>,
	Jiaying Zhang <jiayingz@google.com>,
	Tom Zanussi <tzanussi@gmail.com>,
	Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
References: <20090610054206.510574695@goodmis.org> <20090610092644.GA20889@elte.hu> <c62985530906100411o5a178352n53f7d247f6e9dba9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530906100411o5a178352n53f7d247f6e9dba9@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 10, 2009 at 01:11:40PM +0200, Frédéric Weisbecker wrote:
> Well, indeed I had worries, but I discussed about it with Steven and
> now I actually
> think this new tag format is much more powerful than printf style.
> It brings a cleaner, and much higher level way to control the data exports.
> 
> But it would be nice to read some opinions from end users (end
> developers) of TRACE_EVENT().

Maybe I'm missing something, but looks like the this new format, while
simpler and easier to read, doesn't have support for using a more
complicated C expression as a printk argument.  For example:

	TP_printk("dev %s ino %lu mode %d uid %u gid %u blocks %llu",
		  jbd2_dev_to_name(__entry->dev), __entry->ino, __entry->mode,
		  __entry->uid, __entry->gid, __entry->blocks)

How should I handle the "jbd2_dev_to_name(__entry->dev)" argument to
TP_printk?  The whole point of calling jbd2_dev_to_name() at TP_printk
time is to not bloat the ring buffer with a 32 byte devname.

     	       	     	      	     	  - Ted
