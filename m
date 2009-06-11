Return-Path: <linux-kernel-owner+w=401wt.eu-S1762112AbZFKDZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762112AbZFKDZy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 23:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756968AbZFKDZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 23:25:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:41587 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155AbZFKDZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 23:25:46 -0400
Date: Wed, 10 Jun 2009 23:25:46 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       "Martin J. Bligh" <mbligh@mbligh.org>,
       Christoph Hellwig <hch@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Huang Ying <ying.huang@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH 3/3] ring-buffer: add design document
In-Reply-To: <4A3076C9.2030203@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0906102324140.30552@gandalf.stny.rr.com>
References: <20090610195311.767699959@goodmis.org> <20090610195525.429316815@goodmis.org> <4A3076C9.2030203@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 11 Jun 2009, Hidetoshi Seto wrote:
> Steven Rostedt wrote:
> > +
> > +  +------+
> > +  |reader|          RING BUFFER
> > +  |page  |-------------------+
> > +  +------+ <---------------+ v
> > +    |  ^          +---+   +---+   +---+
> > +    |  |          |   |-->|   |-->|   |
> > +    |  |          |   |<--|   |<--|   |<-+
> > +    |  |          +---+   +---+   +---+  |
> > +    |  |             |             ^ |   |
> > +    |  |             +-------------+ |   |
> > +    |  +-----------------------------+   |
> > +    +------------------------------------+
> 
> It seems the middle of three pages have 2 prev arrows... ?

Yes that is a mistake. Thanks, I'll fix it.
> > +
> > +It does a cmpxchg with the pointer to the previous head page to make it
> > +point to the reader page. Note that the new pointer does not have the HEADER
> > +flag set.  This action atomically moves the head page forward.
> > +
> > +  +------+
> > +  |reader|          RING BUFFER
> > +  |page  |-------H-----------+
> > +  +------+ <---------------+ v
> > +    |  ^          +---+   +---+   +---+
> > +    |  |          |   |-->|   |-->|   |
> > +    |  |          |   |<--|   |<--|   |<-+
> > +    |  |          +---+   +---+   +---+  |
> > +    |  |             |             ^ |   |
> > +    |  |             +-------------+ |   |
> > +    |  +-----------------------------+   |
> > +    +------------------------------------+
> > +
> 
> Ditto.

Ditto too ;-)

Thanks,

-- Steve

