Return-Path: <linux-kernel-owner+w=401wt.eu-S1753249AbYC2N43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbYC2N43 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 09:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbYC2N4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 09:56:21 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:3263 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbYC2N4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 09:56:20 -0400
Date: Sat, 29 Mar 2008 14:56:03 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH 1/2] Define sysfs interfaces for ibmaem driver
Message-ID: <20080329145603.7e47418f@hyperion.delvare>
In-Reply-To: <20080328213646.GC7191@tree.beaverton.ibm.com>
References: <20080328213646.GC7191@tree.beaverton.ibm.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Darrick,

On Fri, 28 Mar 2008 14:36:46 -0700, Darrick J. Wong wrote:
> Update sysfs interface documentation to include energy meters and power
> meter averaging intervals.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
> 
>  Documentation/hwmon/sysfs-interface |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/hwmon/sysfs-interface b/Documentation/hwmon/sysfs-interface
> index f4a8ebc..85e6654 100644
> --- a/Documentation/hwmon/sysfs-interface
> +++ b/Documentation/hwmon/sysfs-interface
> @@ -328,6 +328,14 @@ curr[1-*]_input	Current input value
>  		Unit: milliampere
>  		RO
>  
> +**********
> +* Energy *
> +**********
> +
> +energy[1-*]_input		Instantaneous energy use

This doesn't make sense to me. Energy is a quantity, it exists
independently of time. An "instantaneous energy use" only makes sense
if you tell in what (presumably very small) amount of time the energy
was used... and then what you are measuring is not an energy but a
power, for which we already have an interface. Please clarify.

> +				Unit: microJoule
> +				RO
> +
>  *********
>  * Power *
>  *********
> @@ -336,6 +344,10 @@ power[1-*]_average		Average power use
>  				Unit: microWatt
>  				RO
>  
> +power[1-*]_interval		Power use averaging interval

Wouldn't power[1-*]_average_interval be clearer?

> +				Unit: milliseconds

Nitpicking for consistency: millisecond (no trailing s).

What values do you expect for this entry? I am wondering if it's safe
to use millisecond as a unit. Is it unlikely that a future chip will
support averaging intervals below the millisecond?

> +				RW
> +
>  power[1-*]_average_highest	Historical average maximum power use
>  				Unit: microWatt
>  				RO


-- 
Jean Delvare
