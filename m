Return-Path: <linux-kernel-owner+w=401wt.eu-S1752599AbYJ0Cfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599AbYJ0Cfk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 22:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751369AbYJ0Cfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 22:35:31 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:63798 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720AbYJ0Cf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 22:35:29 -0400
Date: Sun, 26 Oct 2008 19:33:39 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] ftrace: update txt document
Message-Id: <20081026193339.91e0c644.randy.dunlap@oracle.com>
In-Reply-To: <alpine.DEB.1.10.0810231921590.4182@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0810231921590.4182@gandalf.stny.rr.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Oct 2008 19:23:14 -0400 (EDT) Steven Rostedt wrote:

> A lot of changes have gone into ftrace. This patch updates
> the ftrace.txt document.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  Documentation/ftrace.txt |  145 +++++++++++++++++++----------------------------
>  1 file changed, 59 insertions(+), 86 deletions(-)
> 
> Index: linux-tip.git/Documentation/ftrace.txt
> ===================================================================
> --- linux-tip.git.orig/Documentation/ftrace.txt	2008-08-14 13:54:58.000000000 -0400
> +++ linux-tip.git/Documentation/ftrace.txt	2008-10-23 19:20:30.000000000 -0400
> @@ -94,23 +94,19 @@ of ftrace. Here is a list of some of the
>  		only be recorded if the latency is greater than
>  		the value in this file. (in microseconds)
>  
> -  trace_entries : This sets or displays the number of trace
> -		entries each CPU buffer can hold. The tracer buffers
> -		are the same size for each CPU. The displayed number
> -		is the size of the CPU buffer and not total size. The

General comment #1:  Don't use a space before the ':'.
(multiple places)

> +  trace_entries : This sets or displays the number of bytes each CPU
> +		buffer can hold. The tracer buffers are the same size
> +		for each CPU. The displayed number is the size of the
> +		 CPU buffer and not total size of all buffers. The
>  		trace buffers are allocated in pages (blocks of memory
>  		that the kernel uses for allocation, usually 4 KB in size).
> -		Since each entry is smaller than a page, if the last
> -		allocated page has room for more entries than were
> -		requested, the rest of the page is used to allocate
> -		entries.
> +		If the last page allocated has room for more bytes
> +		than requested, the rest of the page is used to allocate.

awkward.  to allocate what?  Maybe "is used for allocation(s)."

> +		(Note, the size may not be a multiple of the page size due
> +		to buffer managment overhead).

		                    overhead.)

>  
>  		This can only be updated when the current_tracer
> -		is set to "none".
> -
> -		NOTE: It is planned on changing the allocated buffers
> -		      from being the number of possible CPUS to
> -		      the number of online CPUS.
> +		is set to "nop".
>  
>    tracing_cpumask : This is a mask that lets the user only trace
>  		on specified CPUS. The format is a hex string
> @@ -130,13 +126,10 @@ of ftrace. Here is a list of some of the
>  		be traced. If a function exists in both set_ftrace_filter
>  		and set_ftrace_notrace,	the function will _not_ be traced.
>  
> -  available_filter_functions : When a function is encountered the first
> -		time by the dynamic tracer, it is recorded and
> -		later the call is converted into a nop. This file
> -		lists the functions that have been recorded
> -		by the dynamic tracer and these functions can
> -		be used to set the ftrace filter by the above
> -		"set_ftrace_filter" file. (See the section "dynamic ftrace"
> +  available_filter_functions : This lists the functions that ftrace
> +		has processed and can trace. These are the function
> +		names that you can pass to "set_ftrace_filter" or
> +		"set_ftrace_notrace". (See the section "dynamic ftrace"
>  		below for more details).

		               details.)

>  
>  
...
> @@ -1000,22 +993,20 @@ is the stack for the hard interrupt. Thi
>  has been set. We do not see the 'N' until we switch back to the task's
>  assigned stack.
>  
> -ftrace
> -------
> +function
> +--------
>  
> -ftrace is not only the name of the tracing infrastructure, but it
> -is also a name of one of the tracers. The tracer is the function
> -tracer. Enabling the function tracer can be done from the
> -debug file system. Make sure the ftrace_enabled is set otherwise
> -this tracer is a nop.
> +This tracer is the function tracer. Enabling the function tracer
> +can be done from the debug file system. Make sure the ftrace_enabled is
> +set otherwise this tracer is a nop.

   set;

>  
>   # sysctl kernel.ftrace_enabled=1
> - # echo ftrace > /debug/tracing/current_tracer
> + # echo function > /debug/tracing/current_tracer
>   # echo 1 > /debug/tracing/tracing_enabled
>   # usleep 1
>   # echo 0 > /debug/tracing/tracing_enabled
>   # cat /debug/tracing/trace
> -# tracer: ftrace
> +# tracer: function
>  #
>  #           TASK-PID   CPU#    TIMESTAMP  FUNCTION
>  #              | |      |          |         |

General comment #2: debugfs is normally mounted at /sys/kernel/debug
(which Doc/x86/pat.txt, Doc/filesystems/relay.txt,
Doc/infiniband/ipoib.txt, and Doc/usb/usbmon.txt know about).
Please either use /sys/kernel/debug or use what Doc/kernel-parameters.txt
uses: <debugfs> (for the mount point).  I.e., don't use a poor example
in the doc text.

...
> @@ -1074,18 +1065,30 @@ every kernel function, produced by the -
>  of pointing to a simple return. (Enabling FTRACE will include the
>  -pg switch in the compiling of the kernel.)
>  
> -When dynamic ftrace is initialized, it calls kstop_machine to make
> -the machine act like a uniprocessor so that it can freely modify code
> -without worrying about other processors executing that same code.  At
> -initialization, the mcount calls are changed to call a "record_ip"
> -function.  After this, the first time a kernel function is called,
> -it has the calling address saved in a hash table.
> -
> -Later on the ftraced kernel thread is awoken and will again call
> -kstop_machine if new functions have been recorded. The ftraced thread
> -will change all calls to mcount to "nop".  Just calling mcount
> -and having mcount return has shown a 10% overhead. By converting
> -it to a nop, there is no measurable overhead to the system.
> +At compile time every C file object is run through the
> +recordmcount.pl script (located in the scripts directory). This
> +script will process the C object using objdump to find all the
> +locations in the .text section that call mcount. (Note, only
> +the .text section is processed, since processing other sections
> +like .init.text may cause races due to those sections being freed).
> +
> +A new section called "__mcount_loc" is created that holds references
> +to all the mcount call sites in the .text section. This section is
> +compiled back into the original object. The final linker will add
> +all these references into a single table.
> +
> +On boot up, before SMP is initialized, the dynamic ftrace code
> +scans this table and updates all the locations into nops. It also
> +records the locations, which are added to the available_filter_functions
> +list.  Modules are processed as they are loaded and before they are
> +executed.  They also remove their functions from the list when they

             "They" being modules?  They remove their own functions?
   or dynamic ftrace removes module functions .... ?

> +are removed.
> +
> +When tracing is enabled, kstop_machine is called to prevent races
> +with the CPUS executing code being modified (which can cause the
> +CPU to do undesireable things), and the nops are patched back
> +to calls. But this time, they do not call mcount (which is just
> +a function stub). They now call into the ftrace infrastructure.
>  
>  One special side-effect to the recording of the functions being
>  traced is that we can now selectively choose which functions we
...
> @@ -1286,14 +1259,14 @@ on the tracing is different. Every read 
>  This means that subsequent reads will be different. The trace
>  is live.
>  
> - # echo ftrace > /debug/tracing/current_tracer
> + # echo function > /debug/tracing/current_tracer
>   # cat /debug/tracing/trace_pipe > /tmp/trace.out &
>  [1] 4153
>   # echo 1 > /debug/tracing/tracing_enabled
>   # usleep 1
>   # echo 0 > /debug/tracing/tracing_enabled
>   # cat /debug/tracing/trace
> -# tracer: ftrace
> +# tracer: function
>  #
>  #           TASK-PID   CPU#    TIMESTAMP  FUNCTION
>  #              | |      |          |         |
> @@ -1314,7 +1287,7 @@ is live.
>  
>  Note, reading the trace_pipe file will block until more input is added.
>  By changing the tracer, trace_pipe will issue an EOF. We needed
> -to set the ftrace tracer _before_ cating the trace_pipe file.
> +to set the function tracer _before_ cating the trace_pipe file.

                                      "cat"-ing (or some such annotation)

>  
>  
>  trace entries

---
~Randy
