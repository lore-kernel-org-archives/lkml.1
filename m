Return-Path: <linux-kernel-owner+w=401wt.eu-S1757649AbZDCDOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757649AbZDCDOT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 23:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754889AbZDCDOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 23:14:04 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:26194 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631AbZDCDOC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 23:14:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=e4hK6eMd0IZRu7+he6OTuBdJqyH1M7KhgND2TULVviXVJY4ELKH0dVYZgqZLCAZZT1
         cXoJk88KaDzSy807cUtW4ew5GHIN1Ube7W9lwLe0H8UOoj2J9n/FFo0qhqNZw0nM/v+q
         kNGS8Sf3xV/Tl8eu2TfOGptJgrup6I9bW74m4=
MIME-Version: 1.0
In-Reply-To: <9b1675090904022013t6c892b9bo91eab0fd7091bfbe@mail.gmail.com>
References: <49CCCB0A.6070701@nokia.com>
	 <alpine.DEB.2.01.0904021706330.6162@bogon.housecafe.de>
	 <9b1675090904021724t2fb0a671uc10d8e7bcba0bc5c@mail.gmail.com>
	 <9b1675090904021728y35776377u327f2266d06e2f29@mail.gmail.com>
	 <72dbd3150904021855v440f46a7oc21a7ed28fbfcb13@mail.gmail.com>
	 <9b1675090904021905o7e0cec64lfe4a5372777908b6@mail.gmail.com>
	 <72dbd3150904021919g5405ee40p100eacb085024941@mail.gmail.com>
	 <9b1675090904021928k5a9948f9l8d93b6cbd5531720@mail.gmail.com>
	 <72dbd3150904021958q7795dc62keb54d1fbfaa6abc7@mail.gmail.com>
	 <9b1675090904022013t6c892b9bo91eab0fd7091bfbe@mail.gmail.com>
Date: Thu, 2 Apr 2009 21:14:00 -0600
Message-ID: <9b1675090904022014t27e7f75ev1ca93cba94737c36@mail.gmail.com>
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

I'm really sorry, I just realized I hijacked this thread.  I'll stop now.

On Thu, Apr 2, 2009 at 9:13 PM, Trenton D. Adams
<trenton.d.adams@gmail.com> wrote:
> On Thu, Apr 2, 2009 at 8:58 PM, David Rees <drees76@gmail.com> wrote:
>> On Thu, Apr 2, 2009 at 7:28 PM, Trenton D. Adams
>>> That's the odd thing, I was setting them to 2 and 1.  I was just
>>> looking at the 2.6.29 code, and it should have made a difference.  I
>>> don't know what version of the kernel I was using at the time.  And,
>>> I'm not sure if I had the 1M fsync tests in place at the time either,
>>> to be sure about what I was testing.  It could be that I wasn't being
>>> very scientific about it at the time.  Thanks though, that setting
>>> makes a huge difference.
>>
>> Well, it depends on how much memory you have.  Keep in mind that those
>> are percentages - so if you have 2GB RAM, that's the same as setting
>> it to 40MB and 20MB respectively - both are a lot larger than the 1M
>> you were setting the dirty*bytes vm knobs to.
>>
>> I've got a problematic server with 8GB RAM.  Even if set both to 1,
>> that's 80MB and the crappy disks I have in it will often only write
>> 10-20MB/s or less due to the seekiness of the workload.  That means
>> delays of 5-10 seconds worst case which isn't fun.
>>
>> -Dave
>>
>
> Yeah, I just finished doing the calculation. :P  40M is what I'm
> seeing.  Yeah, that sounds like the same as my problem.  Even setting
> it to 10M dirty_bytes has a very serious latency problem.  I'm glad
> that option was added, because 1M works much better.  I'll have to
> change my shell script to dynamically tune on that.  Because under
> normal load, I want the 40M+ of queueing.  It's just when things get
> really heavy, and stuff starts getting flushed, that this problem
> starts happening.
>
