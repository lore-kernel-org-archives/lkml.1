Return-Path: <linux-kernel-owner+w=401wt.eu-S1752403Ab0AGNic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403Ab0AGNic (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 08:38:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752118Ab0AGNib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 08:38:31 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:57540 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056Ab0AGNia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 08:38:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=wBKUqIUyOpADXL3zDNSYbuMdhz3A1rij1JCyOKYcqxlC8JlQebD3oGYPVtfOLVTE4o
         jK7o+fhBPrbZT113PHB+0eW4hD5z5RLCxqiBJy1J55zCwTRUIBixUPhZLrnKv0NsiKJ1
         czLywOSrwCDGTDL3DQk6tprOU2shW3syUt24w=
MIME-Version: 1.0
In-Reply-To: <E1NSq2i-0000wY-00.kirill_nnov-mail-ru@foot.mail.ru>
References: <4e5e476b1001051348y4637986epb9b56958c738061a@mail.gmail.com>
	 <E1NSq2i-0000wY-00.kirill_nnov-mail-ru@foot.mail.ru>
Date: Thu, 7 Jan 2010 14:38:29 +0100
Message-ID: <4e5e476b1001070538y35143cc8me7443f3eb0d377@mail.gmail.com>
Subject: Re: [PATCH] cfq-iosched: non-rot devices do not need read queue 
	merging
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Kirill Afonshin <kirill_nnov@mail.ru>
Cc: Jeff Moyer <jmoyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Shaohua Li <shaohua.li@intel.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kirill,
NCQ is actually measured, so it is reliable.
Rotational can be wrong, but you can write to it (e.g. at machine
startup) to obtain better handling of your disks.
I am also a fan of auto-tuning, and trying to achieve it in cfq, but
it is kind of complex, since there are many factors, and some of them
aren't modeled by cfq currently.
An example is that, on cheap SSDs or flash cards, small writes are far
slower than anything else (they can take up to 0.5s), while a read
will usually take less than 1ms. Currently, CFQ has no way to handle
this extreme situation, since it uses just one idle value (8ms) for
all transitions.

Corrado

On 1/7/10, Kirill Afonshin <kirill_nnov@mail.ru> wrote:
> I think we should not rely on NCQ/non-NCQ or blk_queue_nonrot() because it
> may be incorrect:
> try this:
>
> find /sys/ -name rotational 2>/dev/null
> find /sys/ -name rotational 2>/dev/null|xargs cat
>
> all devices are reported as rotational for me including ram, loop and usb
> flash drive. Physical block size and optimal io size has invalid values for
> all my usb flash drives.
>
> I think it would be better to do a short performance test before mount. It
> will provide all necessary information for io scheduler. We doesn't need
> information about NCQ and rotational. We need to predict how much time
> specific io operation will take in current context.
>
> PS: I'm not native speaker.
>
> Best regards,
> Kirill Afonshin
>
