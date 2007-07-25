Return-Path: <linux-kernel-owner+w=401wt.eu-S932178AbXGYAT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178AbXGYAT3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 20:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756585AbXGYATU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 20:19:20 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:57615 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023AbXGYATT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 20:19:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=AhLRiCdetZcY5hcb4ClvTO9BvtPePIS9DkYxUOwuGxa0CjdI80/vB7QOc4UQO8sHaG6WwoXkg9xnHe7jIRXShefQkR6f53j7Hvi9Uy2xTua3jTDnK0m05hXwpLriMjHmt+b1Vj5GBu257AnFOvVl9iBBElmYj6IZu46JkKN9W5Q=
Message-ID: <3ae72650707241719w6c7f2dc7s1bc29d7f1dfd4288@mail.gmail.com>
Date: Wed, 25 Jul 2007 02:19:18 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Simon Arlott" <simon@fire.lp0.eu>
Subject: Re: sysfs/udev broken in 2.6.23-rc1 [input, i2c, ...] (Was: sysfs/udev broken in latest git?)
Cc: "Cornelia Huck" <cornelia.huck@de.ibm.com>, "Greg KH" <gregkh@suse.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <46A62F6A.8010403@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46A59EAA.9030105@simon.arlott.org.uk>
	 <20070724072540.GA835@suse.de>
	 <20070724100314.3c606131@gondolin.boeblingen.de.ibm.com>
	 <20070724084654.GB13152@suse.de>
	 <3ae72650707240220l737fb031hb4e326b0f1fe0e45@mail.gmail.com>
	 <20070724145433.4848ada1@gondolin.boeblingen.de.ibm.com>
	 <46A628AC.3060900@simon.arlott.org.uk>
	 <3ae72650707240934o68047677n97e6081ff3f42ce7@mail.gmail.com>
	 <46A62F6A.8010403@simon.arlott.org.uk>
X-Google-Sender-Auth: abaac181bcd889cd
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/24/07, Simon Arlott <simon@fire.lp0.eu> wrote:
> On 24/07/07 17:34, Kay Sievers wrote:
> > On 7/24/07, Simon Arlott <simon@fire.lp0.eu> wrote:
> >> On 24/07/07 13:54, Cornelia Huck wrote:
> >> > On Tue, 24 Jul 2007 11:20:02 +0200,
> >> > "Kay Sievers" <kay.sievers@vrfy.org> wrote:
> >> >
> >> >> It looks fine to me. "device" links must never point to anything else
> >> >> than a bus device.

While it's still true, for input we have special rules because the
"stacked class devices" existed only there. At least for
SYSFS_DEPRECATED, all input devices should have a "device" symlink
pointing to the bus-device.

> >> > Hm, but then
> >> > 1. The patch sneaks this check in (the old code only checked for
> >> >    dev->parent)
> >> > 2. The code is rather inconsistent now, since none of the other code
> >> >    paths check for dev->parent->bus...

Yeah, that's true.

> >> Removing the dev->parent->bus check fixes it:

Yes, let's remove the check, I will check now if we possibly need to
fix more than this or only the block-device patch.

Thanks,
Kay
