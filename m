Return-Path: <linux-kernel-owner+w=401wt.eu-S1753290AbYIZRjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbYIZRjU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 13:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752209AbYIZRjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 13:39:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54827 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753443AbYIZRjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 13:39:01 -0400
Date: Fri, 26 Sep 2008 10:37:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
cc: Steven Rostedt <rostedt@goodmis.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH v5] Unified trace buffer
In-Reply-To: <20080926173130.GE15446@ghostprotocols.net>
Message-ID: <alpine.LFD.1.10.0809261036420.3265@nehalem.linux-foundation.org>
References: <20080925185154.230259579@goodmis.org> <20080925185236.244343232@goodmis.org> <alpine.DEB.1.10.0809252101080.8124@gandalf.stny.rr.com> <48DC406D.1050508@redhat.com> <alpine.DEB.1.10.0809261245420.21618@gandalf.stny.rr.com>
 <20080926173130.GE15446@ghostprotocols.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 26 Sep 2008, Arnaldo Carvalho de Melo wrote:
> 
> Why do you need __packed__ here? With or without it the layout is the
> same:

Indeed. And on some architectures 'packed' will actually mean that the 
compiler may think that it's unaligned, and then generate much worse code 
to access the fields. So if you align things anyway (and you do), then 
'packed' is the wrong thing to do.

		Linus
