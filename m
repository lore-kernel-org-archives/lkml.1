Return-Path: <linux-kernel-owner+w=401wt.eu-S1756328AbYANMWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328AbYANMWw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 07:22:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756156AbYANMWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 07:22:42 -0500
Received: from nz-out-0506.google.com ([64.233.162.227]:11158 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755846AbYANMWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 07:22:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RLhAQ578V8rTyyPppXW4s+LQVFu1wHO16yihDznZ9002zLWEcwAIeu1/Ni8Q50cG9f/fQbE/vF8zBFn3CJAznDRTEBssJTvqrKJ7H8FnEqYwHkrq6eCkr12NEQn1Th0n/wHEYbykpWn763ge3etzmgmX3ZMrLnQDkQx6PovgIGo=
Message-ID: <8bd0f97a0801140422n3d3e3835v7f57dbe33c7a6db0@mail.gmail.com>
Date: Mon, 14 Jan 2008 07:22:39 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Haavard Skinnemoen" <hskinnemoen@atmel.com>
Subject: Re: [RFC, PATCH] watchdog on gpio
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Marc Pignat" <marc.pignat@hevs.ch>,
       wim@iguana.be, linux-kernel@vger.kernel.org
In-Reply-To: <20080114131429.40453e5f@siona>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200801101611.08867.marc.pignat@hevs.ch>
	 <8bd0f97a0801140004q6a32c2ceh397a2208d3012f0e@mail.gmail.com>
	 <20080114090329.6efa2921@lxorguk.ukuu.org.uk>
	 <8bd0f97a0801140128i2ebf9236uabe0e0b8cf15fbe@mail.gmail.com>
	 <20080114092905.227c5a38@lxorguk.ukuu.org.uk>
	 <8bd0f97a0801140145s5e13083ej926aa9d5f87e3a99@mail.gmail.com>
	 <20080114131429.40453e5f@siona>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 14, 2008 7:14 AM, Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:
> "Mike Frysinger" <vapier.adi@gmail.com> wrote:
> > there is no hard requirement anywhere that says platform resources
> > must be in the board resources file.  marking the functions as __init
> > instead of __devinit will basically cause a kernel crash if someone
> > tries to use dynamic platform resources.  there is no option that i'm
> > aware of that prevents dynamic platform resources which means there is
> > no way for the driver to say "i wont work with standard dynamic
> > platform resources".
>
> There is: platform_driver_probe(). It takes the probe function as a
> parameter so that it can be left out of the platform_driver struct.
> After it returns, there are no references to the probe function left
> around, so if you call platform_driver_probe() instead of
> platform_driver_register(), the probe function can be __init.

ah, thanks for that.  i think in that case, there's no way to bind the
release function to the process ?  which means the driver is no longer
unloadable ?  which means the platform driver release function can be
scrubbed as well as the module exit function as well as changing the
Kconfig to be a bool ?
-mike
