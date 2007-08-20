Return-Path: <linux-kernel-owner+w=401wt.eu-S1758673AbXHTLct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758673AbXHTLct (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 07:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756182AbXHTLck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 07:32:40 -0400
Received: from hu-out-0506.google.com ([72.14.214.232]:25889 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756065AbXHTLcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 07:32:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=I3DHy9QPkOUWZ3U3ozyrFlBEdQ+tWL7VyEhXmqSU8osKnKy2uNrI3GS5MVhZMICyLItyhOgmMh/Iy4GjtIzfx7I2sHHmj2B90WzXrFUTq2Ujd3iotSwFnHSbY0TCqivGIiIJcg0j+TLn4Hky9yqZgI6Y2ltx3oBNRtgW9HfL7mY=
Date: Mon, 20 Aug 2007 15:32:07 +0400
From: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc3-hrt2 stall during boot on ASUS F3T (x86_64)
Message-ID: <20070820153207.278df810@localhost>
In-Reply-To: <1187602270.7007.173.camel@chaos>
References: <20070820104455.0dc7fe3d@localhost>
 <1187592717.6114.170.camel@twins>
 <1187596481.7007.169.camel@chaos>
 <20070820123559.3582f3bc@localhost>
 <1187602270.7007.173.camel@chaos>
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.10.13; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Aug 2007 11:31:10 +0200
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Mon, 2007-08-20 at 12:35 +0400, Mikhail Kshevetskiy wrote:
> > > > >   at 73.442744: I do nothing, the kernel continue to boot after 168 sec
> > > > > 
> > > > >   at 243.497822: After 2 hours i press and hold "shift" button to continue booting 
> > > > > 
> > > > > The dmesg output and my kernel configuration are listed below. 
> > > > > 
> > > > > I test i386 version of the same kernel with very similar configuration, it boot normally.
> > > 
> > > Can you please add "noapictimer" to the kernel command line ?
> >
> > This helps, thank you.
> > Why it is not required for i386 kernel?
> > Is it possible to fix this problem without disabling of apic timer?
> 
> Probably, but we need more information about the breakage. I assume that
> the 64 bit kernel does something different with the power states on idle
> 
> Can you please provide the output of /proc/acpi/processor/CPU0/power for
> both the 32 and the 64 bit kernel ?
> 
> 	tglx
> 
> 


2.6.22.3 (x86_64)
====================================
kl@aspid:~$ cat /proc/acpi/processor/P001/power 
active state:            C0
max_cstate:              C8
bus master activity:     00000000
maximum allowed latency: 8000 usec
states:

2.6.23-rc3-hrt2 (x86_64, noapictimer)
====================================
kl@aspid:~$ cat /proc/acpi/processor/P001/power
active state:            C0
max_cstate:              C8
bus master activity:     00000000
maximum allowed latency: 8000 usec
states:
    C1:                  type[C1] promotion[--] demotion[--] latency[000] usage[00000000] duration[00000000000000000000]

2.6.23-rc3-hrt2 (x86_64)
====================================
kl@aspid:~$ cat /proc/acpi/processor/P001/power
active state:            C0
max_cstate:              C8
bus master activity:     00000000
maximum allowed latency: 8000 usec
states:
    C1:                  type[C1] promotion[--] demotion[--] latency[000] usage[00000000] duration[00000000000000000000]

2.6.22.1 (i386)
====================================
kl@aspid:~$ cat /proc/acpi/processor/P001/power
active state:            C0
max_cstate:              C8
bus master activity:     00000000
maximum allowed latency: 8000 usec
states:

2.6.23-rc3-hrt2 (i386)
====================================
kl@aspid:~$ cat /proc/acpi/processor/P001/power
active state:            C0
max_cstate:              C8
bus master activity:     00000000
maximum allowed latency: 8000 usec
states:
    C1:                  type[C1] promotion[--] demotion[--] latency[000] usage[00000000] duration[00000000000000000000]
