Return-Path: <linux-kernel-owner+w=401wt.eu-S1759356AbXI0V3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759356AbXI0V3g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 17:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755513AbXI0V32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 17:29:28 -0400
Received: from rtr.ca ([76.10.145.34]:4674 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755433AbXI0V32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 17:29:28 -0400
Message-ID: <46FC20B7.4000606@rtr.ca>
Date: Thu, 27 Sep 2007 17:29:27 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>, simon.derr@bull.net,
       len.brown@intel.com
Subject: Problems with SMP & ACPI powering off
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Question:  do we disable all CPUs except 0 when doing ACPI power off?

Background:
I have a machine here dedicated to running MythTV.
It powers up to record, and then sets the RTC alarm for next time
and powers down again in between recordings.

It has an Intel Core2duo E6300 CPU, currently on an ICH8 motherboard.
Previously it was on a completely different (vendor,bios,...) ICH7 motherboard.

In both cases, "halt -p" sometimes fails to actually turn off the power,
which means that it later then fails to "turn on" to record again.

Annoying.

This is a 32-bit kernel/runtime, with full ACPI (not APM) kernel support enabled.

So I'm wondering if it may be due to the old SMP-poweroff bogeyman ?

For now, I've hardcoded a cpu_down(1) into the poweroff code,
and we'll see if that helps or is merely redundant.

But I do wonder where else to look for a cause?

Two different boards, vendors, BIOSs, same CPU chip.  Same problem.

????
