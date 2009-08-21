Return-Path: <linux-kernel-owner+w=401wt.eu-S932601AbZHURUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932601AbZHURUV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 13:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932486AbZHURUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 13:20:20 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:55322 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932463AbZHURUT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 13:20:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Bw/5voQhb79tzMMEqQwWkQRKh2VC6t8bc0Iy/3E5XDTJ1V8lctHAvdftW6zyVY4D78
         7O1ZhgZemNruCNHCMNIXgUcKdsdY46/JxERq4Q1qS2rLDxwOVHBHIRCQTIVs1V3I13wj
         +0+qv0h/jqm5a+UCZeXpR+9pS1NOR8IDiWbSM=
MIME-Version: 1.0
In-Reply-To: <1249933887.2501.62.camel@dhcp231-106.rdu.redhat.com>
References: <1249925740.2501.9.camel@dhcp231-106.rdu.redhat.com>
	 <19f34abd0908101156x2bc92b22ud1748abb153800fb@mail.gmail.com>
	 <1249933887.2501.62.camel@dhcp231-106.rdu.redhat.com>
Date: Fri, 21 Aug 2009 19:20:20 +0200
Message-ID: <19f34abd0908211020l6888d68w5c14cbadbca5c6c4@mail.gmail.com>
Subject: Re: kmemcheck in linux-next causes NULL pointer dereference at 
	task_rq_lock
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi, mingo@elte.hu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/8/10 Eric Paris <eparis@redhat.com>:
> On Mon, 2009-08-10 at 20:56 +0200, Vegard Nossum wrote:
>> 2009/8/10 Eric Paris <eparis@redhat.com>:
>> > I'm using 2.6.31-rc5-next-20090810 on a vmware server.  Originally I saw
>> > messages about setting to one cpu, so I booted with maxcpu=1.  I get
>> > this same panic with and without maxpu.  Booting with kmemcheck=0 boots
>> > just fine.
>> >
>> > I have not tested kmemcheck in linus' tree but will start looking for a
>> > working version now.  Any suggestions or things I should try?
>>
>> Hi, thanks for the report, and for trying it out.
>>
>> Does it crash with "kmemcheck=0 maxcpus=1" (it should be maxcpus, not
>> maxcpu). This should be a simple way of determining whether it was
>> kmemcheck or the existing maxcpus code, which we use, that broke.
>
> I boots fine with kmemcheck=0
>
> I did get the command line right.  maxcpus=1 kmemcheck=1 was the panic I
> showed in the last message.
>
>> If you can send config (off-list, probably), I will try to reproduce
>> and investigate more tomorrow.
>
> Will send it now.

Thanks. I've tried your config with next-20090810, next-20090820, and
current mainline, and wasn't able to reproduce it anywhere :-/

Does it still occur for you with the most recent linux-next or current mainline?

In any case, I think the kmemcheck SMP-handling code has to be fixed.
It seems that we currently allow CPU hotplug while kmemcheck is
enabled, which could lead to, erm, interesting crashes. Maybe we could
do something like what mmiotrace does.


Vegard
