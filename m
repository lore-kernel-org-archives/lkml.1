Return-Path: <linux-kernel-owner+w=401wt.eu-S1759817AbZDCBzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759817AbZDCBzc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 21:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755581AbZDCBzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 21:55:23 -0400
Received: from mail-gx0-f160.google.com ([209.85.217.160]:62040 "EHLO
	mail-gx0-f160.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041AbZDCBzW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 21:55:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nKMPx7jj6L5nFsd9Lu5A4LB3Ey5779LzezTQKhf6zKRWfKFmDQNO/HAjyRfumOHc9E
         KYZC2F2aBfl+J/xf/S+JVnndVl7zAeL9fCGTWjEGf1TUnPHAyQH6zwWW23rHyPfv9rBr
         guu8I2PspDHjo5hzV4IFnKE/kUacp6QtpBZow=
MIME-Version: 1.0
In-Reply-To: <9b1675090904021728y35776377u327f2266d06e2f29@mail.gmail.com>
References: <49CCCB0A.6070701@nokia.com> <alpine.DEB.2.01.0904021706330.6162@bogon.housecafe.de> 
	<9b1675090904021724t2fb0a671uc10d8e7bcba0bc5c@mail.gmail.com> 
	<9b1675090904021728y35776377u327f2266d06e2f29@mail.gmail.com>
Date: Thu, 2 Apr 2009 18:55:03 -0700
Message-ID: <72dbd3150904021855v440f46a7oc21a7ed28fbfcb13@mail.gmail.com>
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

On Thu, Apr 2, 2009 at 5:28 PM, Trenton D. Adams
<trenton.d.adams@gmail.com> wrote:
> On Thu, Apr 2, 2009 at 6:24 PM, Trenton D. Adams
> <trenton.d.adams@gmail.com> wrote:
>> Yes, mounting "-o sync" does improve ext3 performance.  It sucks
>> though, because I do want quick writes.  And mounting with sync option
>> slows down to disk io speeds.  In my case, that's between 20 and 23
>> megabytes per second *big frown, quivering lip, and tears in my eyes*.
>> :P
>>
>
> Oh, I should have clarified.  It improves performance under heavy
> load.  Under normal load, mounting without sync is fine.  What I tend
> to do is mount with "remount,rw,sync" when heavy load is starting.
> Then my system goes slowly, but latency is good.  Then, when it's all
> done (say a big compile, or job, or whatever), I remount without sync
> again.
>
> I'm thinking of writing a script that monitors performance, and
> remounts as needed, lol.  WHAT A HACK. hehe.

All you're doing here is implementing the lowering of dirty data
limits in the VM dynamically based on how long fsyncs take.

Linus outlined this specific strategy as "the ideal siutation"
somewhere in the depths of "That filesystem thread".

Look at the new in 2.6.29 dirty*bytes parameters in
Documentation/sysctl/vm.txt for more info.  By lowering those values,
you can effectively turn normal writes into synchronous writes which
will greatly reduce latency of fsync under heavy write load.

In previous kernels you can tweak dirty_ratio and
dirty_background_ratio, but they don't have the granularity of the new
knobs.  Although if you are talking about just remounting in sync
mode, they may work for you at least as a proof of concept. ;-)

-Dave
