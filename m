Return-Path: <linux-kernel-owner+w=401wt.eu-S1755069AbXIUA7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069AbXIUA7g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 20:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752256AbXIUA73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 20:59:29 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:40300 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbXIUA72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 20:59:28 -0400
Date: Thu, 20 Sep 2007 20:58:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 1/4] Linux Kernel Markers - Architecture Independent
	Code
Message-ID: <20070921005837.GA4951@goodmis.org>
References: <20070918211324.161373216@polymtl.ca> <20070918211459.193904061@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070918211459.193904061@polymtl.ca>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2007 at 05:13:25PM -0400, Mathieu Desnoyers wrote:
> +/*
> + * Sets the probe callback corresponding to one marker.
> + */
> +static int set_marker(struct marker_entry **entry,
> +			struct __mark_marker *elem)
> +{
> +	int ret;
> +	BUG_ON(strcmp((*entry)->name, elem->name) != 0);

Can you switch this at least to WARN_ON?  Killing a system with X
running where the user just sees a freeze is not that nice. But a nasty
message in dmesg is very noticable.

-- Steve

> +
> +	if ((*entry)->format) {
> +		if (strcmp((*entry)->format, elem->format) != 0) {
> +			printk(KERN_NOTICE
> +				"Format mismatch for probe %s "
> +				"(%s), marker (%s)\n",
> +				(*entry)->name,
> +				(*entry)->format,
> +				elem->format);
> +			return -EPERM;
> +		}
> +	} else {
> +		ret = marker_set_format(entry, elem->format);
> +		if (ret)
> +			return ret;
> +	}
> +	elem->call = (*entry)->probe;
> +	elem->pdata = (*entry)->pdata;
> +	_immediate_set(elem->state, 1);
> +	return 0;
> +}
