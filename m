Return-Path: <linux-kernel-owner+w=401wt.eu-S1753044AbYITKZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044AbYITKZx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 06:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751191AbYITKZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 06:25:45 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:36549 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751021AbYITKZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 06:25:45 -0400
Message-ID: <48D4CFA5.7010501@suse.de>
Date: Sat, 20 Sep 2008 14:25:41 +0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Sitsofe Wheeler <sitsofe@yahoo.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>, lenb@kernel.org
Subject: Re: Reading EeePC900 battery info causes stalls (was Re: How how
 latent should non-preemptive scheduling be?)
References: <fa.aea4e10hJLpVS/qr4bumSa5e9C0@ifi.uio.no> <fa.uDmoMIWw4thxpZxpYeSIpVJhAOo@ifi.uio.no> <fa.RIMmQqN9ybFSKBqOk9Gxi/mOeB4@ifi.uio.no> <fa.XLGLzP+T4fm9CkeATkS1VL/Yz4Q@ifi.uio.no> <fa.z8sKLpwDO3qQ15ZJIm152YEty4I@ifi.uio.no> <fa.KyW7dWWjiSFnFxwdZZLurmVn8qA@ifi.uio.no> <48D4CC1B.7030708@yahoo.com>
In-Reply-To: <48D4CC1B.7030708@yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sitsofe,

eeePC is known to be affected by EC GPE storm bug, and there is a patch for 
2.6.27 to workaround the problem. please look at
http://bugzilla.kernel.org/show_bug.cgi?id=11549
for latest patch and bugs 10724/9998 for problem discussion.

Thanks,
Alex.

Sitsofe Wheeler wrote:
> Peter Zijlstra wrote:
>> Its actually function tracer output I'm interested in.. that shows what
>> all its doing to make it take 120+ms.
> 
> I switched the tracer to ftrace and waited for the problem to occur.
> When stall did happen it was far worse than usual with the tracing on
> (instead of looping sound of < 0.5 second it looped it for about 2-3
> seconds). Looking atthe trace it was filled with hald events. Killing 
> off all of hald made the 30 second stalls go away.
> 
> A quick strace showed that what hal was doing every 30 seconds was
> reading various battery stats from /sys. Doing a simple
> cat /sys/class/power_supply/BAT0/manufacturer
> is enough to provoke a stall. The stalls only occur if you are on 
> battery or are on AC and the battery is not reporting that it is 100% 
> charged (but in the latter case the stalls are less pronounced).
> 
> I can reliably hear the stalls at runlevel 1 by running
> speaker-test -b75000
> and
> watch --interval=1 cat /proc/acpi/battery/BAT0/info
> within separate terminals within screen.
> 
> A 5 second ftrace of the stall being provoked is provided on 
> <http://sucs.org/~sits/test/eeepc-ftrace.txt.gz> (it's 6Mbytes 
> uncompressed).
> 
> Putting the alsa buffer size up to 100000 allows you to still hear
> stalls but far less frequently. Putting to 150000 will stop you from
> hearing stalls. Even though xruns is set to 2 alsa not report any buffer
> underruns to syslog.
> 
> Another way of seeing the stalls is to run glxgears and every second the
> gears' spinning will jump (even on an unloaded system).
> 
> (I guess this works as the stalls are over 100ms)
> 
> The xandros provided 2.6.21.4 kernel does not exhibit this problem at 
> all but my hand compiled 2.6.24something and ubuntu 2.6.24 kernels do.
> 
> For some reason latencytop did not really finger ACPI as a cause of
> stalls (although some acpi stuff does show up but never in the top
> spot). Is this simply a part of the kernel that latencytop does not trace?
> 
>> I thought we had a wakeup latency tracer exacty like we have preempt and
>> irq off latency tracers, Steve, where'd that go?
> 
> I rebuilt my kernel after a make clean and wakeup was still not there. 
> It might be a good idea to modify the kernel documentation currently
> provided with 2.6.27 if it has gone away for now (or document the extra
> switches needed to turn it on if that's why it didn't show up for me)...
> 
> -- 
> Sitsofe | http://sucs.org/~sits/

