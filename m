Return-Path: <linux-kernel-owner+w=401wt.eu-S1753979AbZDZLGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979AbZDZLGV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 07:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751721AbZDZLGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 07:06:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52839 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258AbZDZLGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 07:06:09 -0400
Date: Sun, 26 Apr 2009 13:05:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Greg KH <greg@kroah.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 5/5] tracing/events: make modules have their own
	file_operations structure
Message-ID: <20090426110526.GA10391@elte.hu>
References: <20090425042030.431477667@goodmis.org> <20090425042633.428284874@goodmis.org> <20090425172654.GC12135@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090425172654.GC12135@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Greg KH <greg@kroah.com> wrote:

> On Sat, Apr 25, 2009 at 12:20:35AM -0400, Steven Rostedt wrote:
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > For proper module reference counting, the file_operations that modules use
> > must have the "owner" field set to the module. Unfortunately, the trace events
> > use share file_operations. The same file_operations are used by all both
> > kernel core and all modules.
> > 
> > This patch makes the modules allocate their own file_operations and
> > copies the functions from the core kernel. This allows those file
> > operations to be owned by the module.
> > 
> > Care is taken to free this code on module unload.
> > 
> > Thanks to Greg KH for reminding me that file_operations must be owned
> > by the module to have reference counting take place.
> > 
> > Cc: Greg KH <greg@kroah.com>
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> Looks good, feel free to add an:
> 	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> to it.

I've amended the final commit with your ack - thanks guys!

	Ingo
