Return-Path: <linux-kernel-owner+w=401wt.eu-S2993133AbXCIVHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993133AbXCIVHc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 16:07:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993137AbXCIVHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 16:07:31 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:37526 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993133AbXCIVHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 16:07:30 -0500
Date: Fri, 9 Mar 2007 21:50:23 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: ABI coupling to hypervisors via CONFIG_PARAVIRT
In-Reply-To: <20070309192420.GA27747@elte.hu>
Message-ID: <Pine.LNX.4.61.0703092135450.8799@yvahk01.tjqt.qr>
References: <20070309180230.GA17988@elte.hu>
 <Pine.LNX.4.64.0703091022490.10832@woody.linux-foundation.org>
 <20070309192420.GA27747@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,


On Mar 9 2007 20:24, Ingo Molnar wrote:
>* Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>>On Fri, 9 Mar 2007, Ingo Molnar wrote:
>>> 
>>> yes - but we already support the raw hardware ABI, in the native 
>>> kernel.
>> 
>> Why do you continue to call paravirt an ABI?
>> We got over that. It's not. It's an API.
>> VMI is an ABI.
>
>Unfortunately i still dont see where i'm wrong, and i'm really trying to 
>understand your argument. Is your argument that as long as an ABI (VMI) 
>is never directly used but only used via wrapper functions 
>(paravirt_ops), it has no effects whatsoever on the flexibility of the 
>rest of the software and ceases to have any negative ABI effects? [...]

As far as I understand and recognize it,


  [have monospaced font]

  paravirt struct      struct file_operations / {ALSA | OSS}
   ^                    ^
   |      <- API ->     |
   v                    v
  VMI                  /dev/dsp
   ^                    ^
   |      <- ABI ->     |
   v                    v
  product              userspace app


I think the sound example to the right really shows it. /dev/dsp has a
consistent ABI on a ton of systems. The API below it, varies. Linux got
file_operations and ALSA. Solaris/BSD may have its
vnode-and-so-on-functions and some sort of OSS.

Hope this helps (and more, I hope it's accurate - please correct me if I
am wrong.)



Jan
-- 
