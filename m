Return-Path: <linux-kernel-owner+w=401wt.eu-S1754444AbZLKGtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444AbZLKGtT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 01:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbZLKGtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 01:49:14 -0500
Received: from vms173015pub.verizon.net ([206.46.173.15]:50749 "EHLO
	vms173015pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368AbZLKGtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 01:49:14 -0500
Date: Fri, 11 Dec 2009 01:49:07 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Christoph Hellwig <hch@lst.de>
Cc: Thomas Renninger <trenn@suse.de>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Zhang Rui <rui.zhang@intel.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: regression: 2.6.32-rc8 shuts down after reaching critical
 temperature
In-reply-to: <20091202153536.GA20324@lst.de>
Message-id: <alpine.LFD.2.00.0912110136310.6502@localhost.localdomain>
References: <20091125102857.GA28310@lst.de> <200912021256.21683.trenn@suse.de>
 <20091202133032.GA9265@lst.de> <200912021607.53237.trenn@suse.de>
 <20091202153536.GA20324@lst.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Dec 2009, Christoph Hellwig wrote:

> On Wed, Dec 02, 2009 at 04:07:52PM +0100, Thomas Renninger wrote:
> > Some more hints you may want to try:
> > 
> >   - Does cpufreq work at all?
> >     Does this dir exist: /sys/devices/system/cpu/cpu*/cpufreq
> 
> Yes.
> 
> >     If temp of:
> >     watch -n1 cat /proc/acpi/thermal_zone/THM1/temperature
> >     goes beyond 96 C
> >     an ACPI processor event must get thrown and this:
> >     /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq
> >     will get limited (lower than ../cpufreq/cpuinfo_max_freq).
> 
> The speeds change quite constantly under a kernel compile workload, but
> most of the time it's at 2240800 vs cpuinfo_max_freq which is 2801000
> 
> >     echo xy >/sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq
> >     may be bad workaround.
> 
> echo 2240800 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
> echo 2240800 > /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq
> 
> made it survive a kernel compile for me, with an observed maximum
> temperature of 87 C.

Interesting.  I wonder if the T500 is using P-states for thermal control,
or if it is relying on us to hit passive trip and pull the P-states down.
In either case, the mystery remains what is different after 2.6.31.

Perhaps we can simplify...
Say you run two copies of "# cat /dev/zero > /dev/null" on 2.6.31.
Does the frequency go up to max and stay there forever,
or does it come down?

If it stays there, what do you see for the temperature,
and do you hear the fans?  Presumably the same test
under 2.6.32 will result in a prompt thermal shutdown.

please send the output from 
grep . /sys/devices/system/cpu/cpu*/cpufreq/*

thanks,
-Len Brown, Intel Open Source Technology Center

