Return-Path: <linux-kernel-owner+w=401wt.eu-S1754884AbYATQnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884AbYATQnu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 11:43:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754290AbYATQnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 11:43:42 -0500
Received: from py-out-1112.google.com ([64.233.166.178]:28310 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287AbYATQnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 11:43:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Dh1B0apFdYt7Pnl6nGeV5LU7SkQZgvGlx/p32xEM4+BWgoey8CpLtbjhcz/FLSX5Ie9XdzGfado/kUR1UWfyuNOrMgvtB6YyKhW6Nv6TJ+jpElrCmap6ApvLqPNdYrnlzSoou31SNu9XfKkxRQ/O51+cUoo7e2Xgayn29ac+fKM=
Message-ID: <36ca99e90801200843p7f45ef6ay281b5e77848f6d32@mail.gmail.com>
Date: Sun, 20 Jan 2008 17:43:40 +0100
From: "Bert Wesarg" <bert.wesarg@googlemail.com>
To: "Johannes Weiner" <hannes@saeurebad.de>
Subject: Re: [PATCH 2/6] typesafe: kthread_create and kthread_run
Cc: "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Rusty Russell" <rusty@rustcorp.com.au>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Jeff Garzik" <jeff@garzik.org>,
       "Tejun Heo" <htejun@gmail.com>
In-Reply-To: <87ve5otqgl.fsf@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200801202046.14746.rusty@rustcorp.com.au>
	 <200801202047.22943.rusty@rustcorp.com.au>
	 <200801202048.34796.rusty@rustcorp.com.au>
	 <Pine.LNX.4.64.0801201223590.14598@fbirervta.pbzchgretzou.qr>
	 <36ca99e90801200407h384106f7pc1ce37e8b34ad7ec@mail.gmail.com>
	 <87ve5otqgl.fsf@saeurebad.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 20, 2008 5:24 PM, Johannes Weiner <hannes@saeurebad.de> wrote:
> Hi,
>
> "Bert Wesarg" <bert.wesarg@googlemail.com> writes:
>
> > On Jan 20, 2008 12:25 PM, Jan Engelhardt <jengelh@computergmbh.de> wrote:
> >>
> >> On Jan 20 2008 20:48, Rusty Russell wrote:
> >> >+ */
> >> >+#define kthread_create(threadfn, data, namefmt...) ({         \
> >> >+      int (*_threadfn)(typeof(data)) = (threadfn);            \
> >> >+      __kthread_create((void *)_threadfn, (data), namefmt);   \
> >> >+})
> >>
> >> If you have namefmt... you need that varagrs cpp trick. IIRC:
> >>
> >>         __kthread_create((void *)_threadfn, (data), namefmt, __VA_ARGS__);
> > almost
> >
> > either:
> >
> > #define kthread_create(threadfn, data, ...) ({         \
> >         __kthread_create((void *)_threadfn, (data), __VA_ARGS__);
> >
>
> No.  This is bad because it gives the impression that it takes only two
> essential arguments which is not the case.
Right, I just forget to mention this in a comment.
>
> > or:
> >
> > #define kthread_create(threadfn, data, namefmt, ...) ({         \
> >         __kthread_create((void *)_threadfn, (data), namefmt, ##__VA_ARGS__);
> >
>
> This is better.  I prefer naming the rest args instead of using __VA_ARGS__:
>
> #define kthread_create(threadfn, data, namefmt, fmtargs...) ({ \
>         ... \
>         __kthread_create((void *)_threadfn, (data), namefmt, ## fmtargs) \
> })
>
> but I think that is just a matter of taste.
No, it is a matter of conforming to C99 or to GNU extensions.

Bert
>
>         Hannes
>
