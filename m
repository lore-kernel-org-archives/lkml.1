Return-Path: <linux-kernel-owner+w=401wt.eu-S1759151AbZFSXGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759151AbZFSXGS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 19:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753830AbZFSXGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 19:06:09 -0400
Received: from www.tglx.de ([62.245.132.106]:36561 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948AbZFSXGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 19:06:08 -0400
Date: Sat, 20 Jun 2009 01:02:52 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: hjk@linutronix.de, lm-sensors@lm-sensors.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] HWMON: max6650, fix lock imbalance
Message-ID: <20090619230252.GB3862@local>
References: <1245446795-1901-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245446795-1901-1-git-send-email-jirislaby@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 19, 2009 at 11:26:35PM +0200, Jiri Slaby wrote:
> Add omitted update_lock to one switch/case in set_div.

Ahem, yes, thanks!

> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

Signed-off-by: Hans J. Koch <hjk@linutronix.de>

> ---
>  drivers/hwmon/max6650.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hwmon/max6650.c b/drivers/hwmon/max6650.c
> index 86142a8..58f66be 100644
> --- a/drivers/hwmon/max6650.c
> +++ b/drivers/hwmon/max6650.c
> @@ -418,6 +418,7 @@ static ssize_t set_div(struct device *dev, struct device_attribute *devattr,
>  		data->count = 3;
>  		break;
>  	default:
> +		mutex_unlock(&data->update_lock);
>  		dev_err(&client->dev,
>  			"illegal value for fan divider (%d)\n", div);
>  		return -EINVAL;
> -- 
> 1.6.3.2
