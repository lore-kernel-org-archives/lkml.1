Return-Path: <linux-kernel-owner+w=401wt.eu-S1757410AbZJEAVI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410AbZJEAVI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 20:21:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755161AbZJEAVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 20:21:07 -0400
Received: from mail-yw0-f173.google.com ([209.85.211.173]:49548 "EHLO
	mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332AbZJEAVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 20:21:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=IooUQupJuyvvmKVR3gqZG/MSYY9v8P5cFRC0GDFU5Drua/13stxL68ApRfhlkG10L7
         v7KRxNWPbD65sbTqQGoYXCS6A0aq2mpFGfNmJed4Bppp0hVDak0ioYf1q8aFV1vPclPg
         5X2UuZmQm8AiEAqKcIM6DzEFg0MBidQJ3ouvY=
MIME-Version: 1.0
In-Reply-To: <20091004174535.777d233c.kristoffer.ericson@gmail.com>
References: <20090924121617.c0c7222d.kristoffer.ericson@gmail.com>
	 <4ABBB9D3.4020200@gmail.com> <200909242155.49890.s.L-H@gmx.de>
	 <4ABBD170.6060702@gmail.com>
	 <20091004174535.777d233c.kristoffer.ericson@gmail.com>
Date: Sun, 4 Oct 2009 17:20:28 -0700
Message-ID: <dd18b0c30910041720r3af58c27ve139a3511aba7aee@mail.gmail.com>
Subject: Re: Disassociating atheros wlan with 2.6.31
From: Justin Mattock <justinmattock@gmail.com>
To: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Cc: Stefan Lippers-Hollmann <s.L-H@gmx.de>, linux-wireless@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 4, 2009 at 8:45 AM, Kristoffer Ericson
<kristoffer.ericson@gmail.com> wrote:
> Hi,
>
> Did a bisect or more exactly tried to do a bisect. Ive managed to bisect myself
> into a deadend so far (must have marked good in wrong place). The disassociation happens
> at seemingly regular intervalls but once I started bisecting it started
> to be more irregular. Perhaps it was simply due to me not being able
> to user internet (and share) since my 3G modem oopsed all the time.
> Suspecting its load sensitive.
>
well, as easy as it seems I did at one point forget what was good/bad
on a bisect a few weeks ago.(hey your human).

> Anyhow heres what I got so far. The bad versions should be correct
> while the good versions might not be. Reason being that I didnt wait
> long enough for the disassociation to appear and thus faulty marking
> something as good.
> Using the bad should however narrow it down somewhat. From what
> I can see between my last good and bad is only non-related stuff,
> so must be atleast one "good" mistake in there.
>
> git bisect start
> # good: [07a2039b8eb0af4ff464efd3dfd95de5c02648c6] Linux 2.6.30
> git bisect good 07a2039b8eb0af4ff464efd3dfd95de5c02648c6
> # bad: [74fca6a42863ffacaf7ba6f1936a9f228950f657] Linux 2.6.31
> git bisect bad 74fca6a42863ffacaf7ba6f1936a9f228950f657
> # good: [925d74ae717c9a12d3618eb4b36b9fb632e2cef3] V4L/DVB (11736): videobuf: modify return value of VIDIOC_REQBUFS ioctl
> git bisect good 925d74ae717c9a12d3618eb4b36b9fb632e2cef3
> # bad: [a380137900fca5c79e6daa9500bdb6ea5649188e] ixgbe: Fix device capabilities of 82599 single speed fiber NICs.
> git bisect bad a380137900fca5c79e6daa9500bdb6ea5649188e
> # bad: [1dbb5765acc7a6fe4bc1957c001037cc9d02ae03] Staging: android: lowmemorykiller: fix up remaining checkpatch warnings
> git bisect bad 1dbb5765acc7a6fe4bc1957c001037cc9d02ae03
> # bad: [2b1b62e841867326fa260a581d97941c32abc35b] MIPS: Cavium-Octeon: Add more board type constants.
> git bisect bad 2b1b62e841867326fa260a581d97941c32abc35b
> # good: [517d08699b250021303f9a7cf0d758b6dc0748ed] Merge branch 'akpm'
> git bisect good 517d08699b250021303f9a7cf0d758b6dc0748ed
> # good: [5e2c217eee18a4627a32c49f57f47dbac67dcf23] V4L/DVB (11958): usbvision-core.c: vfree does its own NULL check
> git bisect good 5e2c217eee18a4627a32c49f57f47dbac67dcf23
> # bad: [a9349315f65cd6a16e8fab1f6cf0fd40f379c4db] V4L/DVB (11819): Siano: smscore - fix get_common_buffer bug
> git bisect bad a9349315f65cd6a16e8fab1f6cf0fd40f379c4db
> # good: [06f837cadbcdedb45f0702cb57c99c404ae921e6] V4L/DVB (11784): cx88: Fix race condition between cx8800 startup and hald
> git bisect good 06f837cadbcdedb45f0702cb57c99c404ae921e6
> # good: [1339f9108a84710969903e892dcf1849ae1215cf] V4L/DVB (11726): Modify the file license to match all other Siano's files
> git bisect good 1339f9108a84710969903e892dcf1849ae1215cf
>
> Best wishes
> Kristoffer Ericson
>

When I get a chance I can try a bisect and see.
If you decide to redu and come up with a specific
commit then I guess well go from there.

-- 
Justin P. Mattock
