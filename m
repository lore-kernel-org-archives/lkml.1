Return-Path: <linux-kernel-owner+w=401wt.eu-S1756894AbXJ3RtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894AbXJ3RtR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 13:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753115AbXJ3RtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 13:49:07 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:40239 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752300AbXJ3RtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 13:49:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAC4LJ0dMQWvU/2dsb2JhbACBWg
Date: Tue, 30 Oct 2007 13:49:02 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org,
       "systemtap@sourceware.org" <systemtap@sourceware.org>
Subject: kallsyms __print_symbol prints first weak symbol encountered
Message-ID: <20071030174902.GA6513@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:42:44 up 92 days, 18:01,  5 users,  load average: 1.59, 1.20, 0.85
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am try to see how I can use kallsyms to get the mapping syscall id ->
syscall name by listing all the symbols corresponding to the function
pointers present in the sys_call_table.

However, I just ran into what I consider an unusual behavior of kallsyms:
when I list the sys_ni() (not implemented system calls), I get
compat_sys_futex instead.

If I look at System.map, it's explained by this:

c0146630 W compat_sys_futex
c0146630 W compat_sys_get_mempolicy
c0146630 W compat_sys_get_robust_list
c0146630 W compat_sys_ipc
c0146630 W compat_sys_kexec_load
c0146630 W compat_sys_keyctl
...
c0146630 T sys_ni_syscall
...
c0146630 W sys_timerfd

kallsyms returns the first symbol encountered, even though it is weak,
when it should in fact return sys_ni_syscall.

Is it a concern for anyone else out there ? Would it make sense to fix
it ?

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
