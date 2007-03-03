Return-Path: <linux-kernel-owner+w=401wt.eu-S1030419AbXCCVM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030419AbXCCVM4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 16:12:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030426AbXCCVM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 16:12:56 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:17792 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030419AbXCCVMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 16:12:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Hu8Q7MNstGWlhroXBG0ccduNL0J6xe/9Xp6xHkyusI7+QCyLB1+cWY/Bl+zIqJA6BYJKLSwDFMasbldawhN8Z0qbRl7bUDgcd3zDy/IStAU6Zgcs/EFa6CXVswyTh1ngJdo8WcjSMNtz46Y/iFj1bSM4okinObxXGlJgHWM5qek=
Message-ID: <2c0942db0703031312g15726e69gcce7a1d0b955ab76@mail.gmail.com>
Date: Sat, 3 Mar 2007 13:12:53 -0800
From: "Ray Lee" <madrabbit@gmail.com>
Reply-To: ray-gmail@madrabbit.org
To: "Ihar `Philips` Filipau" <thephilips@gmail.com>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Cc: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>, linux-kernel@vger.kernel.org
In-Reply-To: <efa6f5910703030258ne76cd8as8a3900fc22456a91@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <efa6f5910703021120ia0b8d18ne0c806eb2e73da4c@mail.gmail.com>
	 <20070303103427.GC22557@2ka.mipt.ru>
	 <efa6f5910703030258ne76cd8as8a3900fc22456a91@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/3/07, Ihar `Philips` Filipau <thephilips@gmail.com> wrote:
> What I'm trying to get to: keep things simple. The proposed
> optimization by Ingo does nothing else but allowing AIO to probe file
> cache - if data there to go with fast path. So why not to implement
> what the people want - probing of cache? Because it sounds bad? But
> they are in fact proposing precisely that just masked with "fast
> threads".

Please don't take this the wrong way, but I don't think you understand
the problem space that people are trying to address here.

Servers want to never, ever block. Not on a socket, not on a stat, not
on anything. (I have an embedded server I wrote that has to fork
internally just to watch the damn serial port signals in parallel with
handling network I/O, audio, and child processes that handle H323.)
There's a lot of things that can block out there, and it's not just
disk I/O.

Further, not only do servers not want to block, they also want to cram
a lot more requests into the kernel at once *for the kernel's
benefit*. In particular, a server wants to issue a ton of stats and
I/O in parallel so that the kernel can optimize which order to handle
the requests.

Finally, the biggest argument in favor of syslets/threadlets AFAICS is
that -- if done correctly -- it would unify the AIO and normal IO
paths in the kernel. The improved ease of long term maintenance on the
kernel (and more test coverage, and more directed optimization,
etc...) just for this point alone makes them worth considering for
inclusion.

So, while everybody has been talking about cached and non-cached
cases, those are really special cases of the entire package that the
rest of us want.

Ray
