Return-Path: <linux-kernel-owner+w=401wt.eu-S1755359AbYAQMY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbYAQMY4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 07:24:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751253AbYAQMYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 07:24:48 -0500
Received: from cavan.codon.org.uk ([78.32.9.130]:34254 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbYAQMYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 07:24:46 -0500
Date: Thu, 17 Jan 2008 12:24:31 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Zhang Rui <rui.zhang@intel.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       sujith.thomas@intel.com
Message-ID: <20080117122431.GA32133@srcf.ucam.org>
References: <1200556282.2935.122.camel@acpi-sony.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200556282.2935.122.camel@acpi-sony.sh.intel.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH 6/10] ACPI: register ACPI Video LCD as generic thermal cooling device
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2008 at 03:51:22PM +0800, Zhang Rui wrote:
> From: Zhang Rui <rui.zhang@intel.com>
> 
> Register ACPI video device as thermal cooling devices as they may be listed
> in _TZD method and the backlight control can be used for throttling.

I'm worried to some extent about how ungeneric this is. A thermal zone 
may cover any devices, not just processor and video ones. Perhaps this 
should be added to the acpi_device struct instead, and then let 
individual drivers implement whatever callbacks are appropriate?

> +static int
> +video_set_cur_state(struct thermal_cooling_device *cdev, unsigned int state)
> +{
> +	struct acpi_device *device = cdev->devdata;
> +	struct acpi_video_device *video = acpi_driver_data(device);
> +	int level;
> +
> +	if ( state >= video->brightness->count - 2)
> +		return -EINVAL;
> +
> +	state = video->brightness->count - state;
> +	level = video->brightness->levels[state -1];
> +	return acpi_video_device_lcd_set_level(video, level);

This all seems like duplication of the backlight interface?

(Speaking of which - Len, what's happening with my patches to the video 
driver? Some feedback would be nice)

-- 
Matthew Garrett | mjg59@srcf.ucam.org
