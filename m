Return-Path: <linux-kernel-owner+w=401wt.eu-S1753972AbYJCTQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbYJCTQj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 15:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbYJCTQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 15:16:30 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:39188 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752235AbYJCTQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 15:16:30 -0400
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: linux-kernel@vger.kernel.org
Subject: Markers in (non-module) kernel code?
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
Message-Id: <E1Klq8Z-0003Vd-L6@closure.thunk.org>
Date: Fri, 03 Oct 2008 15:16:27 -0400
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've been playing with adding some markers into ext4 to see if they
could be useful in solving some problems along with Systemtap.  It
appears, though, that as of 2.6.27-rc8, markers defined in code which is
compiled directly into the kernel (i.e., not as modules) don't show up
in Module.markers:

kvm_trace_entryexit	arch/x86/kvm/kvm-intel	%u %p %u %u %u %u %u %u
kvm_trace_handler	arch/x86/kvm/kvm-intel	%u %p %u %u %u %u %u %u
kvm_trace_entryexit	arch/x86/kvm/kvm-amd	%u %p %u %u %u %u %u %u
kvm_trace_handler	arch/x86/kvm/kvm-amd	%u %p %u %u %u %u %u %u

(Note the lack of any of the kernel_sched_* markers, and the markers I
added for ext4_* and jbd2_* are missing as wel.)

Systemtap apparently depends on in-kernel trace_mark being recorded in
Module.markers, and apparently it's been claimed that it used to be
there.  Is this a bug in systemtap, or in how Module.markers is getting
built?   And is there a file that contains the equivalent information
for markers located in non-modules code?

Thanks, regards,

						- Ted

