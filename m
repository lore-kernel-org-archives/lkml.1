Return-Path: <linux-kernel-owner+w=401wt.eu-S1754886AbZKIM7L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbZKIM7L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 07:59:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751420AbZKIM7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 07:59:11 -0500
Received: from smtp-out.google.com ([216.239.33.17]:46831 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbZKIM7K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 07:59:10 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=hsakocHtDvy6wikHbCVQpwcMT04tiS4Fprl/EE9ADbf6CUyRunUV7X5ODCQq93k7p
	b+uZXQP2i+EswZ7SvhidA==
MIME-Version: 1.0
In-Reply-To: <20091109103602.GC2207@elf.ucw.cz>
References: <20091109103602.GC2207@elf.ucw.cz>
Date: Mon, 9 Nov 2009 04:59:10 -0800
Message-ID: <a55d774e0911090459q2e373b5bw9f4fafe71e631c70@mail.gmail.com>
Subject: Re: dream: fastboot getting protocol errors
From: Brian Swetland <swetland@google.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Arve Hj?nnev?g" <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 9, 2009 at 2:36 AM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
> I'm still fighting with porting MMC support to current mainline.
>
> Meanwhile: I'm getting this *way* too often -- with the htcUSB  to
> 2xUSB reduction. Any ideas?
>
> root@amd:/data/l/android# ./fastboot -c "console=tty0
> root=/dev/mmcblk0p1 rootdelay=5 fbcon=rotate:1" boot
> /data/l/linux-msm/arch/arm/boot/zImage
> creating boot image...
> creating boot image - 1667072 bytes
> downloading 'boot.img'... FAILED (command write failed (Protocol
> error))
> root@amd:/data/l/android#
>
> ...and then it just goes away after powercycling the phone...

Unfortunately, I think that's just flakies in the htc bootloader.  I'm
not aware of any simple workaround.  Do you not see it fail if you use
a straight USB A->miniB cable?

I think that bootloader will still honor a secondstage bootloader
embedded in the boot.img (mkbootimg --second foo), or you could
replace the zimage in the boot.img with a second stage bootloader.
Either way, dunno if you want to dig into bootloader hackery to try to
resolve usb issues.

Brian
