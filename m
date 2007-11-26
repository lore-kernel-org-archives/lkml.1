Return-Path: <linux-kernel-owner+w=401wt.eu-S1757010AbXKZW0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757010AbXKZW0T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 17:26:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755430AbXKZW0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 17:26:09 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54651 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755107AbXKZW0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 17:26:08 -0500
Date: Mon, 26 Nov 2007 14:25:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Starikovskiy <aystarik@gmail.com>
Cc: eike-kernel@sf-tec.de, lenb@kernel.org, linux-acpi@vger.kernel.org,
       astarikovskiy@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix segfault when printing battery status
Message-Id: <20071126142510.9f89ea0e.akpm@linux-foundation.org>
In-Reply-To: <47416EFF.3070402@gmail.com>
References: <200711182049.33355.eike-kernel@sf-tec.de>
	<47415B46.4020709@gmail.com>
	<200711191129.35144.eike-kernel@sf-tec.de>
	<47416EFF.3070402@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Nov 2007 14:09:51 +0300
Alexey Starikovskiy <aystarik@gmail.com> wrote:

> Rolf Eike Beer wrote:
> > Alexey Starikovskiy wrote:
> >   
> >> Rolf Eike Beer wrote:
> >>     
> >>> cat
> >>> /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:19/PNP0C0A:00/power_
> >>> supply/BAT1/status
> >>>
> >>> This leads to a stacktrace as acpi_battery_get_property() returns 0 for a
> >>> case where it does not set val->intval. These value is used as an array
> >>> index in
> >>> drivers/power/power_supply_sysfs.c::power_supply_show_property(). I had a
> >>> situation where the value was 4096 which caused a problem as the array
> >>> only has 5 entries.
> >>>
> >>> Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
> >>>       
> >> Rolf, thanks for remainding.
> >>     
> >
> > Huh? This one is unrelated to the problem I reported two weeks ago...
> >
> > Eike
> >   
> You are second to send the same patch, first one I already acked.
> But it seems that Len did not pick it up yet.
> Look for "ACPI: Always return valid 'status' from 
> acpi_battery_get_property()"
> if interested...
> 

This fix is in Len's tree and was in his 2.6.24-rc3 pull request to
Linus.
