Return-Path: <linux-kernel-owner+w=401wt.eu-S1758185AbXGNQsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185AbXGNQsc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 12:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755414AbXGNQsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 12:48:24 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40463 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348AbXGNQsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 12:48:23 -0400
Date: Sat, 14 Jul 2007 17:48:19 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Tom Zanussi <zanussi@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com, dwilder@us.ibm.com,
       hunt@redhat.com
Subject: Re: [RFC PATCH 2/3] Generic Trace Setup and Control (GTSC) code
Message-ID: <20070714164819.GA14489@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Tom Zanussi <zanussi@us.ibm.com>, linux-kernel@vger.kernel.org,
	adobriyan@gmail.com, dwilder@us.ibm.com, hunt@redhat.com
References: <1183173872.24291.144.camel@ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1183173872.24291.144.camel@ubuntu>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 29, 2007 at 10:24:32PM -0500, Tom Zanussi wrote:
> The Generic Tracing and Control Interface (GTSC) code.

The code looks fine to me from a first look, but the the name is just dumb.
Given that all your internal identifiers are trace_* or TRACE_ go all
the way and make it CONFIG_TRACE and lib/trace.c aswell.

Long term we probably want more complex tracing based on lttng, but I'm
a big fan of starting out simple and doing incremental changes.

So my 1c for merging this in 2.6.23 with the exports ripped out until
we actually grow modular users (which will probably come with the blktrace
markers conversion later on)

> +static inline struct trace_info *trace_setup(const char *root,
> +					     const char *name,
> +					     u32 buf_size,
> +					     u32 buf_nr,
> +					     u32 flags)

static inline struct trace_info *trace_setup(const char *root,
		const char *name, u32 buf_size, u32 buf_nr, u32 flags)

> + * Based on blktrace code, Copyright (C) 2006 Jens Axboe <axboe@suse.de>
> + * Moved to utt.c by Tom Zanussi <zanussi@us.ibm.com>, 2006

It's gstc.c now and should be trace.c, nevermind that filename doesn't
really belong here anyway :)

> +unsigned long long trace_timestamp(void)
> +{
> +	return sched_clock();
> +}
> +EXPORT_SYMBOL_GPL(trace_timestamp);

Using sched_clock is quite dangerous.  And just adding a wrapper to get
it exported is not nice either :)

