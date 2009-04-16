Return-Path: <linux-kernel-owner+w=401wt.eu-S1755378AbZDPQCD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbZDPQCD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 12:02:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754094AbZDPQBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 12:01:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:60102 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946AbZDPQBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 12:01:51 -0400
Date: Thu, 16 Apr 2009 11:58:44 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Avadh Patel <avadh4all@gmail.com>
Subject: Re: [PATCH 5/5] tracing: add saved_cmdlines file to show cached task
 comms
In-Reply-To: <20090416155444.GD6004@nowhere>
Message-ID: <alpine.DEB.2.00.0904161156070.20429@gandalf.stny.rr.com>
References: <20090416021830.556671772@goodmis.org> <20090416021928.956953374@goodmis.org> <20090416155444.GD6004@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 16 Apr 2009, Frederic Weisbecker wrote:

> On Wed, Apr 15, 2009 at 10:18:35PM -0400, Steven Rostedt wrote:
> > From: Avadh Patel <avadh4all@gmail.com>
> > 
> > Export the cached task comms to userspace. This allows user apps to translate
> > the pids from a trace into their respective task command lines.
> 
> 
> Hi,
> 
> I don't understand why this is needed. The pid is already resolved
> to its task comm into the trace.

Nope, it is not. The trace buffer does not hold the comm. It is in an 
internal cache within ftrace. This exports this table.

> 
> Or is there another reason?

If you were to perform a trace, and then stop it. Only the pids are in the 
trace buffer. If those processes end, there's no way to find out what 
process were attached to those pids. This table maps the pids in the 
buffer to the comms saved in the cache. As long as you don't run another 
trace, the cache will hold the pids in the trace.

Note, this is for reading the binary data files.

-- Steve

