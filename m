Return-Path: <linux-kernel-owner+w=401wt.eu-S1751111AbXEXN47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751111AbXEXN47 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 09:56:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750705AbXEXN4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 09:56:52 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:13185 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbXEXN4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 09:56:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=IojC+dcoinnyFPgWmhSkng8USAEXRMndOp9awUfoSRAd+Rnxa8wJc/jyFFDM8Znsl9KZQg/ryt1v4sgOUKdyY6ZKxVDVKclZFreg5aIgwoTEXxPkhnU8xevm6GVuUaMcDm8SQi7xGwoZSB1fMNWJemrQsW+e4wzNcV1viYQm81U=
Message-ID: <2c0942db0705240656k7d7e4e47r9c43168cc4cecf49@mail.gmail.com>
Date: Thu, 24 May 2007 06:56:49 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Romano Giannetti" <romanol@upcomillas.es>
Subject: Re: 2.6.21.1 fails to suspend/resume to disk (sort of)
Cc: "Antonino Ingargiola" <tritemio@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1180008823.15600.35.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1179905115.7043.25.camel@localhost>
	 <200705231105.08408.rjw@sisk.pl> <1179914262.7043.56.camel@localhost>
	 <5486cca80705240101u2fb6a954q53025752560f3ef7@mail.gmail.com>
	 <1180008823.15600.35.camel@localhost>
X-Google-Sender-Auth: a1328265ab582c70
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/24/07, Romano Giannetti <romanol@upcomillas.es> wrote:
> On Thu, 2007-05-24 at 10:01 +0200, Antonino Ingargiola wrote:
> > 2007/5/23, Romano Giannetti <romano.giannetti@gmail.com>:
> > [cut]
> > > Uf, I will try to find the time. I am on my way to try to compile
> > > 2.6.21.2 now. Problem is that a kernel compile "the ubuntu way" last
> > > hours here. If there is an expert on make-kpkg here, I could use some
> > > advise.
>
>
> > Is not the ubuntu or debian way to take hours to compile. Is that you
> > have to trim the config and enable the only modules you need for your
> > hardware, then a rebuild cycle could last 10-15 min.
>
> That is a problem, yes. But I was referring to the need of a make-kpkg
> clean every time you recompile changing the EXTRAVERSION, wich forces a
> make clean. I am trying to discover how to build manually and initramfs
> that works...

Yeah, the make-kpkg clean is highly annoying, and eventually made me
give up on using that tool. Instead, I've been using the deb-pkg
target that ships with the kernel. When bisecting, I use a script like
the one below to test a new kernel with a minimum of interaction. It
should give you a good idea of how to do all the steps by hand.

And yeah, paring down the .config is critical :-).

#!/bin/bash
sudo -v
make oldconfig
fakeroot make -j2 deb-pkg
sudo dpkg -i ../linux-2.6.20_2.6.20_amd64.deb
sudo update-initramfs -c -k 2.6.20
