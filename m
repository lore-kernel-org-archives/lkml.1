Return-Path: <linux-kernel-owner+w=401wt.eu-S1753292AbYIZWdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbYIZWdp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 18:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbYIZWdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 18:33:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:32881 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730AbYIZWdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 18:33:36 -0400
Date: Fri, 26 Sep 2008 19:31:29 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH v6] Unified trace buffer
Message-ID: <20080926223129.GF15446@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	prasad@linux.vnet.ibm.com,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Mathieu Desnoyers <compudj@krystal.dyndns.org>,
	"Frank Ch. Eigler" <fche@redhat.com>,
	David Wilder <dwilder@us.ibm.com>, hch@lst.de,
	Martin Bligh <mbligh@google.com>,
	Christoph Hellwig <hch@infradead.org>,
	Masami Hiramatsu <mhiramat@redhat.com>,
	Steven Rostedt <srostedt@redhat.com>
References: <20080925185154.230259579@goodmis.org> <20080925185236.244343232@goodmis.org> <alpine.DEB.1.10.0809252101080.8124@gandalf.stny.rr.com> <48DC406D.1050508@redhat.com> <alpine.DEB.1.10.0809261245420.21618@gandalf.stny.rr.com> <alpine.DEB.1.10.0809261349400.21618@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0809261349400.21618@gandalf.stny.rr.com>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Sep 26, 2008 at 02:05:44PM -0400, Steven Rostedt escreveu:
> + */
> +static inline void *
> +ring_buffer_event_data(struct ring_buffer_event *event)
> +{
> +	BUG_ON(event->type != RB_TYPE_DATA);
> +	/* If length is in len field, then array[0] has the data */
> +	if (event->len)
> +		return (void *)&event->array[0];
> +	/* Otherwise length is in array[0] and array[1] has the data */
> +	return (void *)&event->array[1];

Nitpick: Why cast to void *?

And sometimes you use the rb_ prefix, in other cases you use the longer
for ring_buffer_, is the ring_ namespace already used? Or can we make it
use rb_ consistently to shorten the names?

- Arnaldo
