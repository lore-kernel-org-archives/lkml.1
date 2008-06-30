Return-Path: <linux-kernel-owner+w=401wt.eu-S1762458AbYF3XPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762458AbYF3XPS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 19:15:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754823AbYF3XPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 19:15:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53313 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754682AbYF3XPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 19:15:02 -0400
Date: Mon, 30 Jun 2008 16:13:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: maximilian attems <max@stro.at>
Cc: khali@linux-fr.org, linux-kernel@vger.kernel.org, max@stro.at,
       ubuntu@hjernemadsen.org, zulcss@ubuntu.com, tim.gardner@canonical.com,
       "Mark M. Hoffman" <mhoffman@lightlink.com>, stable@kernel.org
Subject: Re: [PATCH] hdaps add support for various newer Lenovo thinkpads
Message-Id: <20080630161350.93d3b569.akpm@linux-foundation.org>
In-Reply-To: <1213568808-6184-1-git-send-email-max@stro.at>
References: <1213568808-6184-1-git-send-email-max@stro.at>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2008 00:26:48 +0200
maximilian attems <max@stro.at> wrote:

> adds R61, T61p, X61s, X61, Z61m, Z61p models to whitelist.
> 
> originally based on an Ubuntu patch that got it wrong,
> the dmidecode output of the corresponding laptops
> shows LENOVO as the manufacturer.
> https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.22/+bug/133636
> 
> tested on X61s:
> [  184.893588] hdaps: inverting axis readings.
> [  184.893588] hdaps: LENOVO ThinkPad X61s detected.
> [  184.893588] input: hdaps as /class/input/input12
> [  184.924326] hdaps: driver successfully loaded.
> 
> original authors below on Cc.

I enhanced the changelog a little so that it shows what we're actually
fixing.

> Cc: Klaus S. Madsen <ubuntu@hjernemadsen.org>
> Cc: Chuck Short <zulcss@ubuntu.com>
> Cc: Jean Delvare <khali@linux-fr.org>
> Cc: Tim Gardner <tim.gardner@canonical.com>
> Signed-off-by: maximilian attems <max@stro.at>
> ---
>  drivers/hwmon/hdaps.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hwmon/hdaps.c b/drivers/hwmon/hdaps.c
> index 26df06f..50f2269 100644
> --- a/drivers/hwmon/hdaps.c
> +++ b/drivers/hwmon/hdaps.c
> @@ -516,17 +516,23 @@ static struct dmi_system_id __initdata hdaps_whitelist[] = {
>  	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad R51"),
>  	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad R52"),
>  	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad R61i"),
> +	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad R61"),
>  	HDAPS_DMI_MATCH_INVERT("IBM", "ThinkPad T41p"),
>  	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad T41"),
>  	HDAPS_DMI_MATCH_INVERT("IBM", "ThinkPad T42p"),
>  	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad T42"),
>  	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad T43"),
>  	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad T60"),
> +	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad T61p"),
>  	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad T61"),
>  	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad X40"),
>  	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad X41"),
>  	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad X60"),
> +	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad X61s"),
> +	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad X61"),
>  	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad Z60m"),
> +	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad Z61m"),
> +	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad Z61p"),
>  	{ .ident = NULL }
>  };
>  

Thanks, I'll queue this for 2.6.26 and will also recommend it for a
2.6.25.x backport.

