Return-Path: <linux-kernel-owner+w=401wt.eu-S1757290AbZCBXGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290AbZCBXGS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 18:06:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750948AbZCBXGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 18:06:03 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54755 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750796AbZCBXGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 18:06:01 -0500
Date: Mon, 2 Mar 2009 15:04:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: djwong@us.ibm.com
Cc: khali@linux-fr.org, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [PATCH] lm90: Support the MAX6648/6692 chips
Message-Id: <20090302150426.b22100c1.akpm@linux-foundation.org>
In-Reply-To: <20090302210106.GD6550@plum>
References: <20090302210106.GD6550@plum>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Mar 2009 13:01:06 -0800
"Darrick J. Wong" <djwong@us.ibm.com> wrote:

> @@ -776,7 +776,12 @@ static int lm90_detect(struct i2c_client *new_client, int kind,
>  			 && (reg_config1 & 0x3f) == 0x00
>  			 && reg_convrate <= 0x07) {
>  				kind = max6646;
> -			}
> +			} else
> +			/* The MAX6648/6692 chips have a working man/chip id
> +			 * and the same register set as the 6657.
> +			 */
> +			if (chip_id == 0x59 && address == 0x4C)
> +				kind = max6657;
>  		}

gack, the indenting and layout there is totally busted.


--- a/drivers/hwmon/lm90.c~lm90-support-the-max6648-6692-chips-fix
+++ a/drivers/hwmon/lm90.c
@@ -776,12 +776,14 @@ static int lm90_detect(struct i2c_client
 			 && (reg_config1 & 0x3f) == 0x00
 			 && reg_convrate <= 0x07) {
 				kind = max6646;
-			} else
-			/* The MAX6648/6692 chips have a working man/chip id
-			 * and the same register set as the 6657.
-			 */
-			if (chip_id == 0x59 && address == 0x4C)
+			} else if (chip_id == 0x59 && address == 0x4C) {
+				/*
+				 * The MAX6648/6692 chips have a working
+				 * man/chip id and the same register set as the
+				 * 6657.
+				 */
 				kind = max6657;
+			}
 		}
 
 		if (kind <= 0) { /* identification failed */
_

