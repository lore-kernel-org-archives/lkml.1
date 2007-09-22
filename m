Return-Path: <linux-kernel-owner+w=401wt.eu-S1762131AbXIVHQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762131AbXIVHQu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 03:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752967AbXIVHQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 03:16:43 -0400
Received: from ozlabs.org ([203.10.76.45]:37937 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833AbXIVHQm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 03:16:42 -0400
Subject: Re: [patch 1/8] Immediate Values - Global Modules List and Module
	Mutex
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20070921133719.GC13129@Krystal>
References: <20070911004541.GA4360@Krystal>
	 <1189487938.20631.53.camel@localhost.localdomain>
	 <20070911142733.GA7850@Krystal>
	 <1189662432.32322.1.camel@localhost.localdomain>
	 <20070913212107.GA15826@Krystal>
	 <1189725317.7262.23.camel@localhost.localdomain>
	 <20070914153230.GA29743@Krystal>
	 <1190069659.7262.141.camel@localhost.localdomain>
	 <20070918134131.GA22690@Krystal>
	 <1190291351.7262.248.camel@localhost.localdomain>
	 <20070921133719.GC13129@Krystal>
Content-Type: text/plain
Date: Sat, 22 Sep 2007 17:15:57 +1000
Message-Id: <1190445357.27805.66.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-21 at 09:37 -0400, Mathieu Desnoyers wrote:
> > Good points.  Well I'd say hiding it all behind a friendly
> > "immediate_set()" interface is the best option then.
> 
> Then we can't benefit of the __init section to have the code removed
> after boot. I don't see the point in doing so.

Because having a magic early version is a bad burden to place on
programmers.  It's an admission of failure that we cannot create a
simpler interface.

AFAICT it's a handful of bytes which would be freed.

> > Is this really worth worrying about?  Isn't there already a problem with
> > printk() in nmi?
> 
> printk() is just an example taken from my current instrumentation. Let's
> say I plan to instrument kmalloc() (which will happen someday): it's
> used in every context, including NMI.

Again, I don't think calling kmalloc in NMI is valid.  Unless I'm
missing something, any code which uses locks is susceptible to deadlock
if used from an NMI handler.   So you really can't do much.

It's nice that you have the perfect solution.  But I'd really rather see
a sufficient solution which is 1/4 of the code and 1/10 the complexity.

Rusty.

