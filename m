Return-Path: <linux-kernel-owner+w=401wt.eu-S1765473AbXJZRCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765473AbXJZRCl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 13:02:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757358AbXJZRC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 13:02:27 -0400
Received: from wx-out-0506.google.com ([66.249.82.233]:26951 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765322AbXJZRCZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 13:02:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Qs+/s60WyhmuoQI+73wxysaDcAjJSn4q8XsRPnbFAu97yFwpGENG9ydvfHs5ZAdrO7lJqPiAK9fo4vPxDbvCN7GquQy7hOgbDn5pTVDHGc2tpBe6G8bmw4uYjrrLqPMIpgeF1t3doKlWGx7oXhqyPkT9Gnwx9l/1UlTaLNnISY0=
Message-ID: <e9c3a7c20710261002m1c5063bdqa040834c30d9ca8a@mail.gmail.com>
Date: Fri, 26 Oct 2007 10:02:24 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Haavard Skinnemoen" <hskinnemoen@atmel.com>
Subject: Re: [PATCH] DMA: Correct invalid assumptions in the Kconfig text
Cc: "Shannon Nelson" <shannon.nelson@intel.com>, linux-kernel@vger.kernel.org,
       "David Brownell" <david-b@pacbell.net>, kernel@avr32linux.org,
       linux-arm-kernel@lists.arm.linux.org.uk
In-Reply-To: <20071025113240.466b69ba@siona>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <1193218705-16685-1-git-send-email-hskinnemoen@atmel.com>
	 <e9c3a7c20710240855j7bf1f0a6qa1d11af3a12910e5@mail.gmail.com>
	 <20071024201616.02f87b20@siona> <20071025113240.466b69ba@siona>
X-Google-Sender-Auth: 8e20531ad43e63b4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/07, Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:
> On Wed, 24 Oct 2007 20:16:16 +0200
> Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:
>
> > [handwaving about API extensions]
>
> Oh, and we definitely need a way to report errors. Looks like the
> existing drivers want this as well -- I couldn't help but notice this
> in the iop-adma driver:
>
> static irqreturn_t iop_adma_err_handler(int irq, void *data)
> {
>         (...)
>
>         BUG();
> }
>
> That's a panic waiting to happen, isn't it?

Yes, and it should have a comment, because for now this is deliberate.
 This was primarily driven by the fact that MD has no way of
recovering from hardware errors during software-memcpy or
software-xor_blocks so there was no where to plug-in
accelerated-memcpy/xor error recovery.  I can foresee other clients
wanting to have this information reported but async_tx based clients
are supposed to be blissfully unaware of under the covers hardware
acceleration.

One idea is to pass an error-pointer as the parameter to callback
routines, but that would hamper the client's ability to recover the
context of the failure...

>
> Håvard

--
Dan
