Return-Path: <linux-kernel-owner+w=401wt.eu-S1760251AbYDCCET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760251AbYDCCET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 22:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757845AbYDCCEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 22:04:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:16487 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757581AbYDCCEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 22:04:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,596,1199692800"; 
   d="scan'208";a="544700239"
Subject: Re: rc6+ regression - backlight reset to 0 on boot after
	7c0ea45be4f114d85ee35caeead8e1660699c46f
From: Zhao Yakui <yakui.zhao@intel.com>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200804022253.17862.arvidjaar@mail.ru>
References: <200804022253.17862.arvidjaar@mail.ru>
Content-Type: text/plain
Date: Thu, 03 Apr 2008 09:59:39 +0800
Message-Id: <1207187979.25346.8.camel@yakui_zhao.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-02 at 22:53 +0400, Andrey Borzenkov wrote:
> Commit 7c0ea45be4f114d85ee35caeead8e1660699c46f registers ACPI backlight
> even if _BQC method (query current backlight level) is missing. The effect is:
> 
> during initialization video.c:acpi_video_device_find_cap() calls backlight_update_status(). It tries to fetch actual level via acpi_video_get_brightness() - but as _BQC is missing it just returns current value
> as stored in memory - i.e. zero, because it was never set. So effectively
> backlight_update_status() reset brightness to minimal value == 0.
> 
> This happens on Toshiba Portege 4000. Verified by reverting commit on top of
> rc8.
It seems that _BQC object is missing on the Toshiba Portege 4000. And
acpi video driver will continue to update the status of backlight even
when _BQC object is missing, which is inappropriate. 
Maybe it is more appropriate that OS doesn't update the status of
backlight in boot phase when _BQC object is missing.

Of course please attach the output of acpidump in kernel bugzilla.
http://bugzilla.kernel.org/show_bug.cgi?id=10387
> On a side note, it would be nice to fit backlight device into actual ACPI
> device tree instead of /devices/virtual.

