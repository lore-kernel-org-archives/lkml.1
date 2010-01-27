Return-Path: <linux-kernel-owner+w=401wt.eu-S1754909Ab0A0Nwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab0A0Nwa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 08:52:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754874Ab0A0Nw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 08:52:29 -0500
Received: from mga01.intel.com ([192.55.52.88]:9282 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754257Ab0A0Nw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 08:52:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,352,1262592000"; 
   d="scan'208";a="535023665"
Subject: Re: Fix For Korg Bug #14897 (GM45 Display Flicker)
From: ykzhao <yakui.zhao@intel.com>
To: "davidjon@xenontk.org" <davidjon@xenontk.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4B60080E.2000508@xenontk.org>
References: <4B60080E.2000508@xenontk.org>
Content-Type: text/plain
Organization: Intel Open Source Technology Center
Date: Wed, 27 Jan 2010 21:52:08 +0800
Message-Id: <1264600328.10341.29.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-27 at 17:31 +0800, David John wrote:
> Hi Jesse, Yakui,
> 
> Sorry for the delay, but I was busy with other work last week. I got
> some time to look into this on Monday and the problem seems to be this:

Hi, David
	Very good work. Thanks for looking at this issue.
	Do you have an opportunity to try the following patch set on 2.6.33-rc5
kernel and see whether the display flicker issue can be fixed?

>http://lists.freedesktop.org/archives/intel-gfx/2010-January/005505.html	

(The first patch can be skipped as it is already in 2.6.33-rc5 kernel).

Thanks.
	Yakui

> 
> With the external display connected on VGA, intel_update_watermarks
> calls update_wm a couple of times in sequence with the following params:
> 
> 1) planea_clock = 148500 planeb_clock = 0, sr_hdisplay=1920 (VGA)
> 2) planea_clock = 148500 planeb_clock = 72330, sr_hdisplay=1366 (LVDS)
> 
> In update_wm (in my case g4x_update_wm), for 1) sr_entries is calculated
> correctly and self refresh is enabled. For 2) sr_entries remains zero
> and the SR watermark is set as such. However, SR remains
> active. On mode switch to console, this causes a FIFO underrun and the
> display flicker.
> 
> The solution that I see is to simply disable SR if more than one pipe is
> enabled. I've written a patch that does this. Also another point is that
> the G45 docs state that a particular sequence has to be followed if SR
> is to be used when only one pipe is active for Cantiga (Pg 30, G45 Vol
> 3). I didn't see any code doing this, but I did not see any untoward
> behaviour either, with only my patch applied.
> 
> I've updated the patch to fix i965 and i9xx as I assume the same problem
> will occur on those chipsets as well, but this has _not_been tested as I
> don't have the relevant platforms.
> 
> Patch follows this mail. Please let me know if any changes are required.
> 
> The VGA output powering-on on mode change mentioned in my bug report is
> a separate DRM bug for which I will send a patch later.
> 
> Regards,
> David.

