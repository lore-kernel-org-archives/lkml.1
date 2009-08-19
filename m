Return-Path: <linux-kernel-owner+w=401wt.eu-S1753177AbZHSQ1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbZHSQ1R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 12:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753148AbZHSQ1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 12:27:16 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:36121 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbZHSQ1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 12:27:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DgXCRvPyMwxJnhdmzGVbIP0CAYt18muIavhfAM82onZ5TdbyOhzjeEqmbWG4kqdD4C
         UwVhNsfL9EwlXuRP5S/ewYkXgQVzZr6LaIFMDuXcPdOTZusPLvjWKBbXdefy2DY4W0jX
         8ubccCwV9Zaiy943HykudFp/udialAVNCxnks=
Date: Wed, 19 Aug 2009 18:27:13 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       stephane eranian <eranian@googlemail.com>
Subject: Re: [PATCH 4/4][RFC] perf_counter: Allow sharing of output channels
Message-ID: <20090819162711.GE4972@nowhere>
References: <20090819091823.916851355@chello.nl> <20090819092023.980284148@chello.nl> <20090819161934.GD4972@nowhere> <1250699068.8282.108.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250699068.8282.108.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 19, 2009 at 06:24:28PM +0200, Peter Zijlstra wrote:
> On Wed, 2009-08-19 at 18:19 +0200, Frederic Weisbecker wrote:
> > On Wed, Aug 19, 2009 at 11:18:27AM +0200, Peter Zijlstra wrote:
> > > Provide the ability to configure a counter to send its output to
> > > another (already existing) counter's output stream.
> > > 
> > > [ compile tested only ]
> > > 
> > > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > Cc: stephane eranian <eranian@googlemail.com>
> > > +int perf_counter_set_output(struct perf_counter *counter, int output_fd)
> > > +{
> > > +	struct perf_counter *output_counter = NULL;
> > > +	struct file *output_file = NULL;
> > > +	struct perf_counter *old_output;
> > > +	int fput_needed = 0;
> > > +	int ret = -EINVAL;
> > > +
> > > +	if (!output_fd)
> > > +		goto set;
> > > +
> > > +	output_file = fget_light(output_fd, &fput_needed);
> > > +	if (!output_file)
> > > +		return -EBADF;
> > > +
> > > +	if (output_file->f_op != &perf_fops)
> > > +		goto out;
> > > +
> > > +	output_counter = output_file->private_data;
> > > +
> > > +	/* Don't chain output fds */
> > > +	if (output_counter->output)
> > > +		goto out;
> > 
> > 
> > 
> > If you don't chain them, how do you propagate more than one
> > path of output redirected?
> 
> you mean, fd2->fd1->fd0 ?
> 
> You don't, that sounds like a silly thing to do, do fd1->fd0, fd2->fd0
> instead.
> 


Ok.

