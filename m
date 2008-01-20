Return-Path: <linux-kernel-owner+w=401wt.eu-S1753635AbYATMH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635AbYATMH3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 07:07:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbYATMHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 07:07:20 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:20690 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbYATMHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 07:07:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IjOOYWAKNdp4pZjlnvSEX7464Zf53VvTNBqAu0RI9NYcWe0VXhOZAt92mXAg/Zhl9fPf6jJNhPDxktKxjcXXmI/wSfPurok06w4XKpWqSYS/8sjXz3ymHQS5iIWZiaiYJajhSoa2ITvLXXw0N8pw4fQg0lGCOQ082Ev0sJDST2k=
Message-ID: <36ca99e90801200407h384106f7pc1ce37e8b34ad7ec@mail.gmail.com>
Date: Sun, 20 Jan 2008 13:07:17 +0100
From: "Bert Wesarg" <bert.wesarg@googlemail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: [PATCH 2/6] typesafe: kthread_create and kthread_run
Cc: "Rusty Russell" <rusty@rustcorp.com.au>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Jeff Garzik" <jeff@garzik.org>,
       "Tejun Heo" <htejun@gmail.com>
In-Reply-To: <Pine.LNX.4.64.0801201223590.14598@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200801202046.14746.rusty@rustcorp.com.au>
	 <200801202047.22943.rusty@rustcorp.com.au>
	 <200801202048.34796.rusty@rustcorp.com.au>
	 <Pine.LNX.4.64.0801201223590.14598@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 20, 2008 12:25 PM, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>
> On Jan 20 2008 20:48, Rusty Russell wrote:
> >+ */
> >+#define kthread_create(threadfn, data, namefmt...) ({         \
> >+      int (*_threadfn)(typeof(data)) = (threadfn);            \
> >+      __kthread_create((void *)_threadfn, (data), namefmt);   \
> >+})
>
> If you have namefmt... you need that varagrs cpp trick. IIRC:
>
>         __kthread_create((void *)_threadfn, (data), namefmt, __VA_ARGS__);
almost

either:

#define kthread_create(threadfn, data, ...) ({         \
        __kthread_create((void *)_threadfn, (data), __VA_ARGS__);

or:

#define kthread_create(threadfn, data, namefmt, ...) ({         \
        __kthread_create((void *)_threadfn, (data), namefmt, ##__VA_ARGS__);


Bert
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
