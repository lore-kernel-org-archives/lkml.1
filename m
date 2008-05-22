Return-Path: <linux-kernel-owner+w=401wt.eu-S1756814AbYEVTr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814AbYEVTr0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 15:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753509AbYEVTrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 15:47:17 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:62077 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209AbYEVTrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 15:47:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MjX8iGlnGRQnnhuhdwJBADG/uT7VlMrL43ow6pZ67EtFRIrNjxccr0bXHUWHwwOtueXPn4idhiT/Y8/8kMVEUfxkAjM8qN+YGFf4aT6XUZhwSSftQr3+OeSrXmblg9cHsHC4RoVpD/fmUYZdihlQYI2RC3Zyv+rZdN5GYyDqIx0=
Message-ID: <7b9198260805221247t715660d1l4085fe8c310f89c@mail.gmail.com>
Date: Thu, 22 May 2008 20:47:16 +0100
From: "Tom Spink" <tspink@gmail.com>
To: "Hans J. Koch" <hjk@linutronix.de>
Subject: Re: [PATCH 1/1] UIO: Add a write() function to enable/disable interrupts
Cc: linux-kernel@vger.kernel.org, "Greg Kroah-Hartman" <gregkh@suse.de>,
       "Jan Altenberg" <jan.altenberg@linutronix.de>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "=?ISO-8859-1?Q?Uwe_Kleine-K=C3=B6nig?=" <Uwe.Kleine-Koenig@digi.com>,
       "Magnus Damm" <magnus.damm@gmail.com>
In-Reply-To: <20080522192637.GC3226@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080522192252.GB3226@local> <20080522192637.GC3226@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/5/22 Hans J. Koch <hjk@linutronix.de>:
> Sometimes it is necessary to enable/disable the interrupt of a UIO device
> from the userspace part of the driver. With this patch, the UIO kernel driver
> can implement an "irqcontrol()" function that does this. Userspace can write
> an s32 value to /dev/uioX (usually 0 or 1 to turn the irq off or on). The
> UIO core will then call the driver's irqcontrol function.
>
> Signed-off-by: Hans J. Koch <hjk@linutronix.de>

<snip>

Hi,

I wonder if it would be better to implement this as an ioctl, rather
than a write to the device.  Writing to a device is a pretty generic
thing, and this patch would tie that up to specifically controlling
interrupts.  An ioctl would be more appropriate, IMO, as you are
issuing a controlling command, i.e. disable or enable interrupts.

By the way, I have absolutely no idea how the UIO driver works, other
than reading http://lwn.net/Articles/232575/

-- 
Tom Spink
