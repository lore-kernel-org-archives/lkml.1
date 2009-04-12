Return-Path: <linux-kernel-owner+w=401wt.eu-S1751955AbZDLRYD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955AbZDLRYD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 13:24:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751653AbZDLRXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 13:23:50 -0400
Received: from THUNK.ORG ([69.25.196.29]:45578 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550AbZDLRXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 13:23:49 -0400
Date: Sun, 12 Apr 2009 13:23:44 -0400
From: Theodore Tso <tytso@mit.edu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, RFC 0/3] Improvements to the tracing documentation
Message-ID: <20090412172344.GC10547@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
	Steven Rostedt <rostedt@goodmis.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>
References: <1239479479-2603-1-git-send-email-tytso@mit.edu> <20090412092524.GA30349@elte.hu> <20090412121533.GB10547@mit.edu> <20090412130105.GB20281@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090412130105.GB20281@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 12, 2009 at 03:01:05PM +0200, Ingo Molnar wrote:
> Btw., you mention ext4 and jbd2 new-style tracepoints in the text. 
> Does this mean you already have them coded up (i havent seen any 
> patch posting from you), just that you cannot push it upstream yet 
> because ext4 can be a module? We'll have modular new-style 
> tracepoints soon.

Yes, I coded them up recently.  I wanted to do some performance
measurements, and being able to interleave the ext4 tracepoint logs
with the block I/o tracer was definitely handy.  Also, not having to
fight with balky userspace tools (whether it is out-of-tree kernel
support code, or random graphical userspace libraries when I could
really care less about a GUI interface) was definitely a big win.

I only had two real problems.  One is that the block I/O tracer only
traces "real" devices, and not device mapper devices --- I could user
the blktrace userspace tool, but then the results wouldn't be properly
interleaved with the ext4 tracepoint logs.  The second is that ext4
has its localized header files in fs/ext4/*.h, and not in
include/linux/*.h, and that was problematic given that the trace code
snippets in include/trace/ext4_event_types.h needed access to some
internal ext4 data structures.  I ultimately solved the latter by
creating a include/linux/ext4_tracing_types.h, but I suspect this
problem will go away when you have modular new-style tracepoints ---
if not, I'd appreciately greatly if folks could consider whether or
not this support could be added.

I'll attach the patches as replies to this mail thread so you can see
what I've done.  Any comments of anything I might have done "wrong"
would be greatly appreciated.

						- Ted
