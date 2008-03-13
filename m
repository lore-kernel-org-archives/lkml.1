Return-Path: <linux-kernel-owner+w=401wt.eu-S1754321AbYCMQfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321AbYCMQfN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 12:35:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752078AbYCMQfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 12:35:00 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:49006 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952AbYCMQe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 12:34:59 -0400
Date: Thu, 13 Mar 2008 17:34:37 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Len Brown <lenb@kernel.org>
Cc: linux-pm@lists.linux-foundation.org, Pavel Machek <pavel@ucw.cz>,
       LKML <linux-kernel@vger.kernel.org>, Adam Belay <abelay@novell.com>,
       Andi Kleen <andi@firstfloor.org>, Lee Revell <rlrevell@joe-job.com>
Subject: Re: [linux-pm] [PATCH] cpuidle: avoid singing capacitors
Message-ID: <20080313173437.5f00f70e@mjolnir.drzeus.cx>
In-Reply-To: <200803121511.17389.lenb@kernel.org>
References: <Pine.LNX.4.44L0.0803031804330.8280-100000@iolanthe.rowland.org>
	<20080310100008.GA9520@elf.ucw.cz>
	<20080310134915.45ae7446@mjolnir.drzeus.cx>
	<200803121511.17389.lenb@kernel.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2008 15:11:17 -0400
Len Brown <lenb@kernel.org> wrote:

> > I guess the only way to find out is to disassemble the DSDT. Exposing myself to such concentrations of ACPI is not an appealing project. :/
> 
> the latest cpuidle code actually publishes the details of the C-states being used.
>  
> $ pwd
> /sys/devices/system/cpu/cpu0/cpuidle/state3
> $ grep . *
> desc:ACPI FFH INTEL MWAIT 0x20
> latency:17
> name:C3
> power:250
> time:1862590932
> usage:9028970
> 
> You'll see "desc" change if ACPI pulls a _CST change on you.
> 

It does not. But my C3 desc looks like this:

state3/desc:ACPI FFH INTEL MWAIT 0x50

What's the meaning of the last number?

I also have different latency and power:

state3/latency:162
state3/power:100

> > Disabling the second core makes the noise go away. This might be a subset of 1., as I've been told that a stopped core enters C1.
> 
> if you disable it at run-time, Linux puts it in C1.
> If you never boot it in the first place (eg. maxcpusp=1), the BIOS leaves it in the deepest available C-sate.
> 

Ah. Didn't know that. I've confirmed this as the noise is there when booting with maxcpus.

> > 
> > So for now, the only viable workaround is processor.max_cstate....
> 
> yup, that's why we put it in.  Is it insufficient?
> 

For some value of insufficient. It is sub-optimal. I'm hoping there is a way to enter C3 in a pattern that avoids the noise and still gives a reduced power usage.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
