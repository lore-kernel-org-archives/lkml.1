Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090Ab0BOLJt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 06:09:49 -0500
Received: from mailout2.zih.tu-dresden.de ([141.30.67.73]:39667 "EHLO
	mailout2.zih.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752260Ab0BOLJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 06:09:47 -0500
X-Greylist: delayed 1519 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Feb 2010 06:09:47 EST
Subject: Tracing power_end on kernel 2.6.32.8
From: Robert =?ISO-8859-1?Q?Sch=F6ne?= <robert.schoene@tu-dresden.de>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Li Zefan <lizf@cn.fujitsu.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Feb 2010 11:44:15 +0100
Message-ID: <1266230655.4844.14.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-TUD-Virus-Scanned: mailout2.zih.tu-dresden.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I have a question regarding the event "power/power_end".
For the standard linux kernel (2.6.32.8), it's just not reported -
neither for the /sys/kernel/debug/tracing nor for the sys_perf_open
approach.

System:
	Intel Core 2 Quad,
	Kernel 2.6.32.8,
	for sys_perf_open:always using sampling counters,
	(Kernel 2.6.33-rcX should show the same behavior)

After finding "my" c-state procedure in arch/x86/kernel/process.c
(which was "static void mwait_idle(void)" btw), I added a
trace_power_end call on the correct line:
...
		else
			local_irq_enable();
	} else
...
->
...
		else
			local_irq_enable();
		trace_power_end(0);
	} else
...
Now the event was reported on /sys/kernel/debug/tracing, but still not
for sys_perf_open.

Then I had the idea, that trace_power_end's argument should be the same
as the 2nd argument of the previous power_start.

That worked.

However, things to be done are: add trace_power_end's to some
process.c's procedures.


Bye Robert

-- 
Robert Schoene
Technische Universitaet Dresden
Zentrum fuer Informationsdienste und Hochleistungsrechnen
01062 Dresden

Tel.: (0351) 463-42483, Fax: (0351) 463-37773
E-Mail: Robert.Schoene@tu-dresden.de

