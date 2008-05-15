Return-Path: <linux-kernel-owner+w=401wt.eu-S1757680AbYEONxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757680AbYEONxd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 09:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752951AbYEONxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 09:53:23 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:25476 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbYEONxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 09:53:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Dnt26E885Y+rOFba6aDyl/3lBI8h7V/9NG4X4QnwSpxSFdvXFRAL3FiehsxXyg0jyWnoIbFk1rvetk1FULtmF6W9ZHeZ//P/DitDtHOwcPBIByEZitn/GEKsCILvRewR6haZqeuhKjmseJEuQuECTF5snX8wPuMOjQuwSSncmLU=
Message-ID: <2a6e8c0d0805150653j394ec325jf45dd000c86bea8d@mail.gmail.com>
Date: Thu, 15 May 2008 09:53:08 -0400
From: "Ian E. Morgan" <penguin.wrangler@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: sysfs: duplicate filename (usb unusual dev?)
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080515050925.GA8133@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2a6e8c0d0805120810n55cbe046x7b4c07c36b5d4e92@mail.gmail.com>
	 <20080515050925.GA8133@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 1:09 AM, Greg KH <greg@kroah.com> wrote:
> On Mon, May 12, 2008 at 11:10:11AM -0400, Ian E. Morgan wrote:
>> My wife got a silly little keychain digital photo frame for a gift.
>> I'm trying to make it work, but no such luck:
>>
>> (This is on vanilla 2.6.25)
>
> These warning messages should be safely ignored (it's odd that I can't
> duplicate this, perhaps it's a CONFIG_SYSFS_DEPRECATED thing...)
>
>> So I don't get the reason for duplicate sysfs nodes, and the scsi
>> device for mass storage never shows up (no /dev/sdb is registered,
>> etc)
>
> Are you sure sd_mod is loaded?
>
> thanks,
>
> greg k-h
>

Yeah, turns out the device really is a piece of CR*P like I figured. I
had to add this to get it to work:

UNUSUAL_DEV(  0x1908, 0x1315, 0x0000, 0x0000,
                "BUILDWIN",
                "Photo Frame",
                US_SC_DEVICE, US_PR_DEVICE, NULL,
                US_FL_GO_SLOW ),

after which the device showed up as a removable media device with an
iso9660 fs! Sheesh! And this fs of course just contained some utter
garbage software for Windows to upload pictures onto the device using
a proprietary HID interface. Can you say "what were they thinking?!"

Having given up at this point, I plugged it into a windows box, and
the thing basically gave windows a conniption fit. Yeah, I think I'll
be throwing it out now. What do you expect for a $9.95 trinket from
China? Sorry for wasting everyone's time.

-- 
Ian Morgan
