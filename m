Return-Path: <linux-kernel-owner+w=401wt.eu-S1755898AbYG2IZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898AbYG2IZl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 04:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753170AbYG2IZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 04:25:29 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:34816 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118AbYG2IZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 04:25:27 -0400
Subject: Re: [RFC PATCH 1/4] kmemtrace: Core implementation.
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, cl@linux-foundation.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org, rdunlap@xenotime.net,
       mpm@selenic.com, Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20080728173549.GA5185@localhost>
References: <1216751808-14428-1-git-send-email-eduard.munteanu@linux360.ro>
	 <1216751808-14428-2-git-send-email-eduard.munteanu@linux360.ro>
	 <1217237084.5998.5.camel@penberg-laptop> <20080728162916.GD17823@Krystal>
	 <20080728173549.GA5185@localhost>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 29 Jul 2008 11:25:27 +0300
Message-Id: <1217319927.7813.113.camel@penberg-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduard-Gabriel,

On Mon, 2008-07-28 at 20:35 +0300, Eduard - Gabriel Munteanu wrote:
> > > > +struct kmemtrace_event {
> > > > +	u8		event_id;	/* Allocate or free? */
> > > > +	u8		type_id;	/* Kind of allocation/free. */
> > > > +	u16		event_size;	/* Size of event */
> > > > +	s32		node;		/* Target CPU. */
> > > > +	u64		call_site;	/* Caller address. */
> > > > +	u64		ptr;		/* Pointer to allocation. */
> > > > +	u64		bytes_req;	/* Number of bytes requested. */
> > > > +	u64		bytes_alloc;	/* Number of bytes allocated. */
> > > > +	u64		gfp_flags;	/* Requested flags. */
> > > > +	s64		timestamp;	/* When the operation occured in ns. */
> > > > +} __attribute__ ((__packed__));
> > 
> > See below for detail, but this event record is way too big and not
> > adapted to 32 bits architectures.
> 
> Pekka, what do you think?

﻿Mathieu does have a good point of optimizing the memory use of an
individual event so I'm okay with that. But we really don't want to
force people the analyze the dump on same architecture where we captured
it. So as long as that is taken care of, I'm happy.

		Pekka

