Return-Path: <linux-kernel-owner+w=401wt.eu-S1757795AbXH2JKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757795AbXH2JKV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 05:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754336AbXH2JKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 05:10:08 -0400
Received: from smtp-103-wednesday.noc.nerim.net ([62.4.17.103]:1402 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751329AbXH2JKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 05:10:07 -0400
Date: Wed, 29 Aug 2007 11:10:52 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [PATCH] hwmon: Add power meters to
 Documentation/hwmon/sysfs-interface
Message-ID: <20070829111052.503a73a5@hyperion.delvare>
In-Reply-To: <20070828164440.GL32667@tree.beaverton.ibm.com>
References: <20070827211446.GG32667@tree.beaverton.ibm.com>
	<20070828015029.GA10107@khazad-dum.debian.net>
	<20070828131942.18449886@hyperion.delvare>
	<20070828164440.GL32667@tree.beaverton.ibm.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Darrick,

On Tue, 28 Aug 2007 09:44:40 -0700, Darrick J. Wong wrote:
> Update the hwmon sysfs interface documentation to include a specification
> for power meters.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
> 
>  Documentation/hwmon/sysfs-interface |   15 +++++++++++++++
>  1 files changed, 15 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/hwmon/sysfs-interface b/Documentation/hwmon/sysfs-interface
> index b3a9e1b..da546ce 100644
> --- a/Documentation/hwmon/sysfs-interface
> +++ b/Documentation/hwmon/sysfs-interface
> @@ -304,6 +304,21 @@ curr[1-*]_input	Current input value
>  		Unit: milliampere
>  		RO
>  
> +*********
> +* Power *
> +*********
> +
> +power[1-*]_input	Current power use
> +			Unit: milliWatt
> +			RO
> +
> +power[1-*]_max_input	Historical maximum power use
> +			Unit: milliWatt
> +			RO
> +
> +power[1-*]_min_input	Historical minimum power use
> +			Unit: milliWatt
> +			RO
>  

I'm not sure if we want these "historical" files. We don't have them for
the other input types, and I believe that it's not the driver's job to
compute and export these values. If anyone cares about the history of
sensed values, that's something for a user-space application to
implement. This will also be much more flexible in user-space, as it
becomes possible to decide the exact time range to consider, to
remember at which time the peak occurred, etc.

-- 
Jean Delvare
