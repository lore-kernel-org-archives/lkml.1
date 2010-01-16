Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976Ab0APKDF (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 05:03:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203Ab0APKDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 05:03:04 -0500
Received: from poutre.nerim.net ([62.4.16.124]:53976 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456Ab0APKDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 05:03:03 -0500
Date: Sat, 16 Jan 2010 11:02:57 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, Tomaz Mertelj <tomaz.mertelj@guest.arnes.si>
Subject: Re: [PATCH 1/1] HWMON: amc6821, fix lock imbalance
Message-ID: <20100116110257.498f2cd0@hyperion.delvare>
In-Reply-To: <1263634081-6644-1-git-send-email-jslaby@suse.cz>
References: <1263634081-6644-1-git-send-email-jslaby@suse.cz>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Jan 2010 10:28:01 +0100, Jiri Slaby wrote:
> Stanse found a lock imbalance in set_fan1_div. data->update_lock
> is unlocked twice on a fail path.
> 
> Triggerable by writing value other than 2 and 4 to fan1_div.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Tomaz Mertelj <tomaz.mertelj@guest.arnes.si>
> Cc: Jean Delvare <khali@linux-fr.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  drivers/hwmon/amc6821.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/hwmon/amc6821.c b/drivers/hwmon/amc6821.c
> index 1c89d92..fa9708c 100644
> --- a/drivers/hwmon/amc6821.c
> +++ b/drivers/hwmon/amc6821.c
> @@ -686,7 +686,6 @@ static ssize_t set_fan1_div(
>  		data->fan1_div = 4;
>  		break;
>  	default:
> -		mutex_unlock(&data->update_lock);
>  		count = -EINVAL;
>  		goto EXIT;
>  	}

Patch pending in my queue already.
ftp://ftp.kernel.org/pub/linux/kernel/people/jdelvare/linux-2.6/jdelvare-hwmon/hwmon-amc6821-double-unlock-bug.patch

But thanks for reporting anyway.

-- 
Jean Delvare
