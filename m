Return-Path: <linux-kernel-owner+w=401wt.eu-S936242AbZDCSG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936242AbZDCSG0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 14:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935498AbZDCSFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 14:05:46 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:38463 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936179AbZDCSFn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 14:05:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=U174x5zeyLcS2bH1P0kHhtBkM18CvdskYl/YR9aeh5lat42AZDb0zx/QaRWGrqp9od
         3MW9i5a2iiyV6TreBk1u4Z/0pvtObjdkOKqENMs3MueMYJB72qo78HMO76oEfrERy6tz
         U52R3gu7R+ZFzxY3s+/ThkAnPuZCDYsHc1cO8=
MIME-Version: 1.0
In-Reply-To: <20090403050246.GM9870@mit.edu>
References: <49CCCB0A.6070701@nokia.com> <alpine.DEB.2.01.0904021706330.6162@bogon.housecafe.de> 
	<9b1675090904021724t2fb0a671uc10d8e7bcba0bc5c@mail.gmail.com> 
	<9b1675090904021728y35776377u327f2266d06e2f29@mail.gmail.com> 
	<72dbd3150904021855v440f46a7oc21a7ed28fbfcb13@mail.gmail.com> 
	<9b1675090904021905o7e0cec64lfe4a5372777908b6@mail.gmail.com> 
	<72dbd3150904021919g5405ee40p100eacb085024941@mail.gmail.com> 
	<9b1675090904021928k5a9948f9l8d93b6cbd5531720@mail.gmail.com> 
	<72dbd3150904021958q7795dc62keb54d1fbfaa6abc7@mail.gmail.com> 
	<20090403050246.GM9870@mit.edu>
Date: Fri, 3 Apr 2009 11:05:16 -0700
Message-ID: <72dbd3150904031105v1020e836i61c5a4bc0ebe453@mail.gmail.com>
Subject: Re: EXT4-ish "fixes" in UBIFS
From: David Rees <drees76@gmail.com>
To: Theodore Tso <tytso@mit.edu>, David Rees <drees76@gmail.com>,
       "Trenton D. Adams" <trenton.d.adams@gmail.com>,
       Christian Kujau <lists@nerdbynature.de>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 2, 2009 at 10:02 PM, Theodore Tso <tytso@mit.edu> wrote:
> On Thu, Apr 02, 2009 at 07:58:17PM -0700, David Rees wrote:
>>
>> I've got a problematic server with 8GB RAM.  Even if set both to 1,
>> that's 80MB and the crappy disks I have in it will often only write
>> 10-20MB/s or less due to the seekiness of the workload.  That means
>> delays of 5-10 seconds worst case which isn't fun.
>
> Well, one solution is data=writeback.  If you're confident your server
> isn't going to randomly crash (i.e., it's on a UPS, and you're not
> running unstable video drivers), that might be a solution.  It has
> tradeoffs, though.

Yeah, that's probably a good workaround for the server in question.  I
don't recall it ever crashing.

> One thing which I'll probably implement is some patches to ext3 so
> that when it's in data=writeback mode, it will use the same
> replace-via-rename and replace-via-truncate hueristics that I added in
> ext4 so that it will start an aysnchronous writeout on the rename() or
> close() w/ truncate().  That should avoid existing files getting
> corrupted when they are replaced right before the system crashes.

I think that would be a welcome addition to the writeback mode of ext3.

> People will still be better off moving to ext4, but for people who
> aren't quite confident in ext4's stability yet and who want to stick
> with ext3, maybe it's a good short-term solution.  Maybe
> data=writeback with the rename hueristic would be a better default
> than data=ordered for ext3.

I've been waiting for Fedora to ship either the latest stable 2.6.28
or 2.6.29 kernel before putting any serious data on ext4 - from what
I've seen it seems like those kernels should have the vast majority of
stability bugs fixed in them.  Last I remember reading the 2.6.27
doesn't quite have all the fixes due to difficulties in backporting
those fixes to that kernel.

-Dave
