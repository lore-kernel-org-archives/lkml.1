Return-Path: <linux-kernel-owner+w=401wt.eu-S965071AbXIGBDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965071AbXIGBDn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 21:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932659AbXIGBDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 21:03:36 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:52309 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932617AbXIGBDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 21:03:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=MKyy1cbagEJ/g6S5iElTdqqouMAgZIQGhWIEr9oZn/7Useu8X5VxGtIBjbBWJi2q60TJ2lVRNYEQW9iIHZrce4VC9zX8J2Vy0UHxmGQ6Zxg7u0D40Qa90NokWNlMF1cbmfCjrJHL8oeXwi1FAjmiVNwWcPsXEU2EF/txt/MLFpc=
Message-ID: <3ae72650709061803u7ed2ff21v511f219e742ecd7a@mail.gmail.com>
Date: Fri, 7 Sep 2007 03:03:33 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Manuel Reimer" <Manuel.Spam@nurfuerspam.de>
Subject: Re: udev: Inconsistency between %b and %p?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <fbppo0$rli$1@sea.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fbp6a3$k6r$1@sea.gmane.org> <jeodgfu6pz.fsf@sykes.suse.de>
	 <fbppo0$rli$1@sea.gmane.org>
X-Google-Sender-Auth: 7b674a2956bd902e
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/6/07, Manuel Reimer <Manuel.Spam@nurfuerspam.de> wrote:
> Andreas Schwab wrote:
> >> As I would prefer to use the USB device information (idVendor, idProduct)
> >> to detect the device, I also tried this one:
> >>
> >> ATTRS{idVendor}=="0dda", ATTRS{idProduct}=="2005", SUBSYSTEM=="scsi",
> >> ACTION=="add", PROGRAM+="/usr/bin/test.sh %b %p"
> >>
> >> Now this version returns the USB device ID ($NUM-$NUM) to the test script,
> >> but the device path (%p) is still OK and still goes down up to the SCSI
> >> device ID.
> >>
> >> Why does %b not return the SCSI device ID in the second rule?
> >
> > Because ATTRS has matched the USB device, not the SCSI device.
>
> Yes, that's right, but "SUBSYSTEM" matched the SCSI device...
>
> If I use udevinfo, then this tool tells me:
>
> | A rule to match, can be composed by the attributes of the device
> | and the attributes from one single parent device.
>
> So I thought, that I've matched the SCSI device now. To prove this, I
> just replaced "SUBSYSTEM=="scsi"" with "SUBSYSTEM=="usb"" and removed
> the "S" in the "ATTRS" of the above rule, and now, I get the USB-device
> in %b (as expected) and the path in %p only goes down up to the USB
> device ID.
>
> So, if all rules match for the same device, then %b and %p are both
> pointing to this, right, device.
>
> If I try to match, using one of the parent devices (using the "S"
> "extension" to the property names) and the device, to match to, itself,
> then the two are inconsistent. Then, %b holds the device name of the
> parent and %p holds the patch of the device, I want to match.
>
> For me, this looks like a bug, or am I wrong?

It's fine. $id, like some other values too, is a value of the device
where all keys successful matched while walking up the chain of
devices.

Seems you are looking for the name of the device you received the
event for, so just use $kernel instead.

Kay
