Return-Path: <linux-kernel-owner+w=401wt.eu-S1755855AbZCKKFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855AbZCKKFq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 06:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753614AbZCKKFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 06:05:37 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:13855
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753520AbZCKKFg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 06:05:36 -0400
X-BigFish: VPS-36(zz1432R98dR936eQ1805M936fKzzzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KGC6OZ-01-EMQ-01
Date: Wed, 11 Mar 2009 11:05:25 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Mika Tiainen <mikat@iki.fi>
CC: linux-kernel@vger.kernel.org
Subject: Re: Slow clock on AMD 740G chipset
Message-ID: <20090311100525.GE20716@alberich.amd.com>
References: <874ozu2hcl.fsf@divinity.mikat.iki.fi> <20090310101807.GD20716@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090310101807.GD20716@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 11 Mar 2009 10:05:24.0409 (UTC) FILETIME=[E530F290:01C9A230]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 10, 2009 at 11:18:07AM +0100, Andreas Herrmann wrote:
> On Tue, Jan 20, 2009 at 04:16:10PM +0200, Mika Tiainen wrote:
> > 
> > Hi,
> > 
> > I built a new machine with Gigabyte GA-MA74GM-S2H motherboard that ntpd
> > can't keep synced. Could this be a kernel bug or is it a hardware
> > problem?
> > 
> > Installed with Debian 2.6.27 kernel and currently running a self built
> > 2.6.28.1, both have the problem. It's falling behind over 2s/15min:
> > 
> > Jan 19 22:08:23 aeon ntpd[31468]: time reset +2.226349 s
> > Jan 19 22:24:11 aeon ntpd[31468]: time reset +2.185085 s
> > Jan 19 22:40:08 aeon ntpd[31468]: time reset +2.308958 s
> > Jan 19 22:56:23 aeon ntpd[31468]: time reset +2.253836 s
> > Jan 19 23:13:03 aeon ntpd[31468]: time reset +2.291917 s
> > Jan 19 23:28:14 aeon ntpd[31468]: time reset +2.091014 s
> > Jan 19 23:43:47 aeon ntpd[31468]: time reset +2.209660 s
> > Jan 19 23:59:09 aeon ntpd[31468]: time reset +2.150145 s
> > Jan 20 00:15:44 aeon ntpd[31468]: time reset +2.256261 s
> > Jan 20 00:31:47 aeon ntpd[31468]: time reset +2.253873 s
> > 
> > I have tried different clocksources. The machine defaults to hpet,
> > acpi_pm makes no difference and

> That's annoying but I can't really help you with this. Maybe using
> adjtimex as described in section 9.1.6 in
> http://support.ntp.org/bin/view/Support/KnownHardwareIssues is an
> option for you.

BTW, I've played little bit with the adjtimex tool. Verifying the
tick value (with adjtimex --tick) is most probable the solution
for your. Manual calibration is described here
http://support.ntp.org/bin/view/Support/ManualCalibration

Adapting the tick value I managed that time on my test system fell
behind ntp-time by 20 seconds within some minutes. And the other way
round it worked, too.

So it's "mere a question" of calibration on your system. AFAIK
you have to increase the tick value to not fall behind ntp-time, e.g.
increasing tick value from 10000 to 10025

# adjtimex --tick 10025


Regards,
Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


