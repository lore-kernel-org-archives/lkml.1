Return-Path: <linux-kernel-owner+w=401wt.eu-S1757708AbYFMFdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757708AbYFMFdB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 01:33:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751981AbYFMFcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 01:32:51 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:29927 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbYFMFcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 01:32:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Q7KyrcZ9cs2LVch+Kyj0vz5XF6EtTtURRgVrzwzfk2u6a6ol/3Y+qS0nV/5uEEuTod
         6xu5XQ2XOuJIlFmcetw9H0kAVZKdoeiPGdRKtMCBOq73/5Kojw9/cxuqF5GzQHy3ofO2
         89Voygl5h+2mHWNibUsCQ/QX5/i67LykfFnl4=
Message-ID: <c3d0340b0806122232s72d37509wd976217d336b83e7@mail.gmail.com>
Date: Thu, 12 Jun 2008 22:32:48 -0700
From: "Shawn Jin" <shawnxjin@gmail.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: Force a usb drive to be /dev/sda?
Cc: "Tomasz Chmielewski" <mangoo@wpkg.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4851046E.907@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4850DFB4.5020205@wpkg.org> <4851046E.907@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First, thanks a lot for the responses, especially to Stefan for the
various options. I have further questions on these options to fully
understand them.

>> Is there a reason why you can't use filesystem labels or UUIDs?
>
> Indeed.  Shawn, I see these options:
>
>  1. Mount filesystems by UUID or by label.
>    Doesn't work with some filesystems.

The bootloader I'm using is LILO. So I have to specify the boot device
and the root device in lilo.conf. For example, boot=/dev/sda,
root=/dev/sda1. I'm not sure how mounting filesystem by UUID or by
label can help. A little bit elaboration will be more helpful.

>  2. Refer to devices by device ID or by device path.
>    Requires a minimal udev environment which gives you
>    /dev/disk/by-id or /dev/disk/by-path, or something
>    similar to udev.  People had things like this already
>    working under Linux 2.4, using programs like devlabel
>    IIRC.  Requires you to set up an initrd with respective
>    scripts in it.
>    By-path only works if you never alter the USB topology
>    and PCI topology.  I.e. prefer by-id.

Every USB thumb drive has a unique ID. So will I have to have a
different root filesystem image if it's install in a different usb
drive if the by-id way is adopted?

>  3. Influence the order of disk probing so that your USB
>    disk is the first one.  Works only if there is at most
>    one disk on the USB bus and requires you to wait with
>    insertion or probing of the SATA controller driver (PCI
>    driver) until after the USB disk was probed by sd_mod.
>
>    There may or may not be very simple ways to do this.
>    Simplest would be to configure the SATA controller driver
>    as module and load that module in an rc script after the
>    root filesystem was mounted.  That would actually be much
>    simpler than option 2, so maybe you want to try this
>    before 2.

I think I understand this option. Of course this requires an initrd or
initramfs, which I need to build.

>  4. Last resort:  Hack sd_mod to defer any probes until after
>    the first probe of an USB attached disk.  Requires some
>    experience in kernel driver programming.

As you said, this is the last resort, which I also try to avoid. ;-)

-Shawn.
