Return-Path: <linux-kernel-owner+w=401wt.eu-S1753012AbYKXMVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012AbYKXMVP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 07:21:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbYKXMU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 07:20:59 -0500
Received: from tomts43.bellnexxia.net ([209.226.175.110]:60911 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751205AbYKXMU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 07:20:58 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswEAN8oKklMROB9/2dsb2JhbACBbc5Cgnw
Date: Mon, 24 Nov 2008 07:20:55 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Hellwig <hch@infradead.org>
Cc: ltt-dev@lists.casi.polymtl.ca, Zhaolei <zhaolei@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: LTTng kernel integration roadmap, update
Message-ID: <20081124122055.GA18626@Krystal>
References: <20081124112842.GA15615@Krystal> <20081124114124.GA32459@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20081124114124.GA32459@infradead.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 07:08:44 up 7 days, 12:49,  4 users,  load average: 1.13, 0.93,
	0.69
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Hellwig (hch@infradead.org) wrote:
> On Mon, Nov 24, 2008 at 06:28:42AM -0500, Mathieu Desnoyers wrote:
> > - trimmed-down lttv for the kernel tree
> >   Need to look at
> >   git://git.kernel.org/pub/scm/linux/kernel/git/sam/test.git#master
> >   tests/ directory, which permits building userspace tools with the
> >   Linux kernel. I recently got the idea of populating debugfs with
> >   userspace tools that would sits in kernel module data. How (in)sane
> >   does this idea look ? That would seems like a rather good solution to
> >   ship the userspace tool with the kernel.
> 
> Completely insane I'd say.  Debugfs is per defintion populated from
> kernelspace, and adding another mixed user/kernel populated fs like
> devfs is a rather bad idea.  I don't quite see any point in shipping
> lttv with the kernel tree either, it shouldn't really need knowledge of
> the kernel version.
> 

The key idea behind this is to answer to Thomas Gleixner concerns, who
supports that a tracer should output data in text-format only so it can
be used with tools kernel developers have on their system, like "cat".

However, getting data out of the kernel efficiently simply cannot be
done with such approach. Therefore, LTTng needs its own userspace tools
to splice the data out of the kernel efficiently. Another tool is used
to pretty-print the binary data into text.

Then the problem becomes : we have to make the userspace tool easy
enough to deploy so even Linus can find and use it. ;)

But indeed, the trace buffers are versioned, so if the format changes
between kernel versions, the userspace tools will detect it and the user
will know it must update its tools. So it's not really a problem there.

The question that prevails is therefore : should we ship userspace
binary with the kernel tree at all ? And if yes, how should the resuting
executables be packaged and deployed ? Should it be installed in the
system along with kernel modules or should it be populated into a
filesystem populated by kernelspace ?

Or is it better to do as we have always done and keep the userspace
tools separated from the kernel tree ?

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
