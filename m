Return-Path: <linux-kernel-owner+w=401wt.eu-S965622AbXCGUVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965622AbXCGUVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 15:21:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965625AbXCGUVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 15:21:21 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:34761 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965622AbXCGUVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 15:21:20 -0500
Date: Wed, 7 Mar 2007 21:20:33 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
cc: Luong Ngo <luong.ngo@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Sleeping thread not receive signal until it wakes up
In-Reply-To: <Pine.LNX.4.61.0703070813070.12338@chaos.analogic.com>
Message-ID: <Pine.LNX.4.61.0703072119290.2448@yvahk01.tjqt.qr>
References: <1b2aacd80703062131g6c8578fgf200dd05a502c49f@mail.gmail.com>
 <Pine.LNX.4.61.0703070813070.12338@chaos.analogic.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 7 2007 08:19, linux-os (Dick Johnson) wrote:
>
>Later versions of the kernel lock the kernel when an ioctl() is
>entered. This means that if you sleep in the ioctl(), nothing
>will get scheduled.

Later versions of the kernel also have an ->unlocked_ioctl method,
which is probably better than below's approach [which is akin to
FreeBSD's DROP_GIANT/PICKUP_GIANT].

>You can do the following (possibly unsafe) in your ioctl():
>
>     int locked = kernel_locked();
>
>     ......... code
>     ......... code
>
>     if(locked)  // Before sleeping section
>        unlock_kernel();
>     .......... sleeping code
>     if(locked)  // After sleeping section
>         lock_kernel();
>
>

Jan
-- 
