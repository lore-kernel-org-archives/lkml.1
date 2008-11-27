Return-Path: <linux-kernel-owner+w=401wt.eu-S1753985AbYK0Syo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbYK0Syo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 13:54:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbYK0Syg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 13:54:36 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:44559 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbYK0Syf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 13:54:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=XKe5JOitxI5VCM+v8xDaFhbFInuJ8geQm8KApLbwhvU55ihWcg7e1HuqSA0lSu81OS
         RRGvgjPu0OV4uWW6YjFxceuDkEyGHPgz/cdaKg5Q3jEGAYeKtyhjWToOxrRix97blPlV
         Qh1C8bKfw/NNEKJjvddx8u44yHWPNqrQBO5OY=
Message-ID: <7c86c4470811271054l27f2f49dk5f1b758098b9c350@mail.gmail.com>
Date: Thu, 27 Nov 2008 19:54:33 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [patch 02/24] perfmon: base code
Cc: "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu, x86@kernel.org,
       sfr@canb.auug.org.au
In-Reply-To: <alpine.LFD.2.00.0811271933500.3325@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <492d0bd8.11435e0a.1686.ffff8801@mx.google.com>
	 <alpine.LFD.2.00.0811271638350.3325@localhost.localdomain>
	 <7c86c4470811270947q585cba5vf8bdb875962a1856@mail.gmail.com>
	 <alpine.LFD.2.00.0811271858300.3325@localhost.localdomain>
	 <20081127184149.GR6703@one.firstfloor.org>
	 <alpine.LFD.2.00.0811271933500.3325@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

On Thu, Nov 27, 2008 at 7:36 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Thu, 27 Nov 2008, Andi Kleen wrote:
>
>> > Well, where is it checked ? Where is checked whether Oprofile runs or not ?
>>
>> That is done using the perfctr reservation. I saw that somewhere in the
>> patchkit. The NMI watchdog uses that too.
>>
>> > > The Oprofile reservation you see is built on top of the cpumask reservation.
>> > > It tries to allocate in one call and atomically ALL the CPUs as this is the way
>> > > Oprofile operates. Thus it fails if one perfmon system-wide session or one
>> > > perfmon per-thread exists.
>> >
>> > This only prevents oprofile from starting, but it does neither prevent
>> > thread sessions nor does it prevent a perfmon per cpu session on a cpu
>> > which was onlined after oprofile started, simply because it's bit is
>> > missing in the CPU mask.
>>
>> The perfctr reservation is global over all CPUs.
>
> So this mean we manage resources on multiple levels, some bits here
> and some bits there and five checks in each code path do get them all.
>
> Really convincing concept.

That is a different level of resource management: register level.

Both Perfmon and Oprofile can operate with fewer registers than what the
hardware actually supports. Take an AMD64 CPU with 4 counters. With
the NMI watchdog active, Perfmon or Oprofile will run with only 3. That's
better than nothing and is sufficient for many measurments.
