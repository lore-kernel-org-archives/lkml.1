Return-Path: <linux-kernel-owner+w=401wt.eu-S1757481AbZBKMf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481AbZBKMf5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 07:35:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757178AbZBKMfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 07:35:34 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56400 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757157AbZBKMfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 07:35:32 -0500
Date: Wed, 11 Feb 2009 13:35:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       fweisbec@gmail.com, penberg@cs.helsinki.fi,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] trace: splice support for tracing_pipe
Message-ID: <20090211123526.GF16535@elte.hu>
References: <cover.1234159200.git.eduard.munteanu@linux360.ro> <83d0bfae11560e926bea9c9e572d6facef145b47.1234159200.git.eduard.munteanu@linux360.ro> <da7111334b2e95966758bf982a7bcf3b31ccba9c.1234159200.git.eduard.munteanu@linux360.ro> <alpine.DEB.1.10.0902091048310.14528@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0902091048310.14528@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Mon, 9 Feb 2009, Eduard - Gabriel Munteanu wrote:
> > +
> > +static ssize_t tracing_splice_read_pipe(struct file *filp,
> > +					loff_t *ppos,
> > +					struct pipe_inode_info *pipe,
> > +					size_t len,
> > +					unsigned int flags)
> > +{
> > +	struct page *pages[PIPE_BUFFERS];
> > +	struct partial_page partial[PIPE_BUFFERS];
> > +	struct trace_iterator *iter = filp->private_data;
> > +	struct splice_pipe_desc spd = {
> > +		.pages = pages,
> > +		.partial = partial,
> > +		.nr_pages = 0, /* This gets updated below. */
> > +		.flags = flags,
> > +		.ops = &tracing_pipe_buf_ops,
> > +		.spd_release = tracing_spd_release_pipe,
> > +	};
> 
> Note, this is getting a little stack heavy. It is still in bounds,
> but I get very nervous when I see structure arrays on the stack.
> If either the structure or the array grows large, we can be in trouble.

Good point - but note that this is how splice support is implemented in
a number of other files - so if PIPE_BUFFERS or partial_page grows in
size, those places will fail too.

	Ingo
