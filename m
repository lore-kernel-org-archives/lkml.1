Return-Path: <linux-kernel-owner+w=401wt.eu-S1760590AbXFQVTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760590AbXFQVTb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 17:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753557AbXFQVTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 17:19:25 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:49811 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbXFQVTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 17:19:24 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4675A530.6030002@s5r6.in-berlin.de>
Date: Sun, 17 Jun 2007 23:18:40 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070609 SeaMonkey/1.1.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: bugme-daemon@bugzilla.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: Re: [Bug 8646] New: fw-ohci and ohci1394: panic in softirq, below
 smp_apic_timer_interrupt
References: <bug-8646-4803@http.bugzilla.kernel.org/>
In-Reply-To: <bug-8646-4803@http.bugzilla.kernel.org/>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

For the lists:

bugme-daemon@bugzilla.kernel.org wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=8646
> 
>            Summary: fw-ohci and ohci1394: panic in softirq, below
>                     smp_apic_timer_interrupt
>            Product: Drivers
>            Version: 2.5
>      KernelVersion: all
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: high
>           Priority: P1
>          Component: IEEE1394
>         AssignedTo: drivers_ieee1394@kernel-bugs.osdl.org
>         ReportedBy: stefan-r-bz@s5r6.in-berlin.de
> 
> 
> Most recent kernel where this bug did not occur: unknown
> Hardware Environment: SMP i586 and SMP x86-64
> Software Environment: Linux 2.6.x
> 
> If an SBP-2 device is attached and sbp2 or firewire-sbp2 is loaded, any of the
> following commands
> 
> # modprobe -r sbp2 && modprobe -r ohci1394
> # modprobe -r firewire-ohci
> # modprobe -r firewire-sbp2 firewire-ohci
> # modprobe -r firewire-sbp2 && sleep 0 && modprobe -r firewire-ohci
> 
> will lead to a panic with a trace similar to this:
> general protection fault [...]
> Pid: 0, comm: swapper [...]
> run_timer_softirq
> __do_softirq
> call_softirq
> do_softirq
> irq_exit
> smp_apic_timer_interrupt
> mwait_idle
> apic_timer_interrupt
> [...]
> 
> This happened on two different i945GM based boards with Core 2 Duo, 32-bit and
> 64-bit kernels.  The last time I tried this with ohci1394/sbp2 is a while ago. 
> I just saw it now happening in the new drivers too.
> 
> The same trace also happened on an older kernel repeatedly in a totally
> different context, without FireWire drivers loaded:  It could be triggered by
> "make -j" in the kernel source tree, i.e. by a spawning something with many
> subthreads.  I don't have a spare machine with enough RAM available to test
> this again with a recent kernel, for now.  I will try to make the machine where
> I saw it available again.
> 
> I.e. the bug may be entirely outside the old and new FireWire drivers.
> 
> *Not* affected are:
>   - The same machines with
>     "modprobe -r firewire-sbp2 && sleep 0.1 && modprobe -r firewire-ohci",
>   - A VIA KM-266/ AMD-Athlon single-CPU PC, even if running an SMP kernel.


BTW, I didn't give this bug high priority while I knew of this bug in
conjunction with ohci1394, because module removal of ohci1394 is not
possible while sbp2 is logged in into a target since Linux 2.6.17.  But
the new firewire drivers allow it, thus make the bug more visible.


> ------- Comment #1 from stefan-r-bz@s5r6.in-berlin.de  2007-06-17 14:07 -------
> Created an attachment (id=11773)
>  --> (http://bugzilla.kernel.org/attachment.cgi?id=11773&action=view)
> screenshot
> 

-- 
Stefan Richter
-=====-=-=== -==- =---=
http://arcgraph.de/sr/
