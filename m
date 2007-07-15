Return-Path: <linux-kernel-owner+w=401wt.eu-S1760271AbXGOLSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760271AbXGOLSt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 07:18:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758068AbXGOLSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 07:18:39 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:50848 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757660AbXGOLSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 07:18:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=twwob4EUBU3HDitjh8YSQ/wVn5ePZQmCbNuDaYxhUlMyy3AQ8u0kwvzm97y9+y3LPP4BYCYKc5nGtCxjK43ZZRAvYPNaqfvZVPvZuHyQDTkYErnyjdYXK5GfvbMmVVd4wWqnhFNTqW47tvksI1Ti5gk7Mc3GRDaN09cBcYz5OGI=
Message-ID: <a781481a0707150418o35e4d60fs59cba3f835ebef67@mail.gmail.com>
Date: Sun, 15 Jul 2007 16:48:37 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Timo Lindemann" <tlindemann@arcor.de>
Subject: Re: PROBLEM: kernel hang in ohci init
Cc: "David Brownell" <david-b@pacbell.net>, linux-kernel@vger.kernel.org
In-Reply-To: <4699F9CB.5010407@arcor.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4695EC25.6050003@arcor.de>
	 <a781481a0707122015q48fd8a06m5d0e54b109708757@mail.gmail.com>
	 <200707122040.36800.david-b@pacbell.net> <4699F9CB.5010407@arcor.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/15/07, Timo Lindemann <tlindemann@arcor.de> wrote:
> David Brownell wrote:
> > On Thursday 12 July 2007, Satyam Sharma wrote:
> >
> > Note that hangs in that file almost always mean "your BIOS is goofy".
> > Hunt for BIOS settings related to USB, and change them.
> This laptop's BIOS only offers "legacy support" enabled or disabled,
> both of which lead to frozen kernel. I will investigate whether the GIT
> tree freezes at the same point.

Perhaps you could try updating your BIOS, if possible / applicable (?)

> >>> after this, kernel apparently goes into busy waiting (fans gradually
> >>> turn louder) and hangs indefinitely. I have also made sure that writel
> >>> (in linux/include/asm/io.h) really is entered, but never returns.
> >
> > Does the current kernel.org GIT tree do the same thing?  A bunch
> > of USB patches were recently merged, including ISTR one in that
> > area ...
> It does the same thing, git5, that is. Sorry I took so long, but I didnt
> get to testing this earlier.
>
> It is just odd that up to (not including) the 2.6.21-series every kernel
> boots, and after that, they just freeze.
>
> I am kinda stumped here.

Hey, just try git-bisect already :-)

In fact, you can first try by just reverting / un-applying that patch that
you initially had a suspicion on. Or, because you've already spent
some time tracking down the issue, you could simply go through the
git history of that file / subsystem in question and play around reverting
individual patches that you find suspicious -- but really, there's no need
to try and be cute with this: you could simply do a git-bisect (say
between 2.6.20 and 2.6.21) and find the offending patch (or at least the
one that un-hides the bug) that makes the boot fail ...

[ BTW you haven't sent your dmesg / boot-time output ... if it isn't
getting saved to disk, you could try serial / netconsole, copy it by
hand, or simply take a photo and post it here. ]

Cheers,
Satyam
