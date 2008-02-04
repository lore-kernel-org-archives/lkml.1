Return-Path: <linux-kernel-owner+w=401wt.eu-S1754696AbYBDIOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696AbYBDIOn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 03:14:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753398AbYBDIOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 03:14:36 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:34964 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176AbYBDIOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 03:14:35 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47A6C962.4080605@s5r6.in-berlin.de>
Date: Mon, 04 Feb 2008 09:14:26 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: linux1394-devel@lists.sourceforge.net
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] firewire: log GUID of new devices
References: <tkrat.f34e34fd91a0695f@s5r6.in-berlin.de> <tkrat.4304cda1ec1be99d@s5r6.in-berlin.de>
In-Reply-To: <tkrat.4304cda1ec1be99d@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> -	else
> -		fw_notify("created new fw device %s "
> -			  "(%d config rom retries, S%d00)\n",
> -			  device->device.bus_id, device->config_rom_retries,
> -			  1 << device->max_speed);
> +	} else {
> +		if (device->config_rom_retries)
> +			fw_notify("created device %s: GUID %08x%08x, S%d00, "
> +				  "%d config ROM retries\n",
> +				  device->device.bus_id,
> +				  device->config_rom[3], device->config_rom[4],
> +				  1 << device->max_speed,
> +				  device->config_rom_retries);

Still to do:  If the ROM reading failed, log how it failed and what was
read up until the failure.
-- 
Stefan Richter
-=====-==--- --=- --=--
http://arcgraph.de/sr/
