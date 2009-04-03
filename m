Return-Path: <linux-kernel-owner+w=401wt.eu-S1756248AbZDCC0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248AbZDCC0S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 22:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbZDCC0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 22:26:06 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:60596 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbZDCC0D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 22:26:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HHDDPnvAxWsHUbPlzHm6L9PnMCnti8qT6qtl7QPCt+s9CVIrBO1iWRQ9vfBDKxL7Io
         73IeD7uG3CQGQmJ7wN2MYJO2fdfSEYftLWB9SMUnluCdIBWbAteatBXLk3PY1cnWaXKa
         aFfzao8S+6iv5CJsoKoncXH7Gq0VRA6breOOU=
MIME-Version: 1.0
In-Reply-To: <72dbd3150904021855v440f46a7oc21a7ed28fbfcb13@mail.gmail.com>
References: <49CCCB0A.6070701@nokia.com>
	 <alpine.DEB.2.01.0904021706330.6162@bogon.housecafe.de>
	 <9b1675090904021724t2fb0a671uc10d8e7bcba0bc5c@mail.gmail.com>
	 <9b1675090904021728y35776377u327f2266d06e2f29@mail.gmail.com>
	 <72dbd3150904021855v440f46a7oc21a7ed28fbfcb13@mail.gmail.com>
Date: Thu, 2 Apr 2009 20:26:01 -0600
Message-ID: <9b1675090904021926o4a404c3ajf623b1560f919289@mail.gmail.com>
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

On Thu, Apr 2, 2009 at 7:55 PM, David Rees <drees76@gmail.com> wrote:
> On Thu, Apr 2, 2009 at 5:28 PM, Trenton D. Adams
> <trenton.d.adams@gmail.com> wrote:
>> On Thu, Apr 2, 2009 at 6:24 PM, Trenton D. Adams
>> <trenton.d.adams@gmail.com> wrote:
>>> Yes, mounting "-o sync" does improve ext3 performance.  It sucks
>>> though, because I do want quick writes.  And mounting with sync option
>>> slows down to disk io speeds.  In my case, that's between 20 and 23
>>> megabytes per second *big frown, quivering lip, and tears in my eyes*.
>>> :P
>>>
>>
>> Oh, I should have clarified.  It improves performance under heavy
>> load.  Under normal load, mounting without sync is fine.  What I tend
>> to do is mount with "remount,rw,sync" when heavy load is starting.
>> Then my system goes slowly, but latency is good.  Then, when it's all
>> done (say a big compile, or job, or whatever), I remount without sync
>> again.
>>
>> I'm thinking of writing a script that monitors performance, and
>> remounts as needed, lol.  WHAT A HACK. hehe.
>
> All you're doing here is implementing the lowering of dirty data
> limits in the VM dynamically based on how long fsyncs take.
>
> Linus outlined this specific strategy as "the ideal siutation"
> somewhere in the depths of "That filesystem thread".
>
> Look at the new in 2.6.29 dirty*bytes parameters in
> Documentation/sysctl/vm.txt for more info.  By lowering those values,
> you can effectively turn normal writes into synchronous writes which
> will greatly reduce latency of fsync under heavy write load.

WOW, that makes a huge difference.  If I set it to 100M, I get the
10-15 second delay I was talking about.  But, if I set it to 1M, I get
0.3 to 0.4 second delay on a 1M fsync.  That is way better.  Perhaps I
should auto-tune based on that parameter then.  Although I do agree
with Linus that it sucks to do userland auto-tuning. :P
