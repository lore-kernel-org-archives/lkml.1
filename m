Return-Path: <linux-kernel-owner+w=401wt.eu-S1759398AbXETPym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759398AbXETPym (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 11:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757282AbXETPyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 11:54:35 -0400
Received: from wx-out-0506.google.com ([66.249.82.227]:12044 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757119AbXETPye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 11:54:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=SWK9zW//4XRf5GrxhS1teEyUNZ9qa4+i16GMISkGY3u0wdWDc2Nqj2Xwshq7uh4eLfL/x+nwXgcI+gWfgU+V+RMiplq8qW11iBI0H6cShawc75o++iXGnP/VKUPd+ztjMKM+HQFqHjTC+L/cVt1PstFwUuAx2jBttCNvSdMaFw8=
Message-ID: <3ae72650705200854x6a2c829fueff3652653fc21da@mail.gmail.com>
Date: Sun, 20 May 2007 17:54:32 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Ray Lee" <ray-lk@madrabbit.org>
Subject: Re: bug in 2.6.22-rc2: loop mount limited to one single iso image
Cc: "Al Viro" <viro@ftp.linux.org.uk>, "Andrey Borzenkov" <arvidjaar@mail.ru>,
       "Uwe Bugla" <uwe.bugla@gmx.de>, "Ken Chen" <kenchen@google.com>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
In-Reply-To: <2c0942db0705200822j685ec3b2x399a080622b6fc05@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <464F42F3.1080300@madrabbit.org>
	 <20070519191751.E51233A23A2@muan.mtu.ru>
	 <200705200124.13026.uwe.bugla@gmx.de>
	 <200705200845.43621.arvidjaar@mail.ru>
	 <2c0942db0705192316s2682807chd23df6f4de29edcb@mail.gmail.com>
	 <20070520062816.GA4095@ftp.linux.org.uk>
	 <2c0942db0705200822j685ec3b2x399a080622b6fc05@mail.gmail.com>
X-Google-Sender-Auth: e65fecff35dc18b9
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/20/07, Ray Lee <ray-lk@madrabbit.org> wrote:
> On 5/19/07, Al Viro <viro@ftp.linux.org.uk> wrote:
> > On Sat, May 19, 2007 at 11:16:59PM -0700, Ray Lee wrote:
> > > Ken? Ball's in your court. As the patch isn't providing a killer
> > > feature for 2.6.22, I'd suggest just reverting it for now until the
> > > issues are ironed out.
> >
> > Hold it.  The real question here is which logics do we want there.
> > IOW, and how many device nodes do we want to appear and _when_ do
> > we want them to appear?
>
> The when part is what looks to make it racy. I'm guessing that we're
> relying on udev to create those loop nodes. If so, I think any scheme
> that creates more on demand would give transient mount errors while
> it's waiting on udev to create more nodes.
>
> Perhaps if we were to start with 8 loop nodes at init (as we have in
> 2.6.21), and then always maintain a margin of 8 (or 4, or...) when
> they start being used or detached?
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Until the tools can request dynamic loop device allocation from the
kernel before they want to use the device, you can create as many as
needed "static" loop* nodes in /lib/udev/devices/, which will be
copied to /dev/ early on every bootup.

Kay
