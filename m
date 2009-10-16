Return-Path: <linux-kernel-owner+w=401wt.eu-S1751306AbZJPWlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751306AbZJPWlU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 18:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750897AbZJPWlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 18:41:19 -0400
Received: from mail-gx0-f216.google.com ([209.85.217.216]:50070 "EHLO
	mail-gx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbZJPWlT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 18:41:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=R9tpr9SIPCmIiq//5wwEVYJogADXftxiDNbRuGNpbHorGSzpbwlbcbs+r/jF/b0NS5
         hikPzgnpyFnbp+FQ3jz2wExwfXkKe9VR6IwcjxPUVr3qj6dH8BbsFiu78B9YuDOgpQ2b
         B6zbU9EpI+PnVnnyIeUL4iGmyFo++c4xuO/ZQ=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0910161741110.11211@p34.internal.lan>
References: <alpine.DEB.2.00.0910161741110.11211@p34.internal.lan>
Date: Fri, 16 Oct 2009 15:36:13 -0700
Message-ID: <b1bc6a000910161536j2f9e273dy84b3d4f5098ff0d4@mail.gmail.com>
Subject: Re: 3ware 9650SE-4PML RAID-1 Question: One reader process starves I/O 
	to the rest of the system?
From: adam radford <aradford@gmail.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin,

Can you try turning down the queue depth of the disk that is getting
written to to see if that resolves your responsiveness issue?

I.E.:     echo "16" > /sys/block/sdX/device/queue_depth

(replace X with disk letter of device from /raid6 mountpoint).

FYI:   It's probably better to send questions like this to linux-scsi rather
         than linux-kernel.

-Adam

On Fri, Oct 16, 2009 at 2:46 PM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> Hello,
>
> I tried CFQ/deadline schedulers, when I run the following:
>
> # /usr/bin/time dd if=/dev/sdb2 of=/raid6/sdb2.img
>
> Behind which are 2 x Raptor 150GB disks, the system is pretty much unusable
> when I control-c the dd, it comes back to life.
>
> The RAID-6 is a 15-disk RAID-6 which does 600-700MB/s writes.
>
> All cards are on PCI-e and have adequate bandwidth on a P55 board (DP55KG).
>
> Are there any recommended tuning options for a RAID-1 configuration, such
> that
> a heavy I/O read or write operation does not pause the system?
>
> During the dd..
>
> Drive Performance Monitor Configuration for /c1 ...
> Performance Monitor: ON
> Version: 1
> Max commands for averaging: 100
> Max latency commands to save: 10
> Requested data: Instantaneous Drive Statistics
>
>                               Queue           Xfer         Resp
> Port   Status           Unit   Depth   IOPs    Rate(MB/s)   Time(ms)
> ------------------------------------------------------------------------
> p0     OK               u0     25      762     26.219       19 p1     OK
>           u0     23      780     25.953       24 p2     OK               u1
>     1       0       0.000        98 p3     NOT-PRESENT      -      -       -
>       -            -
>
> Justin.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
