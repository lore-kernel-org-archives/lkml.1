Return-Path: <linux-kernel-owner+w=401wt.eu-S1753951AbZKQQfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbZKQQfS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 11:35:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752650AbZKQQfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 11:35:17 -0500
Received: from 128-177-28-166.ip.openhosting.com ([128.177.28.166]:60725 "EHLO
	zelenka.fubar.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723AbZKQQfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 11:35:16 -0500
X-Greylist: delayed 1517 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Nov 2009 11:35:16 EST
Subject: Re: [PATCH] [RFC] Add support for uevents on block device idle 
 changes
From: David Zeuthen <david@fubar.dk>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org,
       axboe@kernel.dk, linux-hotplug@vger.kernel.org
In-Reply-To: <ac3eb2510911170755i5188fb53ud2d6012a2db8c00a@mail.gmail.com>
References: <1258468659-5446-1-git-send-email-mjg@redhat.com>
	 <ac3eb2510911170755i5188fb53ud2d6012a2db8c00a@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Nov 2009 11:09:40 -0500
Message-Id: <1258474180.16176.62.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-17 at 16:55 +0100, Kay Sievers wrote:
> I guess, at the moment the disk tells it's idle, udev will open() the
> disk and look for changed signatures, and end its idle state. :)

Huh, this will probably cause interesting loops then ;-)

> Uevents might not be the right interface, they are usually used if the
> device needs to be (re-)examined, which will the idle thing into a
> loop with the current setups, I guess.

Yeah.

> Maybe we can use a sysfs file which can be open()'d and something can
> watch with poll(), and gets woken up by the kernel, after the drive
> changes its state? MD raid, as an example, has files like this in
> sysfs to allow monitoring. That way, there is also no overhead, if the
> requesting process goes away, which is usually the nicer interface,
> than a global switch, which does not care about if the requesting
> process still exists.

Can't we just use /sys/block/sdX/stat? I believe this file already has
the property that the contents of the file will stay constant exactly
when the device is idle. Being able to use poll() for change
notifications seems like a good interface.

Thanks,
David


