Return-Path: <linux-kernel-owner+w=401wt.eu-S1752699AbYIXVdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbYIXVdx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 17:33:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751910AbYIXVdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 17:33:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:38723 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbYIXVdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 17:33:45 -0400
Date: Wed, 24 Sep 2008 17:33:43 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "Frank Ch. Eigler" <fche@redhat.com>
cc: Martin Bligh <mbligh@google.com>, David Miller <davem@davemloft.net>,
       torvalds@linux-foundation.org, peterz@infradead.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       akpm@linux-foundation.org, prasad@linux.vnet.ibm.com,
       compudj@krystal.dyndns.org, dwilder@us.ibm.com, hch@lst.de,
       zanussi@comcast.net, srostedt@redhat.com
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
In-Reply-To: <20080924212433.GB14763@redhat.com>
Message-ID: <alpine.DEB.1.10.0809241731020.10631@gandalf.stny.rr.com>
References: <alpine.LFD.1.10.0809241027251.3265@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809241340500.6759@gandalf.stny.rr.com> <alpine.LFD.1.10.0809241313000.3265@nehalem.linux-foundation.org> <20080924.133720.72895701.davem@davemloft.net>
 <33307c790809241351k53f322a1o794dd73255393e11@mail.gmail.com> <20080924212433.GB14763@redhat.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 24 Sep 2008, Frank Ch. Eigler wrote:

> Hi -
> 
> On Wed, Sep 24, 2008 at 01:51:55PM -0700, Martin Bligh wrote:
> > [...]
> > One thing we said we could do is compile the "decompaction" tools
> > along with the kernel, in the kernel tree. Then if we change the in-kernel
> > format, you don't break all the userspace tools. 
> 
> If the common tracing idea still includes kernel-supplied ASCII as an
> alternative to binary (so that one could grep some debugfs file), then
> it would be nice to have some common code for decoding the trace
> records offline.
> 
> If we can associate a simple specific struct type ("struct
> ftrace_event") with each trace id type in an object-code-resident
> table, we could automate some of this.  The kernel build process could
> sniff dwarf data (a la acme's struct-layout-printing dwarves) at or
> before modpost time to generate a snippet of C code for each such
> event struct.  That C code could be the generic ASCII-printing
> callback for use by debugfs.  A variant could be a userspace-usable
> version.  Given the same id-to-struct-name mapping, Sytemtap could
> expose event records field by field, by name.

Hi Frank,

I think we are going a step below this. That is, the ring buffer itself 
will not be expecting to expose anything to the user interface.

That will need to be done in a higher layer. Right now we just want a way 
to stabilize the ring buffer infrastructure. Then we can add a tracing 
infrastructure on top that can do the above work.

I'm working on having a ring_buffer.c that will do the bare minimum, and a 
trace_buffer.c that will be a layer on top that will add more 
functionality. What you are asking for may apply there.

Thanks,

-- Steve

