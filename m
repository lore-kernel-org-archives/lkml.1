Return-Path: <linux-kernel-owner+w=401wt.eu-S1754844AbZCIUmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844AbZCIUmz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 16:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752988AbZCIUmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 16:42:45 -0400
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:35130 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752685AbZCIUmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 16:42:44 -0400
Message-ID: <49B57F3D.5030008@krogh.cc>
Date: Mon, 09 Mar 2009 21:42:37 +0100
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>
Subject: Re: Linux 2.6.29-rc6
References: <alpine.LFD.2.00.0902222023520.3111@localhost.localdomain>	 <49A6F39F.9040801@krogh.cc>	 <alpine.LFD.2.00.0902261232570.3111@localhost.localdomain>	 <49A6FEE2.90700@krogh.cc>	 <1f1b08da0902261319k7a60d80xaafc1101facfd2d9@mail.gmail.com>	 <49A70B24.6090706@krogh.cc>	 <1235685269.6811.11.camel@localhost.localdomain>	 <alpine.LFD.2.00.0902262255190.9135@localhost.localdomain>	 <1235687483.6811.26.camel@localhost.localdomain>  <49A78C79.304@krogh.cc>	 <1235766936.7402.5.camel@localhost.localdomain> <49ABACA0.3090300@krogh.cc>	 <1236029277.7756.0.camel@localhost.localdomain> <49ACC853.8070205@krogh.cc>	 <1236110026.6068.18.camel@localhost> <49AD90E2.7050209@krogh.cc>	 <1236118969.6068.87.camel@localhost> <49AE9EA4.2080500@krogh.cc>	 <49AECA3B.5030503@krogh.cc>  <1236193075.3793.63.camel@jstultz-laptop>	 <1236220759.6863.7.camel@localhost.localdomain> <1236221530.6863.9.camel@localhost.localdomain>
In-Reply-To: <1236221530.6863.9.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

john stultz wrote:
> On Wed, 2009-03-04 at 18:39 -0800, john stultz wrote:
>> On Wed, 2009-03-04 at 10:57 -0800, John Stultz wrote:
>>> On Wed, 2009-03-04 at 19:36 +0100, Jesper Krogh wrote:
>>>> jk@quad12:~$ python drift-test.py 10.192.96.19
>>>> 04 Mar 19:27:10         offset: -0.157696       drift: -693.0 ppm
>>>> 04 Mar 19:28:10         offset: -0.195134       drift: -625.098360656 ppm
>>>> 04 Mar 19:29:10         offset: -0.232579       drift: -624.595041322 ppm
>>>> 04 Mar 19:30:10         offset: -0.270021       drift: -624.408839779 ppm
>>>> 04 Mar 19:31:11         offset: -0.307461       drift: -621.727272727 ppm
>>>> 04 Mar 19:32:11         offset: -0.344903       drift: -622.185430464 ppm
>>>> 04 Mar 19:33:11         offset: -0.382345       drift: -622.491712707 ppm
>>>> 04 Mar 19:34:11         offset: -0.419794       drift: -622.727488152 ppm
>>>> 04 Mar 19:35:11         offset: -0.457239       drift: -622.89626556 ppm
>>>
>>> Yea, so from this and the settled ntpdc -c kerninfo data before, we can
>>> see that the drift is further out then the 500ppm NTP can handle.
>>>
>>> So with that at least confirmed, we can focus back on to the fast-pit
>>> tsc calibration code.
>>>
>>> Ingo, Thomas: I'm missing a bit of the context to that patch, other then
>>> just speeding up boot times, was there other rational for moving away
>>> from the ACPI PM timer based calibration?
>>>
>>> Could we maybe add a quick test that the pit reads actually take the
>>> assumed 2us max? Doing this maybe via the HPET/ACPI PM?
>> Hey Jesper,
>>
>> 	Here's a very-hackish patch to see if the approach I'm considering
>> might fix the issue you're hitting. Could you apply it, boot the kernel
>> a few times and send me the following segments of the dmesg for each of
>> those boots (the example below is from my test box)? 
>>
>> tsc delta: 44418024
>> ref_freq: 3000100  pit_freq: 3000384
>> TSC: Fast PIT calibration matches PMTIMER.
>> TSC: PIT calibration matches PMTIMER. 1 loops
>> Detected 3000.045 MHz processor.

Hi John.

Patched into 2.6.28.7 ..

First boot.
[    0.000000] tsc delta: 34203220
[    0.000000] ref_freq: 2311825  pit_freq: 2310386
[    0.000000] TSC: Fast PIT calibration matches PMTIMER.
[    0.000000] TSC: PIT calibration matches PMTIMER. 2 loops
[    0.000000] Detected 2311.877 MHz processor.
Second boot:
[    0.000000] tsc delta: 34200313
[    0.000000] ref_freq: 2311803  pit_freq: 2310190
[    0.000000] TSC: Fast PIT calibration matches PMTIMER.
[    0.000000] TSC: PIT calibration matches PMTIMER. 2 loops
[    0.000000] Detected 2311.876 MHz processor.
Third boot:
[    0.000000] tsc delta: 34198686
[    0.000000] ref_freq: 2311824  pit_freq: 2310080
[    0.000000] TSC: Fast PIT calibration matches PMTIMER.
[    0.000000] TSC: PIT calibration matches PMTIMER. 1 loops
[    0.000000] Detected 2311.872 MHz processor.
Fourth boot:
[    0.000000] tsc delta: 34199433
[    0.000000] ref_freq: 2311831  pit_freq: 2310130
[    0.000000] TSC: Fast PIT calibration matches PMTIMER.
[    0.000000] TSC: PIT calibration matches PMTIMER. 2 loops
[    0.000000] Detected 2311.821 MHz processor.



-- 
Jesper
