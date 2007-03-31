Return-Path: <linux-kernel-owner+w=401wt.eu-S1945891AbXCaGyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945891AbXCaGyU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 02:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945933AbXCaGyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 02:54:20 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:39981 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945891AbXCaGyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 02:54:19 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Helge Hafting <helgehaf@aitel.hist.no>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc5-mm2 - compile error on x86-64
References: <20070326211627.c681af3b.akpm@linux-foundation.org>
	<20070329182020.GA9223@aitel.hist.no>
	<20070329142816.5d18d89f.akpm@linux-foundation.org>
	<20070331062743.GA26131@aitel.hist.no>
Date: Sat, 31 Mar 2007 00:53:38 -0600
In-Reply-To: <20070331062743.GA26131@aitel.hist.no> (Helge Hafting's message
	of "Sat, 31 Mar 2007 08:27:43 +0200")
Message-ID: <m1r6r5hpjh.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Helge Hafting <helgehaf@aitel.hist.no> writes:

> Correct. I seem to remember that the latter is considered 
> "deprecated, but some programs may still depend on it".  So I disabled it to 
> see what broke.  udev complained about the missing /proc/sys/kernel/hotplug,
> but was happy to use /sys/kernel/uevent_helper instead.  I didn't
> notice other problems, so I left things like that.

Well if anything it is the other way around.  The preferred interface to
sysctls is /proc/sys.  There is the whole thing where people aren't to
happy with non-process related things in /proc, so in that sense there
is a bit of deprecation, but /proc and /proc/sys are fully supported.

The plethora of configuration is what remains when I dug into the binary
sys_sysctl interface and tested the assertion that no one uses it, and
it has been deprecated for years and we could just kill it.

We can now remove the binary sys_sysctl syscall while keeping /proc/sys
support.  Someday I might even get ambitious and add the appropriate
deprecated warnings so we can kill the binary interface.

I got as far as seeing that there were a small handful of real
programs that use sys_sysctl.  I looked at how were giving notice
and realized that was insufficient to tell users we were deprecating
the thing.  I didn't see much point (except being able to immediate
drop support) to removing sys_sysctl and since we would have to go
a couple of years still supporting it to remove it properly I got
lazy and stopped.

Maybe myself or someone else can get ambitious and deprecate
sys_sysctl properly and we can remove it one of these years...

Eric
