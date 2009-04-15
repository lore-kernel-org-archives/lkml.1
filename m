Return-Path: <linux-kernel-owner+w=401wt.eu-S1756562AbZDOT4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562AbZDOT4o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 15:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755762AbZDOT4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 15:56:21 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:53293 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755360AbZDOT4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 15:56:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=JyQhgBmMxWmEW33hQGKAvtf5KQBHCdOCzvm9z1PDbPHk4mEHWq30WPgFoebnXgFuyA
         B3nqkw0X5LejZ2tN7AQ+FJrNlrdyHaGfFF/QTH4YXVxVOEnU+MWHzZt+n2Zqr5YwC89g
         UZL71zeAl0srX9yY4uFaHzzwVz0PeB5dCPp+o=
Message-ID: <49E63BCB.9090801@gmail.com>
Date: Wed, 15 Apr 2009 21:55:55 +0200
From: Niel Lambrechts <niel.lambrechts@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090310)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       yakui_zhao <yakui.zhao@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux.kernel" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: 2.6.30-rc1 (latest git): thinkpad-acpi: cannot control brightness
 with hotkeys (BISECTED)
References: <49E10684.5090101@gmail.com> <20090411150555.8b13ed18.akpm@linux-foundation.org> <20090412161448.GC26502@khazad-dum.debian.net> <49E234ED.5010105@gmail.com> <1239585695.5564.5.camel@localhost.localdomain> <49E3575A.60204@gmail.com> <20090413203450.GC16152@khazad-dum.debian.net> <49E5234E.5070303@gmail.com> <20090415164939.GA27807@srcf.ucam.org>
In-Reply-To: <20090415164939.GA27807@srcf.ucam.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2009 06:49 PM, Matthew Garrett wrote:
> Does this help?
>
> diff --git a/drivers/gpu/drm/i915/i915_opregion.c b/drivers/gpu/drm/i915/i915_opregion.c
> index 6942772..8dc1fd3 100644
> --- a/drivers/gpu/drm/i915/i915_opregion.c
> +++ b/drivers/gpu/drm/i915/i915_opregion.c
> @@ -370,11 +370,8 @@ int intel_opregion_init(struct drm_device *dev, int resume
>   
Hi Matthew,

Yes please, after your patch the brightness can be adjusted again. :)

The behaviour seems slightly different from before your 74a365b3f354
commit in that /sys/class/backlight remains empty until i915 gets loaded
for the first time, the contents then persist even if i915 is unloaded.
Perhaps the directory was populated by a different kernel module, since
when I did the bisect yesterday the directory would be there on boot
before I started X or loaded i915.

 I'm not sure if that matters to any other user-space app. (or if
ideally one is supposed to be able to control brightness in the console
without having to load i915), but it's fine for controlling brightness
in Xorg.

Thanks,
Niel
