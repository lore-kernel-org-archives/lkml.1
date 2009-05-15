Return-Path: <linux-kernel-owner+w=401wt.eu-S1756734AbZEOQ6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734AbZEOQ6K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 12:58:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753001AbZEOQ54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 12:57:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39459 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbZEOQ54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 12:57:56 -0400
Date: Fri, 15 May 2009 12:57:56 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] tracing: adding flags to events
Message-ID: <20090515165756.GA29760@infradead.org>
References: <alpine.DEB.2.00.0905141535360.30591@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0905141535360.30591@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nice! 

I gave it a try in the xfs tracer and it seems to work fine.  One little
suggestion, can we specifies the flags as the full value instead of bit
positions?  That's how the are specified in the enums/#defines naming
them (either in the 1<<n scheme or the 0x000n scheme) and translating
between the two is a bit cumbersome.

For some reason using it gives me warnings ala:

fs/xfs/linux-2.6/./xfs_trace.h: In function 'ftrace_raw_output_xfs_attr':
fs/xfs/linux-2.6/./xfs_trace.h:48: warning: array subscript is below array bounds

these look surprisingy similar to bogus gcc warnings I have in a couple
of other places in my build, just that here it's in generated code, so
it's hard to check the validity.

