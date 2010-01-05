Return-Path: <linux-kernel-owner+w=401wt.eu-S932081Ab0AEQzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081Ab0AEQzV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 11:55:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754929Ab0AEQzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 11:55:18 -0500
Received: from poutre.nerim.net ([62.4.16.124]:50219 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754672Ab0AEQzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 11:55:16 -0500
Date: Tue, 5 Jan 2010 17:55:11 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
       linux-i2c@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c: test off by one in {piix4,vt596}_transaction()
Message-ID: <20100105175511.39dc6c42@hyperion.delvare>
In-Reply-To: <4B3773F2.3010703@gmail.com>
References: <4B3773F2.3010703@gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Dec 2009 15:49:22 +0100, Roel Kluin wrote:
> With `while (timeout++ < MAX_TIMEOUT)' timeout reaches MAX_TIMEOUT + 1 after the loop
> This is probably unlikely to produce a problem.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>  drivers/i2c/busses/i2c-piix4.c  |    2 +-
>  drivers/i2c/busses/i2c-viapro.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-piix4.c b/drivers/i2c/busses/i2c-piix4.c
> index 1e245e9..d8e0df0 100644
> --- a/drivers/i2c/busses/i2c-piix4.c
> +++ b/drivers/i2c/busses/i2c-piix4.c
> @@ -329,7 +329,7 @@ static int piix4_transaction(void)
>  		msleep(1);
>  
>  	/* If the SMBus is still busy, we give up */
> -	if (timeout >= MAX_TIMEOUT) {
> +	if (timeout > MAX_TIMEOUT) {
>  		dev_err(&piix4_adapter.dev, "SMBus Timeout!\n");
>  		result = -ETIMEDOUT;
>  	}
> diff --git a/drivers/i2c/busses/i2c-viapro.c b/drivers/i2c/busses/i2c-viapro.c
> index e4b1543..8a2e0d5 100644
> --- a/drivers/i2c/busses/i2c-viapro.c
> +++ b/drivers/i2c/busses/i2c-viapro.c
> @@ -168,7 +168,7 @@ static int vt596_transaction(u8 size)
>  	} while ((temp & 0x01) && (timeout++ < MAX_TIMEOUT));
>  
>  	/* If the SMBus is still busy, we give up */
> -	if (timeout >= MAX_TIMEOUT) {
> +	if (timeout > MAX_TIMEOUT) {
>  		result = -ETIMEDOUT;
>  		dev_err(&vt596_adapter.dev, "SMBus timeout!\n");
>  	}

That's right... but I'd rather change the loops to use "++timeout" and
leave the conditions as is (or maybe change it to "=="). I think it's
easier to read that way. Would that be OK with you?

-- 
Jean Delvare
