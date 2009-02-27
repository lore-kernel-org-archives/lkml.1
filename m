Return-Path: <linux-kernel-owner+w=401wt.eu-S1757820AbZB0Oqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757820AbZB0Oqo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 09:46:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757660AbZB0Oq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 09:46:28 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:62009 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757209AbZB0Oq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 09:46:27 -0500
Date: Fri, 27 Feb 2009 09:46:20 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/5] tracing: add tracer dependent options to options
 directory
In-Reply-To: <20090226215006.ee686bfe.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.0902270944220.25593@gandalf.stny.rr.com>
References: <20090227053410.928389664@goodmis.org> <20090227053442.333424258@goodmis.org> <20090226215006.ee686bfe.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 26 Feb 2009, Andrew Morton wrote:

> On Fri, 27 Feb 2009 00:34:12 -0500 Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > +	topts = kzalloc(sizeof(*topts) * (cnt + 1), GFP_KERNEL);
> 
> nit: kcalloc() checks for multiplicative overflow, whereas the above
> does not.  It sets a good example ;)

Thanks, I'll have to add that to my clean ups. I originally had it as 
kmalloc, and just set the last entry to NULL by hand. Then I realized 
that if an error happened during initialization of one of the entries, it 
may not be NULL, so I went back and changed it to kzalloc, never thinking 
about kcalloc.

-- Steve

