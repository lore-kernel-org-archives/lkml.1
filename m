Return-Path: <linux-kernel-owner+w=401wt.eu-S934008AbXDBNGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934008AbXDBNGK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 09:06:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934035AbXDBNGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 09:06:10 -0400
Received: from wr-out-0506.google.com ([64.233.184.229]:47533 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934008AbXDBNGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 09:06:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pI/7Tgb1xuyUuAewBipbVPzPNMy5CajSCs+TIpFsh6tEtMYA6GrZVrKerNEndg2tC40nTarFm0H5PPHly3mRWcwr9EGro63uPvv9wRng0QLdbQRSvDrJqKmiXoUQftRYa9vf+wOB3UiOvkoxcZfOjRfMhUPSvEnKC0wz3+srTEw=
Message-ID: <d120d5000704020606y620df4bfu1cf3728070f02a38@mail.gmail.com>
Date: Mon, 2 Apr 2007 09:06:07 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Dan Engel" <dan@sourceharvest.com>
Subject: Re: [PATCH] hid: add two led codes to hid input mapping
Cc: "Jiri Kosina" <jkosina@suse.cz>, linux-kernel@vger.kernel.org
In-Reply-To: <1175508842.12355.34.camel@monica.engel.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1175396188.7857.15.camel@monica.engel.home>
	 <Pine.LNX.4.64.0704011941310.6040@jikos.suse.cz>
	 <1175484539.12355.18.camel@monica.engel.home>
	 <200704020004.51861.dtor@insightbb.com>
	 <1175508842.12355.34.camel@monica.engel.home>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/2/07, Dan Engel <dan@sourceharvest.com> wrote:
> On Mon, 2007-04-02 at 00:04 -0400, Dmitry Torokhov wrote:
>
> > Actually I want to keep input subystm out of the loop here, since LEDs
> > such as mail, charging, etc have nothing to do with user input but
> > rather reflect overall system/application state.
> >
>
> What if I just added a HID_QUIRK_HIDDEV for the vendor/product id's in
> the blacklist table in hiddev.c. That would force the creation of a
> hiddev device, through which a user-space program could access the HID
> usages directly.
>
> It would be awkward, though, since there would also be an input event
> device, but one through which the full functionality is not accessible.

What other evets/usages does this device support?

> Is there a HID_QUIRK that would force creation of a hiddev *instead of*
> (rather than in addition to) an event dev?

No but it could be added.

>
> Two things to keep in mind:
>
> 1) The device in question (it's a Belkin USB Flip KVM switch, just to
> restate from the OP) has nothing to do with LED's. It just overloads the
> LED HID usage codes to receive control from the PC.

Ah, OK.

> 2) No matter what we do in terms of presenting this device to user-land,
> under the hood it's a HID-class USB device, and it probably doesn't make
> sense to not make use of that.

It may be a HID-class device but it is definetly not an input device
and it would be wrong to present it to userspace as a device having 2
LEDs on it - it would be a lie. If we did that then some application
might mistake the device for something else and decide to switch that
LED off thus turning your KVM off. A random application should not be
aware how a random vendor decided to interpret the specs.

-- 
Dmitry
