Return-Path: <linux-kernel-owner+w=401wt.eu-S1760705AbYELCqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760705AbYELCqV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 22:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbYELCqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 22:46:12 -0400
Received: from topsns2.toshiba-tops.co.jp ([202.230.225.126]:46303 "EHLO
	topsns2.toshiba-tops.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753992AbYELCqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 22:46:10 -0400
Date: Mon, 12 May 2008 11:45:44 +0900 (JST)
Message-Id: <20080512.114544.41629483.nemoto@toshiba-tops.co.jp>
To: macro@linux-mips.org
Cc: khali@linux-fr.org, david-b@pacbell.net, a.zummo@towertech.it,
       ab@mycable.de, anemo@mba.ocn.ne.jp, i2c@lm-sensors.org,
       rtc-linux@googlegroups.com, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 4/4] RTC: SMBus support for the M41T80
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <Pine.LNX.4.55.0805110045010.18978@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0805100116290.10552@cliff.in.clinika.pl>
	<20080510103544.701c7b3f@hyperion.delvare>
	<Pine.LNX.4.55.0805110045010.18978@cliff.in.clinika.pl>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 May 2008 02:59:34 +0100 (BST), "Maciej W. Rozycki" <macro@linux-mips.org> wrote:
>  If we agree on this one, I will retest and submit the whole batch again,
> updated as needed.

Works OK for me (m41t80 + i2c-gpio).

Tested-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

One minor style comment.

> +	if (i2c_check_functionality(client->adapter,
> +				    I2C_FUNC_SMBUS_WRITE_I2C_BLOCK)) {
> +		i = i2c_smbus_write_i2c_block_data(client, reg, num, buf);
> +	} else {
> +		for (i = 0; i < num; i++) {
> +			rc = i2c_smbus_write_byte_data(client, reg + i,
> +						       buf[i]);
> +			if (rc < 0) {
> +				i = rc;
> +				goto out;
> +			}
> +		}
>  	}
> +out:
> +	return i;

This part can be a bit shorter.

	if (i2c_check_functionality(client->adapter,
				    I2C_FUNC_SMBUS_WRITE_I2C_BLOCK))
		return i2c_smbus_write_i2c_block_data(client, reg, num, buf);
	for (i = 0; i < num; i++) {
		rc = i2c_smbus_write_byte_data(client, reg + i, buf[i]);
		if (rc < 0)
			return rc;
	}
	return i;

Saves 6 lines.  Not a big issue.

---
Atsushi Nemoto

