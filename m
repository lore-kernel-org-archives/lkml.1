Return-Path: <linux-kernel-owner+w=401wt.eu-S1760780AbZBMX0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760780AbZBMX0S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 18:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753416AbZBMX0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 18:26:09 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:32922 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbZBMX0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 18:26:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=to9e1NfeH989UmKiQP5V7am1cchRtt1dF04XkbX/8UqTyP94SWuuKQNva3+Eem/1Fv
         Kk2MvIgx8WgzWiO7osA/wnRl/GIBBMYxTWYiNMBwUL1D2kFnIGav5cWT+NFbHLG23Xfv
         0MvSbnSXv0ymLs8vN8dqGxIBuFE0862GTPNUY=
MIME-Version: 1.0
In-Reply-To: <20080911174657.GN7714@one.firstfloor.org>
References: <e85b9d30809110712y700a9d8exb5828487984d6a59@mail.gmail.com>
	 <e85b9d30809110713m542fc884sc17374f7fb2c7493@mail.gmail.com>
	 <20080911174657.GN7714@one.firstfloor.org>
Date: Sat, 14 Feb 2009 00:26:05 +0100
Message-ID: <e85b9d30902131526v5f710583ub58d578339dd0a90@mail.gmail.com>
Subject: Re: Fwd: [PATCH] Implement barrier support for single device DM 
	devices
From: Mat <jackdachef@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: agk@redhat.com, Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

any news on this patch ?

from what I saw it isn't included in mainline yet, if it is already
please point to the kernel-config option where to enable it

there are some serious problems with interactivity / GUI access during
heavy flush, write operations; especially on amd64/X64:
http://forums.gentoo.org/viewtopic-t-482731.html

I'm not sure if it's possible but I believe it could also be related
to filesystems switching to synchronous writes (non-barrier
write-mode) when the underlying partition is a LUKS-partition and
therefore
decreasing performance (I'm not a kernel-hacker so I don't know if
there's a possible correlation here)

some factors I noticed having an impact on that are:

- CFS (the cpu scheduler)
  # if echo 1 > /sys/devices/system/cpu/sched_mc_power_savings is enabled
  # and group scheduling enabled
  it's very noticable, sometimes under heavy load the output on the
monitor hardly changes anymore and the box also hardly reacts to input
  on my hardware the best interactivity under high load so far was
with a 2.6.24-based kernel (2.6.24-zen3/4) after and before that with
CFS everything was average and not very interactive (YMMV)
- the i/o scheduler hardly makes a change
- elder boxes with PCI (non-PCIe) can be "fixed" with some latency-tweaks:
  setpci -v -d *:* latency_timer=b0

   setpci -v -s 02:00.0 latency_timer=40
   setpci -v -s 00:1f.2 latency_timer=40

  setpci -v -s 02:00.1 latency_timer=40
  setpci -v -s 00:1f.1 latency_timer=40

   #maximize latency timers for network and audio, allowing them to transmit
  #more data per burst, preventing buffer over/underrun conditions
  setpci -v -s 00:1b.0 latency_timer=ff
  setpci -v -s 03:00.0 latency_timer=ff
  setpci -v -s 04:00.0 latency_timer=ff
- for me this doesn't occur / didn't occur with the RT-kernel and
hardirq, softirq, preemptive rcu enabled

Many thanks in advance

Regards

Mat



On Thu, Sep 11, 2008 at 6:46 PM, Andi Kleen <andi@firstfloor.org> wrote:
> On Thu, Sep 11, 2008 at 04:13:39PM +0200, Mat wrote:
>> any news on this patch and when it will get included in mainline / linus' tree ?
>
> I think Alasdair rejected it in the end (?) He tried to explain me why at OLS,
> but as far as I remember I didn't understand his reasoning. It had something
> to do with stack consumption, but afaik the patch doesn't
> increase stack consumption.
>
> Cc him for clarification.
>
>> I believe this will gain lots of people time savings with no side-effects :)
>>
>> (I haven't tried it out yet but will in the near future, so if there's
>> a new version of it, please let people know)
>
> At least as of 2.6.26 the old patch still works. Haven't tried with .27
> yet.
>
> -Andi
>
> --
> ak@linux.intel.com
>
