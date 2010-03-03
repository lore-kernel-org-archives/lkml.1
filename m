Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab0CCGN2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 01:13:28 -0500
Received: from smtp-out.google.com ([216.239.44.51]:35450 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043Ab0CCGN0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 01:13:26 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=xIEh2m3IuWozveZdB6RGfZmS0Dj9wnKi8PWF7vaYvItzEf8c4fDRBh9D39Luyr7AN
	iWEfKpuSGTrFBwpLu7P7w==
MIME-Version: 1.0
In-Reply-To: <4B8C1867.7040201@cam.ac.uk>
References: <4B8C1867.7040201@cam.ac.uk>
Date: Tue, 2 Mar 2010 22:13:21 -0800
Message-ID: <404ea8001003022213v78be2c81r40504661835fff7e@mail.gmail.com>
Subject: Re: [GIT PULL] Ambient Light Sensors subsystem
From: Dima Zavin <dmitriyz@google.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: torvalds@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>,
       Amit Kucheria <amit.kucheria@verdurent.com>,
       Jean Delvare <khali@linux-fr.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry if I'm jumping in a little late, but I'm concerned that adding
ALS as a separate "framework" is going to set the wrong precedent. ALS
is just one example of a class of sensors that are present on modern
mobile devices (e.g. ALS, proximity, compass/magnetometer,
accelerometer, etc.). Also, how does this deal with hybrid devices?
Many ALS devices have a proximity sensor on the same package. You'll
need to deal with enabling/disabling them separately, but likely share
a power function at the board file level (at least for arch/arm
systems).

I definitely see the need for what you guys are trying to accomplish.
For example, currently, we use an input device for reporting events,
and a separate misc device node for control
(enable/disable/configure). It's definitely suboptimal, but there
currently isn't anything there would let us do things cleanly.

What I would love to see is a more generic sensors framework that
handles different kinds of sensor devices, and different data
acquisition schemes (sampled vs. change notifications).

I would love to work with you to design something more generic.

Thanks.

--Dima

On Mon, Mar 1, 2010 at 11:41 AM, Jonathan Cameron <jic23@cam.ac.uk> wrote:
> Dear Linus,
>
> Please pull from
>
>        git://git.kernel.org/pub/scm/linux/kernel/git/jic23/als.git for-linus
>
> to get the Ambient Light Sensors subsystem.
> A large part of the following consists of moving two drivers from
> elsewhere in the kernel to als now it is available.
>
> acpi-als will merge later through the acpi tree as it sits entirely
> within their directories. Both moves have been confirmed with the
> respective maintainers and all known users of the drivers.
>
> All changes as per linux-next branch where they have been for some weeks.
>
> Thanks,
>
> Jonathan
>
> Amit Kucheria (1):
>      als: add unique device-ids to the als device class
>
> Jonathan Cameron (5):
>      ALS: Add jic23 and als git tree to MAINTAINERS
>      tsl2550: Move form i2c/chips to als and update interfaces. Remove i2c/chips in this commit to avoid build failure that results from separating that step out.
>      als: tsl2550: Remove spurious check against a maximum lux value.
>      Merge remote branch 'linus/master' into for-next
>      isl29003: Move from misc to als now it is available with minimal changes
>
> Zhang Rui (1):
>      introduce ALS sysfs class
>
>
>  Documentation/ABI/testing/sysfs-class-als |   18 +++++
>  MAINTAINERS                               |    8 ++
>  drivers/Kconfig                           |    2 +
>  drivers/Makefile                          |    1 +
>  drivers/als/Kconfig                       |   34 +++++++++
>  drivers/als/Makefile                      |    9 ++
>  drivers/als/als_sys.c                     |  116 +++++++++++++++++++++++++++++
>  drivers/{misc => als}/isl29003.c          |   46 ++++++++----
>  drivers/{i2c/chips => als}/tsl2550.c      |   96 +++++++++++++++---------
>  drivers/i2c/Kconfig                       |    1 -
>  drivers/i2c/Makefile                      |    2 +-
>  drivers/i2c/chips/Kconfig                 |   19 -----
>  drivers/i2c/chips/Makefile                |   18 -----
>  drivers/misc/Kconfig                      |   10 ---
>  drivers/misc/Makefile                     |    1 -
>  include/linux/als_sys.h                   |   35 +++++++++
>  16 files changed, 314 insertions(+), 102 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-class-als
>  create mode 100644 drivers/als/Kconfig
>  create mode 100644 drivers/als/Makefile
>  create mode 100644 drivers/als/als_sys.c
>  rename drivers/{misc => als}/isl29003.c (90%)
>  rename drivers/{i2c/chips => als}/tsl2550.c (82%)
>  delete mode 100644 drivers/i2c/chips/Kconfig
>  delete mode 100644 drivers/i2c/chips/Makefile
>  create mode 100644 include/linux/als_sys.h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
