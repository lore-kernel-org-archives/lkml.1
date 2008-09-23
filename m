Return-Path: <linux-kernel-owner+w=401wt.eu-S1754165AbYIWSpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165AbYIWSpn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 14:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbYIWSpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 14:45:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40569 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751823AbYIWSpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 14:45:34 -0400
Message-ID: <48D93665.8030200@linux-foundation.org>
Date: Tue, 23 Sep 2008 13:33:09 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Tom Zanussi <zanussi@comcast.net>,
       prasad@linux.vnet.ibm.com, Martin Bligh <mbligh@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, od@novell.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, hch@lst.de,
       David Wilder <dwilder@us.ibm.com>, linux-mm@kvack.org
Subject: Re: Unified tracing buffer
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com> <1221869279.8359.31.camel@lappy.programming.kicks-ass.net> <20080922140740.GB5279@in.ibm.com> <1222094724.16700.11.camel@lappy.programming.kicks-ass.net> <1222147545.6875.135.camel@charm-linux> <1222162270.16700.57.camel@lappy.programming.kicks-ass.net> <20080923181313.GA4947@Krystal>
In-Reply-To: <20080923181313.GA4947@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> 
> I think we should instead try to figure out what is currently missing in
> the kernel vmap mechanism (probably the ability to vmap from large 4MB
> pages after boot), and fix _that_ instead (if possible), which would not
> only benefit to tracing, but also to module support.

With some custom code one can vmap 2MB pages on x86. See the VMEMMAP support
in the x86 arch. The code in mm/sparse-vmemmap.c could be abstracted for a
general 2MB mapping API to reduce TLB pressure for the buffers. If there are
concerns about fragmentation then one could fallback to 4kb TLBs. See the
virtualizable compound page patchset which does something similar.

> I added Christoph Lameter to the CC list, he always comes with clever
> ideas. :)

Oh mostly we are just recycling the old ideas.
