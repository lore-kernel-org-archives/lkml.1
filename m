Return-Path: <linux-kernel-owner+w=401wt.eu-S1754253AbYI2Xfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253AbYI2Xfv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 19:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751897AbYI2Xfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 19:35:44 -0400
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:39839 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751602AbYI2Xfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 19:35:43 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuYEAJ/94EhMQWq+/2dsb2JhbACBZLsSgWc
Date: Mon, 29 Sep 2008 19:35:40 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH v10 Golden] Unified trace buffer
Message-ID: <20080929233539.GA31143@Krystal>
References: <20080925185154.230259579@goodmis.org> <20080925185236.244343232@goodmis.org> <alpine.DEB.1.10.0809252101080.8124@gandalf.stny.rr.com> <48DC406D.1050508@redhat.com> <alpine.DEB.1.10.0809261245420.21618@gandalf.stny.rr.com> <alpine.DEB.1.10.0809261349400.21618@gandalf.stny.rr.com> <alpine.DEB.1.10.0809261631420.21618@gandalf.stny.rr.com> <alpine.DEB.1.10.0809262148070.30105@gandalf.stny.rr.com> <alpine.DEB.1.10.0809270203270.1628@gandalf.stny.rr.com> <alpine.DEB.1.10.0809291202180.5493@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0809291202180.5493@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:33:36 up 117 days,  4:14, 10 users,  load average: 0.19, 0.29,
	0.40
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
[...]
> +/*
> + * This hack stolen from mm/slob.c.
> + * We can store per page timing information in the page frame of the page.
> + * Thanks to Peter Zijlstra for suggesting this idea.
> + */
> +struct buffer_page {
> +	union {
> +		struct {
> +			unsigned long	 flags;		/* mandatory */
> +			atomic_t	 _count;	/* mandatory */
> +			u64		 time_stamp;	/* page time stamp */
> +			unsigned	 size;		/* size of page data */
> +			struct list_head list;		/* list of free pages */
> +		};
> +		struct page page;
> +	};
> +};
> +

Hi Steven,

You should have a look at mm/slob.c free_slob_page(). I think your page
free will generate a "bad_page" call due to mapping != NULL and mapcount
!= 0. I just ran into this in my own code. :)

Regards,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
