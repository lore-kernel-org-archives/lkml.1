Return-Path: <linux-kernel-owner+w=401wt.eu-S1753374AbYIZTBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbYIZTBY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 15:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbYIZTBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 15:01:17 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36951 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593AbYIZTBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 15:01:16 -0400
Subject: Re: [PATCH v6] Unified trace buffer
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
In-Reply-To: <alpine.DEB.1.10.0809261349400.21618@gandalf.stny.rr.com>
References: <20080925185154.230259579@goodmis.org>
	 <20080925185236.244343232@goodmis.org>
	 <alpine.DEB.1.10.0809252101080.8124@gandalf.stny.rr.com>
	 <48DC406D.1050508@redhat.com>
	 <alpine.DEB.1.10.0809261245420.21618@gandalf.stny.rr.com>
	 <alpine.DEB.1.10.0809261349400.21618@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Fri, 26 Sep 2008 20:59:17 +0200
Message-Id: <1222455557.16700.285.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-09-26 at 14:05 -0400, Steven Rostedt wrote:

> +struct buffer_page {
> +	u64		time_stamp;
> +	unsigned char	body[];
> +};
> +
> +#define BUF_PAGE_SIZE (PAGE_SIZE - sizeof(u64))

Since you're already using the page frame, you can stick this per page
timestamp in there as well, and get the full page for data.

You can either use a struct page overlay like slob does, or add a u64 in
the union that contains struct {private, mapping}.



