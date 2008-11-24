Return-Path: <linux-kernel-owner+w=401wt.eu-S1753921AbYKXQ6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbYKXQ6w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 11:58:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753212AbYKXQ6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 11:58:44 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:51880 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935AbYKXQ6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 11:58:44 -0500
Date: Mon, 24 Nov 2008 11:58:40 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Christoph Hellwig <hch@infradead.org>, ltt-dev@lists.casi.polymtl.ca,
       Zhaolei <zhaolei@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: LTTng kernel integration roadmap, update
In-Reply-To: <20081124122055.GA18626@Krystal>
Message-ID: <alpine.DEB.1.10.0811241156030.20122@gandalf.stny.rr.com>
References: <20081124112842.GA15615@Krystal> <20081124114124.GA32459@infradead.org> <20081124122055.GA18626@Krystal>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 24 Nov 2008, Mathieu Desnoyers wrote:
> 
> The key idea behind this is to answer to Thomas Gleixner concerns, who
> supports that a tracer should output data in text-format only so it can
> be used with tools kernel developers have on their system, like "cat".
> 
> However, getting data out of the kernel efficiently simply cannot be
> done with such approach. Therefore, LTTng needs its own userspace tools
> to splice the data out of the kernel efficiently. Another tool is used
> to pretty-print the binary data into text.
> 
> Then the problem becomes : we have to make the userspace tool easy
> enough to deploy so even Linus can find and use it. ;)
> 
> But indeed, the trace buffers are versioned, so if the format changes
> between kernel versions, the userspace tools will detect it and the user
> will know it must update its tools. So it's not really a problem there.
> 
> The question that prevails is therefore : should we ship userspace
> binary with the kernel tree at all ? And if yes, how should the resuting
> executables be packaged and deployed ? Should it be installed in the
> system along with kernel modules or should it be populated into a
> filesystem populated by kernelspace ?
> 
> Or is it better to do as we have always done and keep the userspace
> tools separated from the kernel tree ?

I say keep the user space tools separate as much as possible.

What about having a meta-data file for all binary files. This meta-data 
could explain the format that is read. Big endian, little endian, the 
fields and offsets, the event ids etc.  This way we will not need a 
"version" file, which means absolutely nothing if you do not know what 
comes with that version. Any tool could look at the meta-data file and 
figure out what is in the buffers.

-- Steve

