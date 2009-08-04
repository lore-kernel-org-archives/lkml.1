Return-Path: <linux-kernel-owner+w=401wt.eu-S1755368AbZHDUuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbZHDUuu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 16:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753728AbZHDUut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 16:50:49 -0400
Received: from kroah.org ([198.145.64.141]:43870 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753255AbZHDUus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 16:50:48 -0400
Date: Tue, 4 Aug 2009 13:35:49 -0700
From: Greg KH <greg@kroah.com>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: Jakub Schmidtke <sjakub@gmail.com>, acpi4asus-user@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Cleaning asus_oled
Message-ID: <20090804203549.GA25332@kroah.com>
References: <71cd59b00908041140j7bd814d2u90585864fe00415e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <71cd59b00908041140j7bd814d2u90585864fe00415e@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 04, 2009 at 08:40:10PM +0200, Corentin Chary wrote:
> Hi,
> I'm trying to clean the asus_oled driver, here is my git tree with
> some trivial patchs.
> http://git.iksaif.net/?p=acpi4asus.git;a=shortlog;h=refs/heads/asus_oled

That's great!  But note, I need patches in email form, so you are going
to use git format-patch to dig them out for me, right?  :)

> Before working deeper, I wanted to discuss about the userspace interface:
> 
> > TODO:
> > [...]
> >        - audit the userspace interface
> >                - sysfs vs. char?
> 
> First, should we move asus_oled functionalities in asus-laptop ?
> Then the interface would be in sysfs under
> /sys/devices/platform/asus-laptop/{picture|enable} ?

Is that the way that other drivers of this kind of functionality work
today?  If so, yes, that would be good.

> Else we can use /dev/asus_oled, with an ioctl (or a zero-size image)
> to switch the OLED off.
> But I don't think /sys/class/oled is a good place to be, because
> /sys/class is for generic things.

Like /sys/class/video_output?  There's got to be some other generic
backlight driver class already, oh, hey, look at /sys/class/backlight!

So, why not just use the backlight interface instead, that way you don't
have to write custom userspace code for this specific platform?

thanks,

greg k-h
