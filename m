Return-Path: <linux-kernel-owner+w=401wt.eu-S1754584AbXDZP6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbXDZP6M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 11:58:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754818AbXDZP6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 11:58:12 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:31945 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584AbXDZP6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 11:58:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rtq7SVm4dT5OYv1E7w0z5r4a/RDb98XqeWsuFs+rUScFrR2hI8/znKp6IKYAfK0v1J0Qve6P/Swwi/yhUcvRn5WhJfobrZMINBoZSyPzdnlkcuM4n9OM2HYukV/rA1rImDoTxBPI7i+BayIPrlab2+hecxAYZWTJitXYS0lZtJE=
Message-ID: <d120d5000704260858l4ecdbacfv8cbec98333216a4a@mail.gmail.com>
Date: Thu, 26 Apr 2007 11:58:09 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [RFC 1/2] Input: ff, add FF_RAW effect
Cc: "johann deneux" <johann.deneux@gmail.com>, linux-kernel@vger.kernel.org,
       stenyak@gmail.com, linux-input@atrey.karlin.mff.cuni.cz
In-Reply-To: <462D0947.3090109@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <210731960111436322@karneval.cz> <462688AB.4060707@gmail.com>
	 <38b3b7c0704182125q1928c5barad21ed603088ab04@mail.gmail.com>
	 <200704190058.11625.dtor@insightbb.com> <46278CDD.2000007@gmail.com>
	 <d120d5000704190902o60aa4b19y77728585e22b2e84@mail.gmail.com>
	 <462D0947.3090109@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On 4/23/07, Jiri Slaby <jirislaby@gmail.com> wrote:
> Dmitry Torokhov napsal(a):
> > For devices that require tailored application (for example that glove
> > - I am not sure how a generic application could control it) old
> > phantom way of controlling via ioctl will suffice. The device may
> > still use input layer to report back coordinates.
>
> And how about the individual FF ioctl? Did you mean registering another
> chardev, which is totally ugly in my eyes or augment evdev.c to support
> driver specific ioctl? i.e. either add another 'E' ioctl with pointer to
> struct { code, value } as arg param or changing
> if (_IOC_TYPE(cmd) != 'E'))
>        return -EINVAL;
> to sth. like
> if (_IOC_TYPE(cmd) != 'E'))
>        return dev->ioctl ? dev->ioctl(file, cmd, p) : -EINVAL;
> in evdev_ioctl_handler, which is acceptable?
>

I really do not want to have driver-specific ioctls attaching to
evdev. What is wrong with a separate device to control phantom? You
won't even have to use ioctl but regial write on it.

-- 
Dmitry
