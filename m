Return-Path: <linux-kernel-owner+w=401wt.eu-S966164AbXEVP6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966164AbXEVP6f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 11:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758582AbXEVP60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 11:58:26 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:19116 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758368AbXEVP6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 11:58:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=I2//JdBA/+FL3iF8Yjq5Icj6SrpoeFeloj6FSDUfzaI27XCJWNdvfALZQErff+6AYf6vSkCMZ7B3KkwkaXPGBeLeAWqjAp6twUZ4BPhFuNB7QeOy6bLkaLWRXqr/PHduonqiDlVxGNS566D80jfsM3I3UWQIm/2i8cCSVoYN8cc=
Message-ID: <59ad55d30705220858i593352b6p87a6b385aea23748@mail.gmail.com>
Date: Tue, 22 May 2007 11:58:23 -0400
From: "=?UTF-8?Q?Kristian_H=C3=B8gsberg?=" <krh@bitplanet.net>
To: "Pierre Ossman" <drzeus-list@drzeus.cx>
Subject: Re: Race free attributes in sysfs
Cc: "Kay Sievers" <kay.sievers@vrfy.org>, "Greg KH" <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <46530F02.7010802@drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46502A8B.70803@drzeus.cx>
	 <3ae72650705211050p6b6cefbdya70dd4e0a27e2d1b@mail.gmail.com>
	 <4651E866.5010304@drzeus.cx>
	 <1179775695.3320.82.camel@lov.localdomain>
	 <46530F02.7010802@drzeus.cx>
X-Google-Sender-Auth: 5e29feb98c0f7b22
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/22/07, Pierre Ossman <drzeus-list@drzeus.cx> wrote:
> Kay Sievers wrote:
> > We could change the driver-core to suppress the creation of an attribute
> > if the attribute's show() or store() method returns something like
> > -ENOENT at registration time?
> > The driver would pass _all_ possible attributes of the device at
> > registration time, but the core would only create the attributes which
> > are implemented for this particular device? Would that work for you?
> >
>
> Not sure. Not in an obvious way at least.
>
> It also doesn't feel like "the kernel way". Generally you can
> create/allocate an object, assign attributes to it, then activate it.
> Couldn't it be done so that I can add sysfs stuff to a device after I
> just initialized it? (but before I add it).

I agree here - if it was just possible to do this between create and
add, this discussion would be moot.

> > You can assign any number of attribute groups to the device. If they
> > don't have a group name, they will all be created directly at the device
> > level. Would that work for you?
>
> I've had a look at sysfs groups and the biggest beef I have with those
> is that they're too low level. In order to use them I first need to
> create device attributes, then create an array of pointers to each attr
> member. It would be nice if I could just feed an array of device
> attributes (i.e. I want wrappers).

I did a little helper struct for the firewire subsystem that might be
useful on a more general level.  It's struct fw_attribute_group in
drivers/firewire/fw-device.h and the implementation is
init_fw_attribute_group in drivers/firewire/fw-device.c.  But I agree,
attribute groups require a fair bit of boiler plate code.

cheers,
Kristian
