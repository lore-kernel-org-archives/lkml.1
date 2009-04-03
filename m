Return-Path: <linux-kernel-owner+w=401wt.eu-S1756549AbZDCC6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549AbZDCC6o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 22:58:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752715AbZDCC6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 22:58:35 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:4595 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbZDCC6e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 22:58:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tK221wexu01Xhqm22emF5CRJmGFpkcSgzTbWkG6LNZISS2AaVINOtSl7fJOJ2rW+VJ
         pQqvnztMKEsx8aKVxryqHHE1A5OKHn1yIpLhQ7AlIfpEIcBq/nmxWfOSW/hNFXWe5bm1
         6aSOb3+VwTzvN5coHhtukqk9RoryalRS3k98c=
MIME-Version: 1.0
In-Reply-To: <9b1675090904021928k5a9948f9l8d93b6cbd5531720@mail.gmail.com>
References: <49CCCB0A.6070701@nokia.com> <alpine.DEB.2.01.0904021706330.6162@bogon.housecafe.de> 
	<9b1675090904021724t2fb0a671uc10d8e7bcba0bc5c@mail.gmail.com> 
	<9b1675090904021728y35776377u327f2266d06e2f29@mail.gmail.com> 
	<72dbd3150904021855v440f46a7oc21a7ed28fbfcb13@mail.gmail.com> 
	<9b1675090904021905o7e0cec64lfe4a5372777908b6@mail.gmail.com> 
	<72dbd3150904021919g5405ee40p100eacb085024941@mail.gmail.com> 
	<9b1675090904021928k5a9948f9l8d93b6cbd5531720@mail.gmail.com>
Date: Thu, 2 Apr 2009 19:58:17 -0700
Message-ID: <72dbd3150904021958q7795dc62keb54d1fbfaa6abc7@mail.gmail.com>
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

On Thu, Apr 2, 2009 at 7:28 PM, Trenton D. Adams
<trenton.d.adams@gmail.com> wrote:
> On Thu, Apr 2, 2009 at 8:19 PM, David Rees <drees76@gmail.com> wrote:
>> On Thu, Apr 2, 2009 at 7:05 PM, Trenton D. Adams <trenton.d.adams@gmail.com> wrote:
>>> On Thu, Apr 2, 2009 at 7:55 PM, David Rees <drees76@gmail.com> wrote:
>>>> On Thu, Apr 2, 2009 at 5:28 PM, Trenton D. Adams <trenton.d.adams@gmail.com> wrote:
>>> dirty_ratio and dirty_background never really had any affect for me.
>>> I'll look into the other parameters.  Waiting for the checkout again,
>>> as I am currently under a heavy rsync load (*rolls eyes*).
>>
>> How low have you set them?  Try setting them to 2 and 1 respectively.
>> It cuts down fsync latencies by a significant amount in my experience.
>
> That's the odd thing, I was setting them to 2 and 1.  I was just
> looking at the 2.6.29 code, and it should have made a difference.  I
> don't know what version of the kernel I was using at the time.  And,
> I'm not sure if I had the 1M fsync tests in place at the time either,
> to be sure about what I was testing.  It could be that I wasn't being
> very scientific about it at the time.  Thanks though, that setting
> makes a huge difference.

Well, it depends on how much memory you have.  Keep in mind that those
are percentages - so if you have 2GB RAM, that's the same as setting
it to 40MB and 20MB respectively - both are a lot larger than the 1M
you were setting the dirty*bytes vm knobs to.

I've got a problematic server with 8GB RAM.  Even if set both to 1,
that's 80MB and the crappy disks I have in it will often only write
10-20MB/s or less due to the seekiness of the workload.  That means
delays of 5-10 seconds worst case which isn't fun.

-Dave
