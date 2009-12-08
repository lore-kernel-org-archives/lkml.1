Return-Path: <linux-kernel-owner+w=401wt.eu-S1751490AbZLHFHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490AbZLHFHK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 00:07:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750905AbZLHFHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 00:07:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbZLHFHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 00:07:08 -0500
Subject: Re: [BISECTED] 33 second boot delay (caused by Radeon KMS) on
 2.6.32
From: Dave Airlie <airlied@redhat.com>
To: Steven Noonan <steven@uplinklabs.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jerome Glisse <jglisse@redhat.com>
In-Reply-To: <f488382f0912072101j79c8393exf2e671954ef153f9@mail.gmail.com>
References: <f488382f0912072101j79c8393exf2e671954ef153f9@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Dec 2009 15:05:41 +1000
Message-Id: <1260248741.3400.0.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-07 at 21:01 -0800, Steven Noonan wrote:
> Hi,
> 
> I finally got around to compiling 2.6.32 for my primary machine, and
> with radeon.modeset=1, the machine has a horrifying 33 second boot
> delay (it stays at a black screen for the duration).
> 
> I figured a 'git bisect v2.6.32 v2.6.31 -- drivers/gpu/drm' would
> catch it. Hopefully this bisection helps pin down the underlying
> problem:
>  # bad:  [22763c5c] Linux 2.6.32
>  # good: [74fca6a4] Linux 2.6.31
>  # bad:  [df748b02] drm/ttm: fix refcounting in ttm global code.
>  # good: [a513c184] drm/radeon/kms: Don't try to process irq when we a
>  # good: [aadd4e17] drm/radeon: some r420s have a CP race with the DMA
>  # good: [74bf2ad5] drm/kms: make fb helper work for all drivers.
>  # bad:  [62a8ea3f] drm/radeon/kms: Remove old init path as no hw use
>  # good: [f0ed1f65] drm/radeon/kms: Convert R520 to new init path and
>  # skip: [d4550907] drm/radeon/kms: Convert R100 to new init path (V2)
>  # good: [3bc68535] drm/radeon/kms: Convert RS690/RS740 to new init pa
>  # bad:  [c010f800] drm/radeon/kms: Convert RS600 to new init path
> 
> Any ideas why c010f800 would cause this?
> 

Wierd, it seems an unlikely change to affect this, can you boot with
drm.debug=15 on the command line and see if we can glean anymore info
about where its hanging.

It might be good to open a bug either on kernel.org or freedesktop.org
(against Xorg radeon driver - since we mostly hang out there).

Dave.


