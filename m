Return-Path: <linux-kernel-owner+w=401wt.eu-S1751344AbXBMWWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751344AbXBMWWi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 17:22:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751348AbXBMWWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 17:22:38 -0500
Received: from mail02.syd.optusnet.com.au ([211.29.132.183]:44393 "EHLO
	mail02.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751344AbXBMWWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 17:22:37 -0500
From: Con Kolivas <kernel@kolivas.org>
To: malc <av1474@comtv.ru>
Subject: Re: CPU load
Date: Wed, 14 Feb 2007 09:08:44 +1100
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
References: <loom.20070212T063225-663@post.gmane.org> <20070212143219.GB5226@ucw.cz> <Pine.LNX.4.64.0702140059390.727@home.oyster.ru>
In-Reply-To: <Pine.LNX.4.64.0702140059390.727@home.oyster.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702140908.44934.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 February 2007 09:01, malc wrote:
> On Mon, 12 Feb 2007, Pavel Machek wrote:
> > Hi!
> >
> >> The kernel looks at what is using cpu _only_ during the
> >> timer
> >> interrupt. Which means if your HZ is 1000 it looks at
> >> what is running
> >> at precisely the moment those 1000 timer ticks occur. It
> >> is
> >> theoretically possible using this measurement system to
> >> use >99% cpu
> >> and record 0 usage if you time your cpu usage properly.
> >> It gets even
> >> more inaccurate at lower HZ values for the same reason.
> >
> > I have (had?) code that 'exploits' this. I believe I could eat 90% of cpu
> > without being noticed.
>
> Slightly changed version of hog(around 3 lines in total changed) does that
> easily on 2.6.18.3 on PPC.
>
> http://www.boblycat.org/~malc/apc/load-hog-ppc.png

I guess it's worth mentioning this is _only_ about displaying the cpu usage to 
userspace, as the cpu scheduler knows the accounting of each task in 
different ways. This behaviour can not be used to exploit the cpu scheduler 
into a starvation situation. Using the discrete per process accounting to 
accumulate the displayed values to userspace would fix this problem, but 
would be expensive.

-- 
-ck
