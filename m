Return-Path: <linux-kernel-owner+w=401wt.eu-S1754364AbZFHTvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364AbZFHTvn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 15:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752806AbZFHTvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 15:51:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49440 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372AbZFHTvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 15:51:36 -0400
Subject: Re: [PATCH] perf_counter: extensible perf_counter_attr
From: Peter Zijlstra <peterz@infradead.org>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4A2D6041.4050309@linux.vnet.ibm.com>
References: <1244481941.13761.9119.camel@twins>
	 <4A2D6041.4050309@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Mon, 08 Jun 2009 21:51:20 +0200
Message-Id: <1244490680.6691.1.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-08 at 12:02 -0700, Corey Ashford wrote:
> Hi Peter,
> 
> Peter Zijlstra wrote:
> > Allow extending the perf_counter_attr structure by linking extended
> > structures to it.
> > 
> > Also, should we grow the directly reserved space in the structure a
> > little more?
> > 
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > ---
> >  include/linux/perf_counter.h |    7 +++++++
> >  kernel/perf_counter.c        |    1 +
> >  2 files changed, 8 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
> > index 3586df8..781d8ce 100644
> > --- a/include/linux/perf_counter.h
> > +++ b/include/linux/perf_counter.h
> > @@ -175,6 +175,13 @@ struct perf_counter_attr {
> >  	__u32			__reserved_3;
> > 
> >  	__u64			__reserved_4;
> > +
> > +	struct perf_counter_attr_ext *ext_attrs;
> > +};
> > +
> > +struct perf_counter_attr_ext {
> > +	struct perf_counter_attr_ext 	*next;
> > +	__u64				perf_attr_ext_type;
> >  };
> 
> Let's say I want to extend the attributes by four 64-bit quantities... from the 
> above definition, I'd need four additional records chained together, right?  How 
> about something like this instead:

Ah, the idea was to do something like:

struct perf_counter_attr_feature {
	struct perf_counter_attr_ext	head;
	... more stuff ...
};

and set head.perf_attr_ext_type = PERF_ATTR_EXT_FEATURE



