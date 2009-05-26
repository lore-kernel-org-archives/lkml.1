Return-Path: <linux-kernel-owner+w=401wt.eu-S1755967AbZEZMxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967AbZEZMxb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 08:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754065AbZEZMxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 08:53:23 -0400
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:52541 "EHLO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752863AbZEZMxW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 08:53:22 -0400
From: Frans Pop <elendil@planet.nl>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 1/3] ide: add "ignore_hpa" module parameter
Date: Tue, 26 May 2009 14:53:21 +0200
User-Agent: KMail/1.9.9
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200905252344.11826.bzolnier@gmail.com> <200905260106.13705.elendil@planet.nl> <200905261423.40117.bzolnier@gmail.com>
In-Reply-To: <200905261423.40117.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <200905261453.22428.elendil@planet.nl>
X-OriginalArrivalTime: 26 May 2009 12:53:23.0034 (UTC) FILETIME=[F3EA13A0:01C9DE00]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 May 2009, Bartlomiej Zolnierkiewicz wrote:
> First time with the introduction of the default IDE HPA behavior of
> always giving the access to the full capacity of a disk and leaving
> decisions about HPA preservation/removal up to the installer & user.
>
> Second time when said distributions switched from IDE to libata (which
> uses the different default behavior as it limits the capacity to
> non-HPA part).

Has there really been something like a deliberate switch?

In my experience with Debian there's been no such thing. ATA has just been 
gradually enabled. (And initially that resulted in quite a mess because 
some devices would be supported by two drivers and the kernel couldn't 
even make up its own mind which one it preferred, resulting in random 
switches between drivers. At least that was resolved at some point.)

However, I must admit that Debian has not handled the IDE-ATA switch very 
well. So far users have mostly been left to deal with any fallout for 
themselves.

> Please note that no fancy sysfs support was needed to prevent the
> problem: both stacks (ide & libata) support HDIO_DRIVE_TASK ioctl which
> can be used to execute commands needed to retrieve/change HPA setting.

I don't really see how that would help. The fact that fancy ioctls exist 
does not mean users or even distros have the knowledge needed to use 
them. IMHO such issues should be dealt with at the level where that 
knowledge is available: the kernel community.

> Moreover the (much needed) work from Tejun doesn't help a tiny bit in
> case of people migrating their *working* setups from IDE to libata

>From what I've seen now that seems the most important case that needs 
supporting, as well as the case where a working setup would migrate from 
IDE with old HPA default to IDE with new HPA default.

Naive thought: wouldn't it be possible to check whether a partition 
overlaps the HPA boundary and warn or even bug out in that case?

> (at least in distro upgrade case this could have been handled by distro
> installer but see above) and hitting the compatibility issue mentioned
> in bug #13365.

At least in the case of Debian there is no such thing as a "distro 
installer" involved in upgrades. Debian only uses its installer for new 
installs, not for upgrades between releases. The last is purely done by 
regular package management.

It's also not sufficient to rely on that anyway because users sometimes do 
install newer upstream kernels (whether because of issues or to help with 
kernel development/testing), which means no distro upgrade is involved.
