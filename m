Return-Path: <linux-kernel-owner+w=401wt.eu-S1752648AbXLDTlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648AbXLDTlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 14:41:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751369AbXLDTlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 14:41:31 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58454 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751296AbXLDTla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 14:41:30 -0500
Date: Tue, 4 Dec 2007 11:39:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org, mmlnx@us.ibm.com,
       dipankar@in.ibm.com, dsmith@redhat.com, paulmck@us.ibm.com
Subject: Re: [patch 1/2] Linux Kernel Markers - Support Multiple Probes
Message-Id: <20071204113954.c1dc9d87.akpm@linux-foundation.org>
In-Reply-To: <20071204192100.GB31752@Krystal>
References: <20071204181845.895090222@polymtl.ca>
	<20071204182402.940135178@polymtl.ca>
	<20071204110648.dd918789.akpm@linux-foundation.org>
	<20071204192100.GB31752@Krystal>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Dec 2007 14:21:00 -0500
Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> > > + */
> > > +void marker_probe_cb(const struct marker *mdata, void *call_private,
> > > +	const char *fmt, ...)
> > > +{
> > > +	va_list args;
> > > +	char ptype;
> > > +
> > > +	preempt_disable();
> > 
> > What are the preempt_disable()s doing in here?
> > 
> > Unless I missed something obvious, a comment is needed here (at least).
> > 
> 
> They make sure the teardown of the callbacks can be done correctly when
> they are in modules and they insure RCU read coherency. Will add
> comment.

So shouldn't it be using rcu_read_lock()?  If that does not suit, should we
be adding new rcu primitives rather than open-coding and adding dependencies?
