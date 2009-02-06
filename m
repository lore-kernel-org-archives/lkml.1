Return-Path: <linux-kernel-owner+w=401wt.eu-S1757677AbZBFONx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757677AbZBFONx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 09:13:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbZBFONp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 09:13:45 -0500
Received: from mga09.intel.com ([134.134.136.24]:61905 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245AbZBFONo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 09:13:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,391,1231142400"; 
   d="scan'208";a="384643239"
Date: Fri, 6 Feb 2009 15:16:06 +0100
From: Samuel Ortiz <sameo@openedhand.com>
To: Philipp Zabel <philipp.zabel@gmail.com>
Cc: linux-kernel@vger.kernel.org, Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Matt Reimer <mreimer@vpop.net>
Subject: Re: [PATCH 0/6] fix PASIC3/DS1WM, use MFD core
Message-ID: <20090206141606.GK3341@sortiz.org>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
References: <1233852820-28549-1-git-send-email-philipp.zabel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233852820-28549-1-git-send-email-philipp.zabel@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

On Thu, Feb 05, 2009 at 05:53:34PM +0100, Philipp Zabel wrote:
> Hi,
> 
> the following patches turn DS1WM into an MFD cell driver, make PASIC3 use 
> the MFD core functions to register it and remove the generic clock API
> code from DS1WM as MFDs currently can't register their clocks with it.
> With those applied, 1-Wire is finally in a working state on magician.
> 
> Patch #2 depends on #1, patch #4 depends on #3 and patch #6 depends on #5.
> Therefor I propose that this whole patchset be queued in the mfd tree.
> If so, #4 could be merged into #2. But it won't hurt to just leave out 
> #3 and #4 for now and apply them as cleanups later.
The patches look good to me. I'll merge the 6 of them into my for-next branch.

Thanks for this work.

Cheers,
Samuel.


> Philipp Zabel (6):
>       mfd: DS1WM: convert to use MFD core
>       mfd: PASIC3: convert to use MFD core
>       pxa/magician: remove deprecated .bus_shift from PASIC3 platform_data
>       mfd: PASIC3: remove unused bus_shift field
>       mfd: DS1WM: remove clock handling
>       mfd: PASIC3: supply clock_rate to DS1WM via driver_data
> 
>  arch/arm/mach-pxa/magician.c   |    1 -
>  drivers/mfd/Kconfig            |    1 +
>  drivers/mfd/htc-pasic3.c       |  169 ++++++++++++++++------------------------
>  drivers/w1/masters/ds1wm.c     |   53 ++++++-------
>  include/linux/ds1wm.h          |   12 ---
>  include/linux/mfd/ds1wm.h      |    6 ++
>  include/linux/mfd/htc-pasic3.h |    1 -
>  7 files changed, 100 insertions(+), 143 deletions(-)
>  delete mode 100644 include/linux/ds1wm.h
>  create mode 100644 include/linux/mfd/ds1wm.h

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
