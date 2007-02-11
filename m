Return-Path: <linux-kernel-owner+w=401wt.eu-S1752719AbXBKErc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719AbXBKErc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 23:47:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752718AbXBKErc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 23:47:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:57571 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752700AbXBKErY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 23:47:24 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Richard Purdie <rpurdie@rpsys.net>, linux-acpi@vger.kernel.org
Subject: Re: git backlight tree
Date: Sat, 10 Feb 2007 23:45:39 -0500
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, jsimmons@infradead.org,
       linux-kernel@hansmi.ch, openembedded@hrw.one.pl,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <1171153985.5836.66.camel@localhost.localdomain>
In-Reply-To: <1171153985.5836.66.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702102345.39855.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 February 2007 19:33, Richard Purdie wrote:
> As mentioned previously, I've setup a backlight git tree at:
> 
> http://git.o-hand.com/?p=linux-rpurdie-backlight;a=shortlog;h=for-mm
> (git://git.o-hand.com/linux-rpurdie-backlight)
> 
> A patch of the combined changes to mainline is:
> 
> http://www.rpsys.net/openzaurus/patches/git_backlight-r1.patch.gz

The changes under drivers/acpi/ and drivers/misc/ look fine to me.
Acked-by: Len Brown <len.brown@intel.com>
if you need that to send those bits upstream.

Note that there is a new sony-laptop driver under drivers/misc/ in my tree
that I expect to send upstream next week -- and it will need
the analogous updates.

thanks,
-Len

> I've included a git shortlog and diffstat output below. 
> 
> A few months ago Dmitry highlighted some problems with the backlight
> code and I've included patches to fix the issues raised. I've also
> included several pending backlight patches adding drivers or fixing
> other bugs.
> 
> The backlight code was turning into a locking minefield, several mutexes
> deep in places and was in need of some cleanup which these patches
> attempt, by simplifying locks and documenting what they protect. 
> 
> Whilst working on the above I noticed some ways of removing some code
> duplication particularly with the powermac backlight hooks. There were
> also several backlight calls from fb_blank methods which aren't needed
> with the backlight code so I've removed them. There should be no
> functionality changes.
> 
> I've cc'd various people who've been involved with areas of the
> backlight code. If people could check the changes to their
> hardware/areas of interest over or better still, test them I'd
> appreciate it as I can't compile or runtime test all of these changes.
> These changes should be appearing in the next -mm and I'm hoping it
> might still be possible to get them into 2.6.21 and iron out any issues
> during the -rc releases.
> 
> Richard
> 
>  MAINTAINERS                                 |    5
>  arch/powerpc/kernel/traps.c                 |    6 -
>  arch/powerpc/platforms/powermac/backlight.c |   27 +---
>  drivers/acpi/asus_acpi.c                    |    7 -
>  drivers/acpi/ibm_acpi.c                     |    8 -
>  drivers/acpi/toshiba_acpi.c                 |    7 -
>  drivers/acpi/video.c                        |   36 ++----
>  drivers/macintosh/via-pmu-backlight.c       |   33 ++----
>  drivers/misc/asus-laptop.c                  |   31 +----
>  drivers/misc/msi-laptop.c                   |   10 -
>  drivers/usb/misc/appledisplay.c             |   22 +---
>  drivers/video/Kconfig                       |   73 ++++++-------
>  drivers/video/aty/aty128fb.c                |  102 +++---------------
>  drivers/video/aty/atyfb_base.c              |  100 +++---------------
>  drivers/video/aty/radeon_backlight.c        |   59 ++--------
>  drivers/video/aty/radeon_base.c             |    3
>  drivers/video/backlight/Kconfig             |   24 ++--
>  drivers/video/backlight/Makefile            |    1
>  drivers/video/backlight/backlight.c         |  123 +++++++++++-----------
>  drivers/video/backlight/corgi_bl.c          |   54 ++++-----
>  drivers/video/backlight/hp680_bl.c          |   50 +++++----
>  drivers/video/backlight/lcd.c               |   83 +++++++--------
>  drivers/video/backlight/locomolcd.c         |   13 +-
>  drivers/video/backlight/progear_bl.c        |  153 ++++++++++++++++++++++++++++
>  drivers/video/chipsfb.c                     |   26 ----
>  drivers/video/console/fbcon.c               |    7 +
>  drivers/video/fbsysfs.c                     |   14 +-
>  drivers/video/nvidia/nv_backlight.c         |   92 ++--------------
>  drivers/video/nvidia/nv_proto.h             |    2
>  drivers/video/nvidia/nvidia.c               |    5
>  drivers/video/riva/fbdev.c                  |  100 +++---------------
>  include/linux/backlight.h                   |   50 +++++++--
>  include/linux/fb.h                          |   13 +-
>  include/linux/lcd.h                         |   45 ++++++--
>  34 files changed, 624 insertions(+), 760 deletions(-)
> 
> 
> Dmitry Torokhov (2):
>       backlight: Fix error handling
>       backlight: Remove excessive (un)likelys
> 
> James Simmons (1):
>       backlight: Improve backlight selection for fbdev drivers
> 
> Marcin Juszkiewicz (1):
>       backlight: Add Frontpath ProGear HX1050+ driver
> 
> Michael Hanselmann (1):
>       backlight: Fix null pointer dereference in appledisplay driver
> 
> Richard Purdie (15):
>       backlight: Add maintainer entry
>       backlight: Remove unneeded owner field
>       backlight: Minor code cleanups for corgi_bl.c
>       backlight: Minor code cleanups for hp680_bl.c
>       backlight: Fix external uses of backlight internal semaphore
>       backlight: Convert semaphore -> mutex
>       backlight: Remove uneeded nvidia set_power calls
>       backlight: Fix Kconfig entries
>       backlight/fbcon: Add FB_EVENT_CONBLANK
>       backlight: Remove uneeded update_status call from chipsfb.c
>       backlight: Remove unneeded backlight update_status calls
>       backlight: Rework backlight/fb interaction simplifying, lots
>       backlight: Clean up pmac_backlight handling
>       backlight: Separate backlight properties from backlight ops pointers
>       backlight: simplify corgi_bl locking
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
