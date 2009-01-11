Return-Path: <linux-kernel-owner+w=401wt.eu-S1752395AbZAKTrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395AbZAKTrr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 14:47:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752782AbZAKTrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 14:47:23 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:52704 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355AbZAKTrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 14:47:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=NCxBa3JksZcEPQsfnO4IsYKKHpVuZsRq1KtivbvnZajPwHXQr+fveJs/WLrI2Jb0yN
         KJL1kQDUmlnpGtlVPhpyjQX6XsBHLTwiP+Qxja+IMyTvt+5qL2ekDEBnDUbp5KpW+jZI
         yp8OKY4Hw8jAFFx4ZwAwP6dO7ugLt+pxHcX2A=
Message-ID: <f19298770901111147t625a2161t779bfcfc0317225c@mail.gmail.com>
Date: Sun, 11 Jan 2009 22:47:18 +0300
From: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: current git kernel has strange problems during bisect
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Christian Borntraeger" <borntraeger@de.ibm.com>,
       "Johannes Schindelin" <Johannes.Schindelin@gmx.de>, git@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090111194258.GA4840@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200901111602.53082.borntraeger@de.ibm.com>
	 <200901111607.59054.borntraeger@de.ibm.com>
	 <alpine.DEB.1.00.0901111613250.3586@pacific.mpi-cbg.de>
	 <200901111620.03345.borntraeger@de.ibm.com>
	 <alpine.LFD.2.00.0901111113150.6528@localhost.localdomain>
	 <20090111194258.GA4840@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2009 at 22:42, Sam Ravnborg <sam@ravnborg.org> wrote:
>>
>> For bisect, it's indeed somewhat annoying, and we could have perhaps done
>> some things a bit differently, but it's about the closest you can get to
>> "real history" without making the first btrfs merge-point a _total_
>> disaster.
>>
>> For bisect purposes, if you know you're not chasing down a btrfs issue,
>> you can do
>>
>>       git bisect good 34353029534a08e41cfb8be647d734b9ce9ebff8
>>
>> where that commit 34353029 is the last one which has _just_ the btrfs
>> files. The next commit is when it does "Merge Btrfs into fs/btrfs", and
>> that one has the whole kernel tree again.
>
> The cost of moving this piece of history from one git tree to another
> git tree is that we make it harder to debug the kernel for the advanced user
> that knows how to do bisect.

And wasn't is trivial to avoid? Just exporting the commits as
patches and importing them into the kernel tree would preserve
the history, and not break bisection.
