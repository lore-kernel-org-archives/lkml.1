Return-Path: <linux-kernel-owner+w=401wt.eu-S1760141AbXEJPvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760141AbXEJPvy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 11:51:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754788AbXEJPvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 11:51:47 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:26616 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172AbXEJPvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 11:51:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uk3YnxpHauQRg5Wkg0Yd3PT6mGkvbCWjBF+HvnMwtatV+O3QBuenVL3GxLcrKayCsR7xU0bRPS+w5jCNaW1yNSfXtGIu6WBIxhycrohkbgU+Umb10WwtSUSRKlA7FTH4UuOFSGIe3XQgb47z9mqKCyDcFulVchUp4jJIpT0ztqI=
Message-ID: <7b69d1470705100851v26e22fedw2b2247c5cae2e783@mail.gmail.com>
Date: Thu, 10 May 2007 10:51:46 -0500
From: "Scott Preece" <sepreece@gmail.com>
To: "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>
Subject: Re: [patch 07/10] Linux Kernel Markers - Documentation
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, hch@infradead.org
In-Reply-To: <20070510020917.172554217@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070510015555.973107048@polymtl.ca>
	 <20070510020917.172554217@polymtl.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is a patch to marker.txt to make the English read a little
better. I didn't change the references to out-of-tree packages.

@@ -3,33 +3,30 @@
                            Mathieu Desnoyers


-       This document introduces to markers and discusses its purpose. It
-shows some usage examples of the Linux Kernel Markers : how to insert markers
-within the kernel and how to connect probes to a marker. Finally, it has some
-probe module examples. This is what connects to a marker.
-
+This document introduces Linux Kernel Markers and their use. It provides
+examples of how to insert markers in the kernel and connect probe functions to
+them and provides some examples of probe functions.

 * Purpose of markers

-A marker placed in your code provides a hook to a function (probe) that
+A marker placed in your code provides a hook to call a function (probe) that
 you can provide at runtime. A marker can be "on" (a probe is connected to it)
-or "off" (no probe is attached). An "off" marker has no effect. When turned on,
-the function you provide is called each time the marker is executed in the
-execution context of the caller. When the function provided ends its execution,
-it returns to the caller (marker site).
+or "off" (no probe is attached). When a marker is "off" it has no
+effect. When a marker is "on", the function you provide is called each
+time the marker is executed, in the execution context of the
+caller. When the function provided ends its execution, it returns to the
+caller (continuing from the marker site).

-You can put markers at important locations in the code. They act as
+You can put markers at important locations in the code. Markers are
 lightweight hooks that can pass an arbitrary number of parameters,
-described in a printk-like format string, to a function whenever the marker
-code is reached.
+described in a printk-like format string, to the attached probe function.

-They can be used for tracing (LTTng, LKET over SystemTAP), overall performance
-accounting (SystemTAP). They could also be used to implement
-efficient hooks for SELinux or any other subsystem that would have this
-kind of need.
+Markers can be used for tracing (LTTng, LKET over SystemTAP), overall
+performance accounting (SystemTAP), or to hook to monitoring
+subsystems (like SELinux) that need to observe kernel behavior.

-Using the markers for system audit (SELinux) would require to pass a
-variable by address that would be later checked by the marked routine.
+Using the markers for system audit (SELinux) would require passing a
+variable by address so that it could be checked by the marked routine.


 * Usage
@@ -52,15 +49,15 @@ Where :
 Connecting a function (probe) to a marker is done by providing a probe
 (function to call) for the specific marker through marker_set_probe(). It will
 automatically connect the function and enable the marker site. Removing a probe
-is done through marker_remove_probe(). Probe removal is preempt safe because
+is done through marker_remove_probe(). Probe removal is preempt-safe because
 preemption is disabled around the probe call. See the "Probe example" section
 below for a sample probe module.

-The marker mechanism supports multiple instances of the same marker.
-Markers can be put in inline functions, inlined static functions and
+The marker mechanism supports inserting multiple instances of the same marker.
+Markers can be put in inline functions, inlined static functions, and
 unrolled loops.

-Note : It is safe to put markers within preempt-safe code : preempt_enable()
+Note: It is safe to put markers within preempt-safe code : preempt_enable()
 will not call the scheduler due to the tests in preempt_schedule().


@@ -68,23 +65,23 @@ will not call the scheduler due to the t

 You will find, in asm-*/marker.h, optimisations for given architectures
 (currently i386 and powerpc). They use a load immediate instead of a data load,
-which saves a data cache hit, but also requires cross CPU code modification. In
-order to support embedded systems which use read-only memory for
their code, the
+which saves a data cache hit, but also requires cross-CPU code modification. In
+order to support embedded systems that use read-only memory for their code, the
 optimization can be disabled through menu options.

 The MF_* flags can be used to control the type of marker. See the
 include/marker.h header for the list of flags. They can be specified as the
-first parameter of the _trace_mark() macro, such as the following example which
+first parameter of the _trace_mark() macro, as in the following example, which
 is safe with respect to lockdep.c (useful for marking lockdep.c and printk
 functions).

 _trace_mark(MF_DEFAULT | ~MF_LOCKDEP, subsystem_eventb, MARK_NOARGS);

-Another example is to specify that a specific marker must never call printk :
+Another example is to specify that a specific marker must never call printk:
 _trace_mark(MF_DEFAULT | ~MF_PRINTK, subsystem_eventc,
   "%d %s", someint, somestring,);

-Flag compatibility is checked before connecting the probe to the marker : the
+Flag compatibility is checked before connecting the probe to the marker: the
 right flags must be given to _marker_set_enable().
