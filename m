Return-Path: <linux-kernel-owner+w=401wt.eu-S1755824AbYDII51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824AbYDII51 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 04:57:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755397AbYDII5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 04:57:15 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:1804 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755017AbYDII5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 04:57:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JHKcfP21UicBD/m3sbdKhEY0mhmXSmyUx6rkSnfOis0+SYw7xOe4c5zD+reXTy5s4v4DCFlygReEbJg5acsqTWlhOVTrtYwIQadr92gZTsWH9AIdvW5UNMqu0HUuoX/kTm22oZYUj9IUTPN56F+yfdoKD2as6obmRn96Gsn0lfc=
Message-ID: <427ca1a20804090157t4fa1bbcei27d3bbea085aa9c3@mail.gmail.com>
Date: Wed, 9 Apr 2008 10:57:12 +0200
From: "Jakob Bornecrantz" <wallbraker@gmail.com>
To: "Jesse Barnes" <jbarnes@virtuousgeek.org>
Subject: Re: DRM modesetting & sysfs
Cc: dri-devel@lists.sourceforge.net,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <200804081317.43712.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804081317.43712.jbarnes@virtuousgeek.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 8, 2008 at 10:17 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>
>  I just pushed a few changes updating the DRM modesetting sysfs support, both
>  for debugging and eventual HAL friendliness.
>
>  So far, the support is limited to describing outputs and generating hotplug
>  events.  A typical "card0" directory now looks like this:
>
>  .
>  |-- card0-DAC-1
>  |   |-- device -> ../../../../../../devices/pci0000:00/0000:00:02.0/drm/card0
>  |   |-- dpms
>  |   |-- edid
>  |   |-- modes
>  |   |-- power
>  |   |   `-- wakeup
>  |   |-- status
>  |   |-- subsystem -> ../../../../../../class/drm
>  |   `-- uevent
>  |-- card0-LVDS-1
>  |   |-- device -> ../../../../../../devices/pci0000:00/0000:00:02.0/drm/card0
>  |   |-- dpms
>  |   |-- edid
>  |   |-- modes
>  |   |-- power
>  |   |   `-- wakeup
>  |   |-- status
>  |   |-- subsystem -> ../../../../../../class/drm
>  |   `-- uevent
>  |-- dev
>  |-- device -> ../../../../../devices/pci0000:00/0000:00:02.0
>  |-- dri_library_name
>  |-- power
>  |   `-- wakeup
>  |-- subsystem -> ../../../../../class/drm
>  `-- uevent
>
>  Each output is listed, prefixed with its associated card number to
>  disambiguate it at the top level /sys/class/drm directory (where it also has
>  some symlinks).  Currently, only DPMS, EDID, mode list and connection status
>  properties are exported, but we could list more as needed.  You can
>  use 'udevmonitor --env' to look for hotplug events; you should see several at
>  load time, and presumably some at connection hotplug time (though I haven't
>  gotten that working yet, any ideas Jakob?).
>

I was going to suggest that you plug it into the hotplug_stage_two
function but it looks like you have already done that. Things might be
routed differently now then since the last time I looked at the code,
are you sure that stage_two is being run?

>  Any thoughts on the interface?  Anything in particular people would like to
>  see?
>

Looks good, can you write to dpms, that is turn a monitor on and of,
that would be slightly cool but not overly useful. On the whole I
think exporting properties are fine, but I don't think setting modes
and crtc's are to be done in sysfs. However it is entirely possible.

>  Thanks,
>  Jesse

Cheers Jakob.
