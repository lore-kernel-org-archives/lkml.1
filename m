Return-Path: <linux-kernel-owner+w=401wt.eu-S1755425AbZDXJnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425AbZDXJnU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 05:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752276AbZDXJnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 05:43:09 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:4832 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbZDXJnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 05:43:07 -0400
Date: Fri, 24 Apr 2009 11:42:59 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Dave Airlie <airlied@gmail.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org, stable@kernel.org,
       Dave Airlie <airlied@redhat.com>
Subject: Re: [PATCH] i2c: fix bit algorithm timeout for low values.
Message-ID: <20090424114259.70f74ccd@hyperion.delvare>
In-Reply-To: <1240528153-5370-1-git-send-email-airlied@gmail.com>
References: <1240528153-5370-1-git-send-email-airlied@gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On Fri, 24 Apr 2009 09:09:13 +1000, Dave Airlie wrote:
> From: Dave Airlie <airlied@redhat.com>
> 
> When fetching DDC using i2c algo bit, we were often seeing timeouts
> before getting valid EDID on a retry. The VESA spec states 2ms is the
> DDC timeout, so when this translates into 1 jiffie and we are close
> to the end of the time period, it could return with a timeout less than
> 2ms.
> 
> Change this code to use time_after instead of time_after_eq.
> 
> Signed-off-by: Dave Airlie <airlied@redhat.com>
> ---
>  drivers/i2c/algos/i2c-algo-bit.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/i2c/algos/i2c-algo-bit.c b/drivers/i2c/algos/i2c-algo-bit.c
> index d420cc5..e25e139 100644
> --- a/drivers/i2c/algos/i2c-algo-bit.c
> +++ b/drivers/i2c/algos/i2c-algo-bit.c
> @@ -104,7 +104,7 @@ static int sclhi(struct i2c_algo_bit_data *adap)
>  		 * chips may hold it low ("clock stretching") while they
>  		 * are processing data internally.
>  		 */
> -		if (time_after_eq(jiffies, start + adap->timeout))
> +		if (time_after(jiffies, start + adap->timeout))
>  			return -ETIMEDOUT;
>  		cond_resched();
>  	}

Applied, thanks. I agree this should go in stable.

-- 
Jean Delvare
