Return-Path: <linux-kernel-owner+w=401wt.eu-S1752879Ab0AGOgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab0AGOgx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 09:36:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752590Ab0AGOgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 09:36:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752583Ab0AGOgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 09:36:51 -0500
Date: Thu, 7 Jan 2010 09:36:40 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Kirill Afonshin <kirill_nnov@mail.ru>, Jeff Moyer <jmoyer@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Shaohua Li <shaohua.li@intel.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH] cfq-iosched: non-rot devices do not need read queue
	merging
Message-ID: <20100107143640.GB7664@redhat.com>
References: <4e5e476b1001051348y4637986epb9b56958c738061a@mail.gmail.com> <E1NSq2i-0000wY-00.kirill_nnov-mail-ru@foot.mail.ru> <4e5e476b1001070538y35143cc8me7443f3eb0d377@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e5e476b1001070538y35143cc8me7443f3eb0d377@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 07, 2010 at 02:38:29PM +0100, Corrado Zoccolo wrote:
> Hi Kirill,
> NCQ is actually measured, so it is reliable.
> Rotational can be wrong, but you can write to it (e.g. at machine
> startup) to obtain better handling of your disks.
> I am also a fan of auto-tuning, and trying to achieve it in cfq, but
> it is kind of complex, since there are many factors, and some of them
> aren't modeled by cfq currently.
> An example is that, on cheap SSDs or flash cards, small writes are far
> slower than anything else (they can take up to 0.5s), while a read
> will usually take less than 1ms. Currently, CFQ has no way to handle
> this extreme situation, since it uses just one idle value (8ms) for
> all transitions.

Hi Corrado, 

How does idle time value relate to flash card being slower for writes? If
flash card is slow and we choose to idle on queue (because of direct
writes), idle time value does not even kick in. We just continue to remain
on same cfqq and don't do dispatch from next cfqq.

Idle time value will matter only if there was delay from cpu side or from
workload side in issuing next request after completion of previous one.

Thanks
Vivek

> 
> Corrado
> 
> On 1/7/10, Kirill Afonshin <kirill_nnov@mail.ru> wrote:
> > I think we should not rely on NCQ/non-NCQ or blk_queue_nonrot() because it
> > may be incorrect:
> > try this:
> >
> > find /sys/ -name rotational 2>/dev/null
> > find /sys/ -name rotational 2>/dev/null|xargs cat
> >
> > all devices are reported as rotational for me including ram, loop and usb
> > flash drive. Physical block size and optimal io size has invalid values for
> > all my usb flash drives.
> >
> > I think it would be better to do a short performance test before mount. It
> > will provide all necessary information for io scheduler. We doesn't need
> > information about NCQ and rotational. We need to predict how much time
> > specific io operation will take in current context.
> >
> > PS: I'm not native speaker.
> >
> > Best regards,
> > Kirill Afonshin
> >
