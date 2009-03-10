Return-Path: <linux-kernel-owner+w=401wt.eu-S1754789AbZCJKS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbZCJKS3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 06:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754142AbZCJKSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 06:18:21 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:38177 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754119AbZCJKSU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 06:18:20 -0400
X-BigFish: VPS-36(zz1432R98dR936eQ1805M936fKzzzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KGACM6-01-9G2-01
Date: Tue, 10 Mar 2009 11:18:07 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Mika Tiainen <mikat@iki.fi>
CC: linux-kernel@vger.kernel.org
Subject: Re: Slow clock on AMD 740G chipset
Message-ID: <20090310101807.GD20716@alberich.amd.com>
References: <874ozu2hcl.fsf@divinity.mikat.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <874ozu2hcl.fsf@divinity.mikat.iki.fi>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 10 Mar 2009 10:18:07.0890 (UTC) FILETIME=[81D92720:01C9A169]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2009 at 04:16:10PM +0200, Mika Tiainen wrote:
> 
> Hi,
> 
> I built a new machine with Gigabyte GA-MA74GM-S2H motherboard that ntpd
> can't keep synced. Could this be a kernel bug or is it a hardware
> problem?
> 
> Installed with Debian 2.6.27 kernel and currently running a self built
> 2.6.28.1, both have the problem. It's falling behind over 2s/15min:
> 
> Jan 19 22:08:23 aeon ntpd[31468]: time reset +2.226349 s
> Jan 19 22:24:11 aeon ntpd[31468]: time reset +2.185085 s
> Jan 19 22:40:08 aeon ntpd[31468]: time reset +2.308958 s
> Jan 19 22:56:23 aeon ntpd[31468]: time reset +2.253836 s
> Jan 19 23:13:03 aeon ntpd[31468]: time reset +2.291917 s
> Jan 19 23:28:14 aeon ntpd[31468]: time reset +2.091014 s
> Jan 19 23:43:47 aeon ntpd[31468]: time reset +2.209660 s
> Jan 19 23:59:09 aeon ntpd[31468]: time reset +2.150145 s
> Jan 20 00:15:44 aeon ntpd[31468]: time reset +2.256261 s
> Jan 20 00:31:47 aeon ntpd[31468]: time reset +2.253873 s
> 
> I have tried different clocksources. The machine defaults to hpet,
> acpi_pm makes no difference and

Hi, 

That's annoying but I can't really help you with this. Maybe using
adjtimex as described in section 9.1.6 in
http://support.ntp.org/bin/view/Support/KnownHardwareIssues is an
option for you.

> tsc is even slower, seems to be about
> half speed to realtime.

This is due to TSC not being P- or C- state invariant.  I.e. TSC
frequency changes when processor P-state (frequency) or C-state
(e.g. C2, C3 or C1E) changes. On AMD K8 TSC is not a reliable
clocksource. (This has changed with AMD family 10h CPUs).

> When i set current_clocksource to jiffies the
> clock stopped completely and I had to reboot.

That's odd. I tried it on a test machine - it didn't hang but time
doesn't change anymore and I can't even modify the clocksource
afterwards.

So obviously there is a kernel bug when jiffies are used for
clocksource.


Regards,

Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


