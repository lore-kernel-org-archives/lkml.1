Return-Path: <linux-kernel-owner+w=401wt.eu-S1756282AbZDCDNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282AbZDCDNj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 23:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753940AbZDCDNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 23:13:31 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:37143 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866AbZDCDNa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 23:13:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=x856+0DYJg148xyDfFi63SflFwvZre9doj95FBB1A70vKZwng/vLMqYgsneZIBmjNn
         QmhJCpfIqLUUwlqC9aPgHvhp1bSciBS3VdVzGP7e3/ofShiukSR47nFoLqK1/3Se/ZZX
         PAwcThHkX0TKsTYHSLil2WyI/DGeo1gtiEMLU=
MIME-Version: 1.0
In-Reply-To: <72dbd3150904021958q7795dc62keb54d1fbfaa6abc7@mail.gmail.com>
References: <49CCCB0A.6070701@nokia.com>
	 <alpine.DEB.2.01.0904021706330.6162@bogon.housecafe.de>
	 <9b1675090904021724t2fb0a671uc10d8e7bcba0bc5c@mail.gmail.com>
	 <9b1675090904021728y35776377u327f2266d06e2f29@mail.gmail.com>
	 <72dbd3150904021855v440f46a7oc21a7ed28fbfcb13@mail.gmail.com>
	 <9b1675090904021905o7e0cec64lfe4a5372777908b6@mail.gmail.com>
	 <72dbd3150904021919g5405ee40p100eacb085024941@mail.gmail.com>
	 <9b1675090904021928k5a9948f9l8d93b6cbd5531720@mail.gmail.com>
	 <72dbd3150904021958q7795dc62keb54d1fbfaa6abc7@mail.gmail.com>
Date: Thu, 2 Apr 2009 21:13:28 -0600
Message-ID: <9b1675090904022013t6c892b9bo91eab0fd7091bfbe@mail.gmail.com>
Subject: Re: EXT4-ish "fixes" in UBIFS
From: "Trenton D. Adams" <trenton.d.adams@gmail.com>
To: David Rees <drees76@gmail.com>
Cc: Christian Kujau <lists@nerdbynature.de>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 2, 2009 at 8:58 PM, David Rees <drees76@gmail.com> wrote:
> On Thu, Apr 2, 2009 at 7:28 PM, Trenton D. Adams
>> That's the odd thing, I was setting them to 2 and 1.  I was just
>> looking at the 2.6.29 code, and it should have made a difference.  I
>> don't know what version of the kernel I was using at the time.  And,
>> I'm not sure if I had the 1M fsync tests in place at the time either,
>> to be sure about what I was testing.  It could be that I wasn't being
>> very scientific about it at the time.  Thanks though, that setting
>> makes a huge difference.
>
> Well, it depends on how much memory you have.  Keep in mind that those
> are percentages - so if you have 2GB RAM, that's the same as setting
> it to 40MB and 20MB respectively - both are a lot larger than the 1M
> you were setting the dirty*bytes vm knobs to.
>
> I've got a problematic server with 8GB RAM.  Even if set both to 1,
> that's 80MB and the crappy disks I have in it will often only write
> 10-20MB/s or less due to the seekiness of the workload.  That means
> delays of 5-10 seconds worst case which isn't fun.
>
> -Dave
>

Yeah, I just finished doing the calculation. :P  40M is what I'm
seeing.  Yeah, that sounds like the same as my problem.  Even setting
it to 10M dirty_bytes has a very serious latency problem.  I'm glad
that option was added, because 1M works much better.  I'll have to
change my shell script to dynamically tune on that.  Because under
normal load, I want the 40M+ of queueing.  It's just when things get
really heavy, and stuff starts getting flushed, that this problem
starts happening.
