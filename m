Return-Path: <linux-kernel-owner+w=401wt.eu-S1753729AbZDCCU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729AbZDCCU3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 22:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751698AbZDCCUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 22:20:18 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:52175 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbZDCCUP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 22:20:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jDCIkfgC1f9NVBVxm4hFGfgEtygoyhNBL4QWZ0WKLgnB7fe8qUCe0alSKpDWO87veI
         4/yKE0AzsKFPoZd3mAz68nGVlilNpbnd161IpLaBeG8j/O6kcWm4dBQTb29Nvua5oDm1
         +GlvcFyvRsRofNquZjKAfnCLR07ne2Q73kcXQ=
MIME-Version: 1.0
In-Reply-To: <9b1675090904021905o7e0cec64lfe4a5372777908b6@mail.gmail.com>
References: <49CCCB0A.6070701@nokia.com> <alpine.DEB.2.01.0904021706330.6162@bogon.housecafe.de> 
	<9b1675090904021724t2fb0a671uc10d8e7bcba0bc5c@mail.gmail.com> 
	<9b1675090904021728y35776377u327f2266d06e2f29@mail.gmail.com> 
	<72dbd3150904021855v440f46a7oc21a7ed28fbfcb13@mail.gmail.com> 
	<9b1675090904021905o7e0cec64lfe4a5372777908b6@mail.gmail.com>
Date: Thu, 2 Apr 2009 19:19:58 -0700
Message-ID: <72dbd3150904021919g5405ee40p100eacb085024941@mail.gmail.com>
Subject: Re: EXT4-ish "fixes" in UBIFS
From: David Rees <drees76@gmail.com>
To: "Trenton D. Adams" <trenton.d.adams@gmail.com>
Cc: Christian Kujau <lists@nerdbynature.de>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 2, 2009 at 7:05 PM, Trenton D. Adams
<trenton.d.adams@gmail.com> wrote:
> On Thu, Apr 2, 2009 at 7:55 PM, David Rees <drees76@gmail.com> wrote:
>> On Thu, Apr 2, 2009 at 5:28 PM, Trenton D. Adams
>> <trenton.d.adams@gmail.com> wrote:
>>> Oh, I should have clarified.  It improves performance under heavy
>>> load.  Under normal load, mounting without sync is fine.  What I tend
>>> to do is mount with "remount,rw,sync" when heavy load is starting.
>>> Then my system goes slowly, but latency is good.  Then, when it's all
>>> done (say a big compile, or job, or whatever), I remount without sync
>>> again.
>>>
>>> I'm thinking of writing a script that monitors performance, and
>>> remounts as needed, lol.  WHAT A HACK. hehe.
>>
>> All you're doing here is implementing the lowering of dirty data
>> limits in the VM dynamically based on how long fsyncs take.
>>
>> Linus outlined this specific strategy as "the ideal siutation"
>> somewhere in the depths of "That filesystem thread".
>
> I thought he said it was a HORRIBLE solution. :D  I recall him
> slamming Andrew over it.  Unless you're referring to the kernel
> actually doing it on the fly.

Yes - you are correct - doing it in userspace isn't the best place to
put it - but if you can do it there, the same ideas could then be
pushed into the kernel and further enhanced.

>> Look at the new in 2.6.29 dirty*bytes parameters in
>> Documentation/sysctl/vm.txt for more info.  By lowering those values,
>> you can effectively turn normal writes into synchronous writes which
>> will greatly reduce latency of fsync under heavy write load.
>>
>> In previous kernels you can tweak dirty_ratio and
>> dirty_background_ratio, but they don't have the granularity of the new
>> knobs.  Although if you are talking about just remounting in sync
>> mode, they may work for you at least as a proof of concept. ;-)
>
> dirty_ratio and dirty_background never really had any affect for me.
> I'll look into the other parameters.  Waiting for the checkout again,
> as I am currently under a heavy rsync load (*rolls eyes*).

How low have you set them?  Try setting them to 2 and 1 respectively.
It cuts down fsync latencies by a significant amount in my experience.

-Dave
