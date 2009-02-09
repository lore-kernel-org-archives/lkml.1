Return-Path: <linux-kernel-owner+w=401wt.eu-S1755612AbZBIPuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612AbZBIPuQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 10:50:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754773AbZBIPuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 10:50:03 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:47302 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633AbZBIPuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 10:50:01 -0500
Date: Mon, 9 Feb 2009 10:49:59 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
cc: mingo@elte.hu, fweisbec@gmail.com, penberg@cs.helsinki.fi,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] trace: splice support for tracing_pipe
In-Reply-To: <da7111334b2e95966758bf982a7bcf3b31ccba9c.1234159200.git.eduard.munteanu@linux360.ro>
Message-ID: <alpine.DEB.1.10.0902091048310.14528@gandalf.stny.rr.com>
References: <cover.1234159200.git.eduard.munteanu@linux360.ro> <83d0bfae11560e926bea9c9e572d6facef145b47.1234159200.git.eduard.munteanu@linux360.ro> <da7111334b2e95966758bf982a7bcf3b31ccba9c.1234159200.git.eduard.munteanu@linux360.ro>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 9 Feb 2009, Eduard - Gabriel Munteanu wrote:
> +
> +static ssize_t tracing_splice_read_pipe(struct file *filp,
> +					loff_t *ppos,
> +					struct pipe_inode_info *pipe,
> +					size_t len,
> +					unsigned int flags)
> +{
> +	struct page *pages[PIPE_BUFFERS];
> +	struct partial_page partial[PIPE_BUFFERS];
> +	struct trace_iterator *iter = filp->private_data;
> +	struct splice_pipe_desc spd = {
> +		.pages = pages,
> +		.partial = partial,
> +		.nr_pages = 0, /* This gets updated below. */
> +		.flags = flags,
> +		.ops = &tracing_pipe_buf_ops,
> +		.spd_release = tracing_spd_release_pipe,
> +	};

Note, this is getting a little stack heavy. It is still in bounds,
but I get very nervous when I see structure arrays on the stack.
If either the structure or the array grows large, we can be in trouble.

-- Steve

