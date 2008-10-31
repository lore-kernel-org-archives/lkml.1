Return-Path: <linux-kernel-owner+w=401wt.eu-S1752772AbYJaO4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbYJaO4g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 10:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751267AbYJaO42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 10:56:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:35460 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbYJaO42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 10:56:28 -0400
Date: Fri, 31 Oct 2008 10:56:26 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] ftrace: update txt document
In-Reply-To: <20081026193339.91e0c644.randy.dunlap@oracle.com>
Message-ID: <alpine.DEB.1.10.0810311049090.20157@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0810231921590.4182@gandalf.stny.rr.com> <20081026193339.91e0c644.randy.dunlap@oracle.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I finally got around to looking at the review notes.

On Sun, 26 Oct 2008, Randy Dunlap wrote:
> >  
> >   # sysctl kernel.ftrace_enabled=1
> > - # echo ftrace > /debug/tracing/current_tracer
> > + # echo function > /debug/tracing/current_tracer
> >   # echo 1 > /debug/tracing/tracing_enabled
> >   # usleep 1
> >   # echo 0 > /debug/tracing/tracing_enabled
> >   # cat /debug/tracing/trace
> > -# tracer: ftrace
> > +# tracer: function
> >  #
> >  #           TASK-PID   CPU#    TIMESTAMP  FUNCTION
> >  #              | |      |          |         |
> 
> General comment #2: debugfs is normally mounted at /sys/kernel/debug
> (which Doc/x86/pat.txt, Doc/filesystems/relay.txt,
> Doc/infiniband/ipoib.txt, and Doc/usb/usbmon.txt know about).
> Please either use /sys/kernel/debug or use what Doc/kernel-parameters.txt
> uses: <debugfs> (for the mount point).  I.e., don't use a poor example
> in the doc text.

In the beginning of the document I did have a disclaimer:

------------------------
To mount the debugfs system:

  # mkdir /debug
  # mount -t debugfs nodev /debug

(Note: it is more common to mount at /sys/kernel/debug, but for simplicity
 this document will use /debug)
------------------------

I know the recommended place is /sys/kernel/debug, but I never use it. And 
I know many others that do not either. It is just easier to make the
/debug directory. I feel this is more of a guideline than something
that must be enforced.  But if you do feel strongly on this subject, I
can change it to /sys/kernel/debug (which I absolutely loathe).

The rest of your comments I'm fine with.

-- Steve
