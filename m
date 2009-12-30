Return-Path: <linux-kernel-owner+w=401wt.eu-S1753175AbZL3TdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175AbZL3TdP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 14:33:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753052AbZL3TdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 14:33:14 -0500
Received: from mail.perches.com ([173.55.12.10]:1465 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752931AbZL3TdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 14:33:13 -0500
Subject: Re: [PATCH] drivers/message/i2o/i2o_proc.c: use %pM to show MAC
 address
From: Joe Perches <joe@perches.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE19090200F659@mi8nycmail19.Mi8.com>
References: <BD79186B4FD85F4B8E60E381CAEE19090200F659@mi8nycmail19.Mi8.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Dec 2009 11:33:12 -0800
Message-ID: <1262201592.2545.45.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-30 at 14:22 -0500, H Hartley Sweeten wrote:
> Use the %pM kernel extension to display the MAC address.
> diff --git a/drivers/message/i2o/i2o_proc.c b/drivers/message/i2o/i2o_proc.c
> index 7045c45..949a648 100644
> --- a/drivers/message/i2o/i2o_proc.c
> +++ b/drivers/message/i2o/i2o_proc.c
> @@ -111,10 +111,7 @@ static int print_serial_number(struct seq_file *seq, u8 * serialno, int max_len)
>  		break;
>  
>  	case I2O_SNFORMAT_LAN48_MAC:	/* LAN-48 MAC Address */
> -		seq_printf(seq,
> -			   "LAN-48 MAC address @ %02X:%02X:%02X:%02X:%02X:%02X",
> -			   serialno[2], serialno[3],
> -			   serialno[4], serialno[5], serialno[6], serialno[7]);
> +		seq_printf(seq, "LAN-48 MAC address @ %pM", &serialno[2]);
>  		break;
>  
>  	case I2O_SNFORMAT_WAN:	/* WAN MAC Address */
> @@ -126,10 +123,8 @@ static int print_serial_number(struct seq_file *seq, u8 * serialno, int max_len)
>  	case I2O_SNFORMAT_LAN64_MAC:	/* LAN-64 MAC Address */
>  		/* FIXME: Figure out what a LAN-64 address really looks like?? */
>  		seq_printf(seq,
> -			   "LAN-64 MAC address @ [?:%02X:%02X:?] %02X:%02X:%02X:%02X:%02X:%02X",
> -			   serialno[8], serialno[9],
> -			   serialno[2], serialno[3],
> -			   serialno[4], serialno[5], serialno[6], serialno[7]);
> +			   "LAN-64 MAC address @ [?:%02X:%02X:?] %pM",
> +			   serialno[8], serialno[9], &serialno[2]);

User visible change but low probability to break things

