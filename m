Return-Path: <linux-kernel-owner+w=401wt.eu-S1755573AbXIQRZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573AbXIQRZ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 13:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752682AbXIQRZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 13:25:19 -0400
Received: from smtp-101-monday.nerim.net ([62.4.16.101]:53704 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751285AbXIQRZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 13:25:18 -0400
Date: Mon, 17 Sep 2007 19:28:08 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       haveblue@us.ibm.com
Subject: Re: [PATCH v2] hwmon: Update Documentation/hwmon/sysfs-interface
Message-ID: <20070917192808.44ad60cc@hyperion.delvare>
In-Reply-To: <20070914192924.GL30825@tree.beaverton.ibm.com>
References: <20070827211446.GG32667@tree.beaverton.ibm.com>
	<20070828015029.GA10107@khazad-dum.debian.net>
	<20070828131942.18449886@hyperion.delvare>
	<20070828164905.GM32667@tree.beaverton.ibm.com>
	<20070828232504.GP32667@tree.beaverton.ibm.com>
	<20070911132335.GJ31992@jupiter.solarsys.private>
	<20070914192924.GL30825@tree.beaverton.ibm.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Darrick,

On Fri, 14 Sep 2007 12:29:24 -0700, Darrick J. Wong wrote:
> Update the hwmon sysfs interface documentation to include a specification
> for power meters.

Thanks for the update. I have some more comments. And sorry if it looks
like nitpicking, but this is a standard interface we're defining so we
better make sure that we get it right.

First of all, please think of a better subject line for this patch.
"Update Documentation/hwmon/sysfs-interface" is too vague when your
patch is rather specific.

> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
> 
>  Documentation/hwmon/sysfs-interface |   30 ++++++++++++++++++++++++++++++
>  1 files changed, 30 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/hwmon/sysfs-interface b/Documentation/hwmon/sysfs-interface
> index db7bb4a..5c98bee 100644
> --- a/Documentation/hwmon/sysfs-interface
> +++ b/Documentation/hwmon/sysfs-interface
> @@ -324,6 +324,36 @@ curr[1-*]_input	Current input value
>  		Unit: milliampere
>  		RO
>  
> +*********
> +* Power *
> +*********
> +
> +power[1-*]_average		Average power use
> +				Unit: microWatt
> +				RO
> +
> +power[1-*]_average_highest	Historical average maximum power use
> +				Unit: microWatt
> +				RO
> +
> +power[1-*]_average_lowest	Historical average minimum power use
> +				Unit: microWatt
> +				RO

How useful are historical extremes of an average?

> +
> +power[1-*]_input		Instantaneous power use
> +				Unit: microWatt
> +				RO
> +
> +power[1-*]_input_highest	Historical maximum power use
> +				Unit: microWatt
> +				RO
> +
> +power[1-*]_input_lowest		Historical minimum power use
> +				Unit: microWatt
> +				RO
> +
> +power[1-*]_high_low_reset	Reset input_highest/input_lowest.
> +				WO

I don't much like this name. It sounds like a name crafted for the
specific feature of a given chip, while we try to use generic names for
the standard interface. I would rather go for power[1-*]_reset_history
if we have a single file for resetting all the extremes of a given
channel, or power[1-*]_input_lowest_reset and
power[1-*]_input_highest_reset if we go for a per-value reset.

Alternatively, we could simply make the power[1-*]_input_lowest and
power[1-*]_input_highest files writable, and "cat power1_input >
power1_input_lowest" (or any write?) would reset the history.

>  
>  **********
>  * Alarms *

Thanks,
-- 
Jean Delvare
