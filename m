Return-Path: <linux-kernel-owner+w=401wt.eu-S1760498AbZEFTG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760498AbZEFTG0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 15:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753715AbZEFTGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 15:06:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44278 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753487AbZEFTGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 15:06:16 -0400
Subject: Re: [PATCH, RFC] sputrace: use the generic event tracer
From: Steven Rostedt <srostedt@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, cbe-oss-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090506171326.GA11199@lst.de>
References: <20090506102918.GA23278@lst.de> <20090506105748.GE25203@elte.hu>
	 <20090506165336.GC5997@nowhere>  <20090506171326.GA11199@lst.de>
Content-Type: text/plain
Organization: Red Hat
Date: Wed, 06 May 2009 15:05:39 -0400
Message-Id: <1241636739.11379.29.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2009-05-06 at 19:13 +0200, Christoph Hellwig wrote:
> On Wed, May 06, 2009 at 06:53:37PM +0200, Frederic Weisbecker wrote:
> > I don't know much the code you are tracing. But it is rare that
> > a const char * is safe on tracing. Still it could be, you just have to
> > ensure the string cannot be freed in any way because this pointer
> > will be stored in the ring buffer and it can be read and dereferenced later
> > in a random time, could be several years :-)
> > 
> > So if this pointer references built-in data, no problem with that.
> > But if it can freed (comes from a module, __initdata, ...), then
> > you should use the __string() field which does an strcpy on the
> > ring buffer.
> > 
> > If you think this is safe, then it's the best choice because
> > storing a pointer is of course less costly than an strcpy.
> > If so I will add the support for char * in the filters (trivial).
> 
> The pointer here only ever references string constants, it's always
> a string literal in the callers.

The worry is if this is used by modules. A constant string may not be
around when the buffer is read.

This should not be a problem because the formatting of the string is not
around either, and we just output 'unknown type'.  But I may be adding
code when a module is unloaded to reset the ring buffer if the module
registered any events. That's because we have other races to worry
about.

-- Steve


