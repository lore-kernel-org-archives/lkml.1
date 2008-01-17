Return-Path: <linux-kernel-owner+w=401wt.eu-S1753582AbYAQRuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582AbYAQRuS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 12:50:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752088AbYAQRuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 12:50:05 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39144 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751246AbYAQRuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 12:50:03 -0500
Date: Thu, 17 Jan 2008 09:46:59 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Paul Mackerras <paulus@samba.org>, john stultz <johnstul@us.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [RFC PATCH 16/22 -v2] add get_monotonic_cycles
In-Reply-To: <20080117041443.GA9513@Krystal>
Message-ID: <alpine.LFD.1.00.0801170945120.14959@woody.linux-foundation.org>
References: <20080116031730.GA2164@Krystal> <Pine.LNX.4.58.0801152238130.19680@gandalf.stny.rr.com> <20080116145604.GB31329@Krystal> <1f1b08da0801161436k4a7ac1e3kd83590951e7bebb9@mail.gmail.com> <1200523867.6127.5.camel@localhost.localdomain>
 <Pine.LNX.4.58.0801161827450.17781@gandalf.stny.rr.com> <1200536889.6127.52.camel@localhost.localdomain> <20080117024000.GD2322@Krystal> <20080117025004.GE2322@Krystal> <18318.51622.37470.246611@cargo.ozlabs.ibm.com> <20080117041443.GA9513@Krystal>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 16 Jan 2008, Mathieu Desnoyers wrote:
> 
> Or could we map a per-thread page that would contradict this
> "definition" ?

Over my dead body.

It's been done before. Many times. It's horrible, and means that you need 
to flush the TLB on context switches between threads and cannot share the 
same hw page tables across CPU's (since now different CPU's run different 
threads).

It generally makes threads pointless. You might as well implement them as 
processes with shared mmap.

		Linus
