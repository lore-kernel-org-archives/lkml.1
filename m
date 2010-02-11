Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744Ab0BKALH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 19:11:07 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:46680 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755805Ab0BKALC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 19:11:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=h5pbmsAl7r7Ibw4x6/Y882vEeRauzutVy7A97dXmQXqqlBRlKrfHacTZXgn+F3vaRE
         O3Csre3VwvjQwPOpT0AfLSkeQ1TNAJtrOY6TDbYW5n4Xet3Seb1Ys6rbxJN5YhXgjABM
         bd5Bo448cWXEdcj7KUKPXG1bfg6vfTq8ER2Ag=
MIME-Version: 1.0
In-Reply-To: <201002110140.16122.mihai.dontu@gmail.com>
References: <201002110140.16122.mihai.dontu@gmail.com>
Date: Thu, 11 Feb 2010 00:11:00 +0000
Message-ID: <74fd948d1002101611i7486e700gbbaf420d95203394@mail.gmail.com>
Subject: Re: slow resume from suspend to disk
From: Pedro Ribeiro <pedrib@gmail.com>
To: =?UTF-8?B?TWloYWkgRG9uyJt1?= <mihai.dontu@gmail.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 February 2010 23:40, Mihai Donțu <mihai.dontu@gmail.com> wrote:
> Hi,
>
> Is there any way to speed up the resume from suspend to disk? Currently, on my
> laptop it suspends in ~15s (wrote about 360MB) but resumes in ~120s and after
> that I'm still left with ~361MB in swap:
>
>             total       used       free     shared    buffers     cached
> Mem:       3333472    1139332    2194140          0      12808     473084
> -/+ buffers/cache:     653440    2680032
> Swap:      2104472     369428    1735044
>
> Right now I'm better off with a cold boot.
>
> Although I did not study the kernel code to see how things really work, I
> suspect on resume only necessary kernel data is loaded from swap and the
> userland tasks are left with the page fault mechanism to bring back their own
> data, which leads to an I/O storm on the swap device. Maybe changing the I/O
> scheduler from CFQ would help? or better yet, is there any way to tell the
> kernel to bring back all the pages from swap in one quick move? That would be
> something I want to put in my resume scripts.
>
> $ uname -a
> Linux mdontu-dell 2.6.32-gentoo-r3 #1 SMP PREEMPT Mon Feb 1 02:36:01 EET 2010
> x86_64 Intel(R) Core(TM)2 CPU T5500 @ 1.66GHz GenuineIntel GNU/Linux
>
> I've installed Windows XP just for a test, started a few apps (like visual
> studio, mplayer, etc.) and then suspended/hibernated (~15s). It took roughly
> 15s to come back.
>
> Thanks,
>
> PS: I'm editing this e-mail as I do tests and I just noticed that my /sbin
> directory is empty. rmmod is there and I needed it to reload the b43 driver
> which generally does not feel well after a suspend/resume. A reboot fixed it.
> Weird ...
>
> --
> Mihai Donțu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

If you know how to patch and compile a kernel, try http://www.tuxonice.net/
I find it way faster and more reliable than the in-kernel hibernation.

You also need to install at least the hibernate script, since it is
way better for hibernation that pm-utils which most distros use.

Ubuntu and some other distros have binary kernels already patched and
the hibernate script packaged.

Regards,
Pedro
