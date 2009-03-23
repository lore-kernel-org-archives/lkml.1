Return-Path: <linux-kernel-owner+w=401wt.eu-S1759679AbZCWQDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759679AbZCWQDJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 12:03:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759215AbZCWQBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 12:01:16 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:57985 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759394AbZCWQAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 12:00:55 -0400
Message-ID: <49C7B30D.9030608@msgid.tls.msk.ru>
Date: Mon, 23 Mar 2009 19:04:29 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Avi Kivity <avi@redhat.com>, John Stultz <johnstul@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux-kernel <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: phenom, amd780g, tsc, hpet, kvm, kernel -- who's at fault?
References: <49BACABE.7060003@msgid.tls.msk.ru> <20090323080441.GA27170@elte.hu> <49C748EA.6040809@msgid.tls.msk.ru> <20090323154137.GA1259@elte.hu>
In-Reply-To: <20090323154137.GA1259@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Michael Tokarev <mjt@tls.msk.ru> wrote:
> 
>> Now, after quite some googling around, I tried to disable hpet, 
>> booting with hpet=disable parameter.  And that one fixed all the 
>> problems at once. 7 days uptime, I stress-tested it several times, 
>> it works with TSC as timesource (still a problem within guests as 
>> those shows unstable TSC anyway) since boot, no issues logged.  
>> Even cpufreq works as expected...
[]
> It could again go bad like it did before - those messages are signs 
> of HPET weirdnesses.
> 
> Probably your box's hpet needs to be blacklisted, so that it gets 
> disabled automatically on bootup.

Well, I'm not convinced at all... at least not yet ;)

The reason is simple: this box was rock solid a few months back.
With 2.6.25 and 2.6.26 kernels I think.  It had probs with kvm
(bugs), and lacked in general hardware support (both the chipset
and phenom cpu were still too new to be fully supported).  At
that time I installed the thing (was a test install with a random
hdd, so I added real drives and installed real distro), with quite
a lot of data copying back and forth (were rearranging partitions,
raid arrays, guests and so on, copying data to another disk, to
another machine and back).  There was no single issue, no single
mention of tsc or hpet instabilities, and system time was stable
too.  But since some time, -- unfortunately I don't know when
exactly, and sure thing it'd be very interesting to know, I'll
try to figure it out -- first it started showing system clock
weirdness, and finally come to this Friday the 13 incident.

That all to say: it was stable with earlier kernel.  Now it's not.
Maybe, just maybe, at that time hpet wasn't supported, or maybe
wasn't used, or supported not in full to rely on it - I've no
idea.  If that's the case, I'll just shut up now because the
whole point becomes moot.

Maybe it was due to somehow broken bios -- I did several bios
updates there, mostly because linux complained about something
scary (something akin "wasting so much megs memory due to bios
not set up something (GART? IOMMU?)") and I was hoping to fix that.
And it will be fixed someday in bios...

(By the way: how bad the lack of hpet is?  It's used for
something, and having it malfunctioning and disabled does
not sound good, esp. on a machine which is running close
to its maximum...  Maybe I should return the mobo back? :)

Thanks!

/mjt
