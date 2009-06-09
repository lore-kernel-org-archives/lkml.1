Return-Path: <linux-kernel-owner+w=401wt.eu-S1758501AbZFIHNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758501AbZFIHNT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 03:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757065AbZFIHNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 03:13:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:45082 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757468AbZFIHNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 03:13:10 -0400
Subject: Re: [RFC PATCH 5/5] tracing/events: modify kmem print to new format
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
       Christoph Hellwig <hch@infradead.org>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Jiaying Zhang <jiayingz@google.com>
In-Reply-To: <20090609014747.188279837@goodmis.org>
References: <20090609014534.790466803@goodmis.org>
	 <20090609014747.188279837@goodmis.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 09 Jun 2009 09:12:42 +0200
Message-Id: <1244531562.13761.9955.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-08 at 21:45 -0400, Steven Rostedt wrote:

> +#define show_gfp_flags(end...)						\
> +	"0=GFP_NOWAIT,"							\
> +	"0x%lx=%s,0x%lx=%s,0x%lx=%s,0x%lx=%s,0x%lx=%s,0x%lx=%s,0x%lx=%s," \
> +	"0x%lx=%s,0x%lx=%s,0x%lx=%s,0x%lx=%s,0x%lx=%s,0x%lx=%s,0x%lx=%s," \
> +	"0x%lx=%s,0x%lx=%s,0x%lx=%s,0x%lx=%s,0x%lx=%s,0x%lx=%s,0x%lx=%s," \
> +	"0x%lx=%s,0x%lx=%s>" end ,					\
> +	(unsigned long)GFP_HIGHUSER_MOVABLE,	"GFP_HIGHUSER_MOVABLE", \
> +	(unsigned long)GFP_HIGHUSER,		"GFP_HIGHUSER",		\
> +	(unsigned long)GFP_USER,		"GFP_USER",		\
> +	(unsigned long)GFP_TEMPORARY,		"GFP_TEMPORARY",	\
> +	(unsigned long)GFP_KERNEL,		"GFP_KERNEL",		\
> +	(unsigned long)GFP_NOFS,		"GFP_NOFS",		\
> +	(unsigned long)GFP_ATOMIC,		"GFP_ATOMIC",		\
> +	(unsigned long)GFP_NOIO,		"GFP_NOIO",		\
> +	(unsigned long)__GFP_HIGH,		"GFP_HIGH",		\
> +	(unsigned long)__GFP_WAIT,		"GFP_WAIT",		\
> +	(unsigned long)__GFP_IO,		"GFP_IO",		\
> +	(unsigned long)__GFP_COLD,		"GFP_COLD",		\
> +	(unsigned long)__GFP_NOWARN,		"GFP_NOWARN",		\
> +	(unsigned long)__GFP_REPEAT,		"GFP_REPEAT",		\
> +	(unsigned long)__GFP_NOFAIL,		"GFP_NOFAIL",		\
> +	(unsigned long)__GFP_NORETRY,		"GFP_NORETRY",		\
> +	(unsigned long)__GFP_COMP,		"GFP_COMP",		\
> +	(unsigned long)__GFP_ZERO,		"GFP_ZERO",		\
> +	(unsigned long)__GFP_NOMEMALLOC,	"GFP_NOMEMALLOC",	\
> +	(unsigned long)__GFP_HARDWALL,		"GFP_HARDWALL",		\
> +	(unsigned long)__GFP_THISNODE,		"GFP_THISNODE",		\
> +	(unsigned long)__GFP_RECLAIMABLE,	"GFP_RECLAIMABLE",	\
> +	(unsigned long)__GFP_MOVABLE,		"GFP_MOVABLE"

Just curious, how unhappy does stuff become when we add a __GFP_ flag
and forget to extend this table?
