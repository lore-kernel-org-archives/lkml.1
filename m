Return-Path: <linux-kernel-owner+w=401wt.eu-S1752121AbZG3U5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbZG3U5Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 16:57:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751629AbZG3U5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 16:57:25 -0400
Received: from mail-yx0-f188.google.com ([209.85.210.188]:43525 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbZG3U5Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 16:57:24 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.0907301522570.6087-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0907301522570.6087-100000@iolanthe.rowland.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 30 Jul 2009 16:57:06 -0400
Message-ID: <ac3eb2510907301357j43189388lae6ec5d4e6ad365e@mail.gmail.com>
Subject: Re: [PATCH] Driver core: add new device to bus's list before probing
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 30, 2009 at 15:27, Alan Stern<stern@rowland.harvard.edu> wrote:
> This patch (as1271) affects when new devices get linked into their
> bus's list of devices.  Currently this happens after probing, and it
> doesn't happen at all if probing fails.  Clearly this is wrong,
> because at that point quite a few symbolic links have already been
> created in sysfs.  We are committed to adding the device, so it should
> be linked into the bus's list regardless.
>
> In addition, this needs to happen before the uevent announcing the new
> device gets issued.  Otherwise user programs might try to access the
> device before it has been added to the bus.
>
> To fix both these problems, the patch moves the call to
> klist_add_tail() forward from bus_attach_device() to bus_add_device().
> Since bus_attach_device() now does nothing but probe for drivers, it
> has been renamed to bus_probe_device().  And lastly, the kerneldoc is
> updated.

Thanks for doing this that quickly. You are doing a really great job.

> Kay, do you want this merged into 2.6.31 or are you okay with waiting
> for 2.6.32-rc1?  It changes a major core routine.  On the other hand,
> the problem it fixes does affect real users.

I think it should go into -next and we wait a few days. It seems like
the proper fix, but we should make sure, we didn't miss something.

After that, it would be nice if we can get that into 2.6.31, as we
have several problems already, which are likely solved by this.

Thanks,
Kay
