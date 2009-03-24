Return-Path: <linux-kernel-owner+w=401wt.eu-S1763875AbZCXR2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763875AbZCXR2z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 13:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761942AbZCXR2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 13:28:35 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:45168 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755426AbZCXR2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 13:28:31 -0400
Message-ID: <49C919B9.70302@msgid.tls.msk.ru>
Date: Tue, 24 Mar 2009 20:34:49 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Mika Tiainen <mikat@iki.fi>
CC: Andreas Herrmann <andreas.herrmann3@amd.com>, linux-kernel@vger.kernel.org
Subject: Re: Slow clock on AMD 740G chipset
References: <874ozu2hcl.fsf@divinity.mikat.iki.fi>	<20090310101807.GD20716@alberich.amd.com>	<20090311100525.GE20716@alberich.amd.com>	<49B7A79A.6090008@msgid.tls.msk.ru> <87ocw8qfwg.fsf@divinity.mikat.iki.fi>
In-Reply-To: <87ocw8qfwg.fsf@divinity.mikat.iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[resurrecting (hopefully) an old thread.
  Top-posting to keep old mess around for reference.]

To refresh what has been said.  Several people observed slow clock
on their - mostly AMD 780g, 740g and 690g-based systems with 2.6.28
2.6.27 kernels.  Slow to a point when ntpd wasn't successful to
keep up with the drift.  It has been said that the motherboards are
flaky or something and that the clocks has to be calibrated, for
which there are known procedures available (adjtimex).  Which helped.
Before the "calibration" the clock were off by ~15 minutes per day.

But today I tried newly released 2.6.29 kernel on one of the affected
systems - just because I wanted to test something else.  And noticed
that the clock is running too fast.  After some calculation I see that
it will run away for about 15 minutes per day, that is, exactly the
number which was used to compensate for slow clock on 2.6.2[78].

So it seems that with 2.6.29, all the motherboards suddenly become
non-flaky and the timers need no calibration anymore, working just
fine.  Other operating systems and kernel versions also agree with
this conclusion of 2.6.29.

Any comments on this strange phenomenon ? :)

Thanks!

/mjt

Mika Tiainen wrote at Wed, 11 Mar 2009 16:43:11 +0200:
> On 11 Mar 2009, Michael Tokarev wrote:
> 
>>> On Tue, Mar 10, 2009 at 11:18:07AM +0100, Andreas Herrmann wrote:
>>>> On Tue, Jan 20, 2009 at 04:16:10PM +0200, Mika Tiainen wrote:
>>>>> Hi,
>>>>>
>>>>> I built a new machine with Gigabyte GA-MA74GM-S2H motherboard that
>>>>> ntpd can't keep synced. Could this be a kernel bug or is it a
>>>>> hardware problem?
>>>>>
>>>>> Installed with Debian 2.6.27 kernel and currently running a self
>>>>> built 2.6.28.1, both have the problem. It's falling behind over
>>>>> 2s/15min:
>>>> That's annoying but I can't really help you with this. Maybe using
>>>> adjtimex as described in section 9.1.6 in
>>>> http://support.ntp.org/bin/view/Support/KnownHardwareIssues is an
>>>> option for you.
>> And adjtimex helped me on all 3 machines.
>> Running it in self-calibrate mode (that 70 sec thing)
>> plus running ntpd was enough for me for now.
> 
> Yes, I'm also using adjtimex+ntpd now with 10024 tick for adjtimex.
> 
>> What's interesting is that some time ago it worked just fine,
>> and, which is even more interesting, windows on this very
>> hardware shows quite good time stability (WITHOUT setting
>> the time using [s]ntp, its ntp client is disabled).
> 
> Something weird is definitely going on under Linux. I got it working by
> chance in 2.6.28 _exactly_ once. Just booted normally and ntpd kept it
> in time without any resets for the week that it was up, next boot with
> the same kernel and it was again falling behind so I installed adjtimex.
> 
> There was no difference in dmesg between working and not working.
> 

