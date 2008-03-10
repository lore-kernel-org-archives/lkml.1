Return-Path: <linux-kernel-owner+w=401wt.eu-S1756383AbYCJUQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383AbYCJUQr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 16:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756708AbYCJUOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 16:14:22 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:58192 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756092AbYCJUOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 16:14:19 -0400
Date: Mon, 10 Mar 2008 13:13:11 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 4/5] debugobjects: add documentation
Message-Id: <20080310131311.23e02eec.randy.dunlap@oracle.com>
In-Reply-To: <20080305155117.567966119@linutronix.de>
References: <20080305154829.185609547@linutronix.de>
	<20080305155117.567966119@linutronix.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
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

On Wed, 05 Mar 2008 16:04:02 -0000 Thomas Gleixner wrote:

> Add a DocBook for debugobjects.

Thanks!

> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Acked-by: Ingo Molnar <mingo@elte.hu>
> ---
>  Documentation/DocBook/Makefile          |    3 
>  Documentation/DocBook/debugobjects.tmpl |  354 ++++++++++++++++++++++++++++++++
>  2 files changed, 356 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/Documentation/DocBook/debugobjects.tmpl
> ===================================================================
> --- /dev/null
> +++ linux-2.6/Documentation/DocBook/debugobjects.tmpl
> @@ -0,0 +1,354 @@
> +<?xml version="1.0" encoding="UTF-8"?>
> +<!DOCTYPE book PUBLIC "-//OASIS//DTD DocBook XML V4.1.2//EN"
> +	"http://www.oasis-open.org/docbook/xml/4.1.2/docbookx.dtd" []>
> +
> +<book id="debog-objects-guide">

             debug-

> + <bookinfo>
> +  <title>Debug objects life time</title>
> +
> +  <authorgroup>
> +   <author>
> +    <firstname>Thomas</firstname>
> +    <surname>Gleixner</surname>
> +    <affiliation>
> +     <address>
> +      <email>tglx@linutronix.de</email>
> +     </address>
> +    </affiliation>
> +   </author>
> +  </authorgroup>
...
> +
> +  <chapter id="intro">
> +    <title>Introduction</title>
> +    <para>
> +      debugobjects is a generic infrastructure to track the life time
> +      of kernel objects and validate the operation on those.

                                            operations

> +    </para>
> +    <para>
> +      debugobjects is useful to check for the following error patterns:
> +	<itemizedlist>
> +	  <listitem><para>Activtation of uninitialized objects</para></listitem>

                          Activation

> +	  <listitem><para>Initialization of active objects</para></listitem>
> +	  <listitem><para>Usage of freed/destroyed objects</para></listitem>
> +	</itemizedlist>
> +    </para>
> +    <para>
> +      debugobjects is not changing the data structure of the real

         debugobjects does not change the data ...

> +      object so it can be compiled in with a minimal runtime impact
> +      and enabled on demand with a kernel command line option.
> +    </para>
> +  </chapter>
> +
> +  <chapter id="howto">
> +    <title>Howto use debugobjects</title>
> +    <para>
> +      A kernel subsystem needs to provide a data structure which
> +      describes the object type and add calls into the debug code at
> +      appropriate places. The data structure to describe the object
> +      type needs at minimum the name of the object type. Optional
> +      functions can and should be provided to fixup detected problems
> +      so the kernel can continue to work and the debug information can
> +      be retrieved from a alive system instead of hard core debugging

                             live

> +      with serial consoles and stack trace transscripts from the

                                              transcripts

> +      monitor.
> +    </para>
> +    <para>
> +      The debug calls provided by debugobjects are:
> +      <itemizedlist>
> +	<listitem><para>debug_object_init</para></listitem>
> +	<listitem><para>debug_object_activate</para></listitem>
> +	<listitem><para>debug_object_deactivate</para></listitem>
> +	<listitem><para>debug_object_destroy</para></listitem>
> +	<listitem><para>debug_object_free</para></listitem>
> +      </itemizedlist>
> +      Each of these functions takes the address of the real object and
> +      a pointer to the object type specific debug description
> +      structure.
> +    </para>
> +    <para>
> +      Each detected error is reported in the statistics and a limited
> +      number of errors is printk'ed including a full stack trace.

                          are

> +    </para>
> +    <para>
> +      The statistics are available via debugfs/debug_objects/stats.
> +      They provide information about the number of warnings and the
> +      number of successful fixups along with information about the
> +      usage of the internal tracking objects and the state of the
> +      internal tracking objects pool.
> +    </para>
> +  </chapter>
> +  <chapter id="debugfunctions">
> +    <title>Debug functions</title>
> +    <sect1 id="prototypes">
> +      <title>Debug object function reference</title>
> +!Elib/debugobjects.c
> +    </sect1>
> +    <sect1 id="debug_object_init">
> +      <title>debug_object_init</title>
> +      <para>
> +	This function is called whenever the initialization function
> +	of a real object is called.
> +      </para>
> +      <para>
> +	When the real object is already tracked by debugobjects it is
> +	checked, whether the object can be initialized.  Initializing
> +	is not allowed for active and destroyed objects. When
> +	debugobjects detects an error, then it calls the fixup_init
> +	function of the object type description structure if provided
> +	by the caller. The fixup function can correct the problem
> +	before the real initialization of the object happens. E.g. it
> +	can deactivate an active object in order to prevent damage to
> +	the subsystem.
> +      </para>
> +      <para>
> +	When the real object is not yet tracked by debugobjects

End above line with comma.

> +	debugobjects allocates a tracker object for the real object
> +	and sets the tracker object state to ODEBUG_STATE_INIT.
> +      </para>
> +    </sect1>
> +
> +    <sect1 id="debug_object_activate">
> +      <title>debug_object_activate</title>
> +      <para>
> +	This function is called whenever the activation function of a
> +	real object is called.
> +      </para>
> +      <para>
> +	When the real object is already tracked by debugobjects it is
> +	checked, whether the object can be activated.  Activating is
> +	not allowed for active and destroyed objects. When
> +	debugobjects detects an error, then it calls the
> +	fixup_activate function of the object type description
> +	structure if provided by the caller. The fixup function can
> +	correct the problem before the real activation of the object
> +	happens. E.g. it can deactivate an active object in order to
> +	prevent damage to the subsystem.
> +      </para>
> +      <para>
> +	When the real object is not yet tracked by debugobjects then
> +	the fixup_activate function is called if available.  This is
> +	necessary to allow the legit activation of statically

                               legitimate

> +	allocated and initialized objects. The fixup function checks
> +	whether the object is valid and calls the debug_objects_init()
> +	function to initialize the tracking of this object.
> +      </para>
> +      <para>
> +	When the activation is legit, then the state of the associated

                               legitimate,

> +	tracker object is set to ODEBUG_STATE_ACTIVE.
> +      </para>
> +    </sect1>
> +
> +    <sect1 id="debug_object_deactivate">
> +      <title>debug_object_deactivate</title>
> +      <para>
> +	This function is called whenever the deactivation function of
> +	a real object is called.
> +      </para>
> +      <para>
> +	When the real object is tracked by debugobjects it is checked,
> +	whether the object can be deactivated. Deactivating is not
> +	allowed for untracked or destroyed objects.
> +      </para>
> +      <para>
> +	When the deactivation is legit, then the state of the

                                 legitimate,

> +	associated tracker object is set to ODEBUG_STATE_INACTIVE.
> +      </para>
> +    </sect1>
> +
> +    <sect1 id="debug_object_destroy">
> +      <title>debug_object_destroy</title>
> +      <para>
> +	This function is called to mark an object destroyed. This is
> +	useful to prevent the usage of invalid objects, which are
> +	still available in memory: either statically allocated objects
> +	or objects which are freed later.
> +      </para>
> +      <para>
> +	When the real object is tracked by debugobjects it is checked,
> +	whether the object can be destroyed. Destruction is not
> +	allowed for active and destroyed objects. When debugobjects
> +	detects an error, then it calls the fixup_destroy function of
> +	the object type description structure if provided by the
> +	caller. The fixup function can correct the problem before the
> +	real destruction of the object happens. E.g. it can deactivate
> +	an active object in order to prevent damage to the subsystem.
> +      </para>
> +      <para>
> +	When the destruction is legit, then the state of the

                                legitimate,

> +	associated tracker object is set to ODEBUG_STATE_DESTROYED.
> +      </para>
> +    </sect1>
> +
> +    <sect1 id="debug_object_free">
> +      <title>debug_object_free</title>
> +      <para>
> +	This function is called before an object is freed.
> +      </para>
> +      <para>
> +	When the real object is tracked by debugobjects it is checked,
> +	whether the object can be freed. Free is not allowed for
> +	active objects. When debugobjects detects an error, then it
> +	calls the fixup_free function of the object type description
> +	structure if provided by the caller. The fixup function can
> +	correct the problem before the real free of the object
> +	happens. E.g. it can deactivate an active object in order to
> +	prevent damage to the subsystem.
> +      </para>
> +      <para>
> +	Note that debug_object_free removes the object from the
> +	tracker. Later usage of the object is detected by the other
> +	debug checks.
> +      </para>
> +    </sect1>
> +  </chapter>
> +  <chapter id="fixupfunctions">
> +    <title>Fixup functions</title>
> +    <sect1 id="debug_obj_descr">
> +      <title>Debug object type description structure</title>
> +!Iinclude/linux/debugobjects.h
> +    </sect1>
> +    <sect1 id="fixup_init">
> +      <title>fixup_init</title>
> +      <para>
> +	This function is called from the debug code whenever a problem
> +	in debug_object_init is detected. The function takes the
> +	address of the object and the state which is currently
> +	recorded in the tracker.
> +      </para>
> +      <para>
> +	Called from debug_object_init when the object state is:
> +	<itemizedlist>
> +	  <listitem><para>ODEBUG_STATE_ACTIVE</para></listitem>
> +	</itemizedlist>
> +      </para>
> +      <para>
> +	The function returns "1" then the fixup was successful,
> +	otherwise "0". The return value is used to update the
> +	statistics.

We usually don't quote numbers unless they are strings (instead of
numbers).

> +      </para>
> +      <para>
> +	Note, that the function needs to call the debug_object_init()

Drop comma.

> +	function again, after the damage has been repaired in order to

Ditto.

> +	keep the state consistent.
> +      </para>
> +    </sect1>
> +
> +    <sect1 id="fixup_activate">
> +      <title>fixup_activate</title>
> +      <para>
> +	This function is called from the debug code whenever a problem
> +	in debug_object_activate is detected.
> +      </para>
> +      <para>
> +	Called from debug_object_activate when the object state is:
> +	<itemizedlist>
> +	  <listitem><para>ODEBUG_STATE_NOTAVAILABLE</para></listitem>
> +	  <listitem><para>ODEBUG_STATE_ACTIVE</para></listitem>
> +	</itemizedlist>
> +      </para>
> +      <para>
> +	The function returns "1" then the fixup was successful,
> +	otherwise "0". The return value is used to update the
> +	statistics.

1 or 0

> +      </para>
> +      <para>
> +	Note, that the function needs to call the debug_object_activate()

Drop comma.

> +	function again, after the damage has been repaired in order to

Ditto.

> +	keep the state consistent.
> +      </para>
> +      <para>
> +	The activation of statically initialized objects is a special
> +	case. When debug_object_activate() has no tracked object for
> +	this object address then fixup_activate() is called with
> +	object state ODEBUG_STATE_NOTAVAILABLE. The fixup function
> +	needs to check whether this is a legit case of a statically

                                         legitimate

> +	initialized object or not. In case it is it calls
> +	debug_object_init() and debug_object_activate() to make the
> +	object known to the tracker and marked active. In this case
> +	the function should return "0" because this is not a real

0

> +	fixup.
> +      </para>
> +    </sect1>
> +
> +    <sect1 id="fixup_destroy">
> +      <title>fixup_destroy</title>
> +      <para>
> +	This function is called from the debug code whenever a problem
> +	in debug_object_destroy is detected.
> +      </para>
> +      <para>
> +	Called from debug_object_destroy when the object state is:
> +	<itemizedlist>
> +	  <listitem><para>ODEBUG_STATE_ACTIVE</para></listitem>
> +	</itemizedlist>
> +      </para>
> +      <para>
> +	The function returns "1" then the fixup was successful,
> +	otherwise "0". The return value is used to update the

1 or 0

> +	statistics.
> +      </para>
> +    </sect1>
> +    <sect1 id="fixup_free">
> +      <title>fixup_free</title>
> +      <para>
> +	This function is called from the debug code whenever a problem
> +	in debug_object_free is detected. Further it can be called
> +	from the debug checks in k/v free, when an active object is

                                 kfree/vfree ?

> +	detected from the debug_check_no_obj_freed() sanity checks.
> +      </para>
> +      <para>
> +	Called from debug_object_free() or debug_check_no_obj_freed()
> +	when the object state is:
> +	<itemizedlist>
> +	  <listitem><para>ODEBUG_STATE_ACTIVE</para></listitem>
> +	</itemizedlist>
> +      </para>
> +      <para>
> +	The function returns "1" then the fixup was successful,
> +	otherwise "0". The return value is used to update the

1 or 0

> +	statistics.
> +      </para>
> +    </sect1>
> +  </chapter>
> +  <chapter id="bugs">
> +    <title>Known Bugs And Assumptions</title>
> +    <para>
> +	None (knock on wood).
> +    </para>
> +  </chapter>
> +</book>
> 
> -- 

---
~Randy
