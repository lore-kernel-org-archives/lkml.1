Return-Path: <linux-kernel-owner+w=401wt.eu-S1756239AbYF0Fg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239AbYF0Fg5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 01:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752285AbYF0Fgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 01:36:49 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:12383 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbYF0Fgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 01:36:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jha+L5FtYgSELLwto6vjMQ70+0mrLrrrpmtjPMIZDYFW6SWXOUjDcDi6aKDyiZEkXx
         Kb+8nnYGEcxLM4jM9hCRtVv4AUrFYQuqrT4hQkabiRN+tuVznl26KHMWciJuMZf/b3dW
         K594mR2eTKfRJCvQzTRzAher3ByS/BMi4AoEo=
Message-ID: <86802c440806262236kef3364flcb42691332b1b4a1@mail.gmail.com>
Date: Thu, 26 Jun 2008 22:36:48 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH 1/2] x86 boot: add E820_RESVD_KERN
Cc: "H. Peter Anvin" <hpa@zytor.com>, andi@firstfloor.org, mingo@redhat.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
In-Reply-To: <1214535784.10865.14.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1214461978.10809.6.camel@caritas-dev.intel.com>
	 <86802c440806260025v3fc1970aq682b568cccba4b4e@mail.gmail.com>
	 <1214466513.11346.30.camel@caritas-dev.intel.com>
	 <86802c440806260247p19f5b850r8757c51280912ae9@mail.gmail.com>
	 <86802c440806261922n3f13b454o5e543e28d9a34e8e@mail.gmail.com>
	 <1214534894.10865.6.camel@caritas-dev.intel.com>
	 <86802c440806261952u31de7262u37e1b4d628c9ffcf@mail.gmail.com>
	 <1214535784.10865.14.camel@caritas-dev.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 8:03 PM, Huang, Ying <ying.huang@intel.com> wrote:
> On Thu, 2008-06-26 at 19:52 -0700, Yinghai Lu wrote:
>> On Thu, Jun 26, 2008 at 7:48 PM, Huang, Ying <ying.huang@intel.com> wrote:
>> > On Thu, 2008-06-26 at 19:22 -0700, Yinghai Lu wrote:
>> >> On Thu, Jun 26, 2008 at 2:47 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>> >> > On Thu, Jun 26, 2008 at 12:48 AM, Huang, Ying <ying.huang@intel.com> wrote:
>> >> >> On Thu, 2008-06-26 at 00:25 -0700, Yinghai Lu wrote:
>> >> >> [...]
>> >> >>> >                if (pfn >= limit_pfn)
>> >> >>> > @@ -977,7 +978,7 @@ u64 __init early_reserve_e820(u64 startt
>> >> >>> >                return 0;
>> >> >>> >
>> >> >>> >        addr = round_down(start + size - sizet, align);
>> >> >>> > -       e820_update_range(addr, sizet, E820_RAM, E820_RESERVED);
>> >> >>> > +       e820_update_range(addr, sizet, E820_RAM, E820_RESVD_KERN);
>> >> >>>
>> >> >>> this line is not needed.
>> >> >>
>> >> >> Why? Memory reserved by early_rserved_e820 should not be saved during
>> >> >> hibernation? shoudl not be saved by kdump?
>> >> >>
>> >
>> > Can you tell me why this line is not needed?
>>
>> that function only have one user. the mpc reserve_new, so we want it
>> to be E820_RESERVED, and kexec  tools could have that range reserved,
>> the next kernel will not overwrite the updated mptable.
>
> This is OK for kexec. Does it need to be saved by kdump? Does it need to
> be saved by hibernation (suspend to disk)?

the function is only called when alloc_mptable is specified in command line.

YH
