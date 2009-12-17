Return-Path: <linux-kernel-owner+w=401wt.eu-S1765159AbZLQRhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765159AbZLQRhj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 12:37:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757590AbZLQRhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 12:37:35 -0500
Received: from exsmtp012-12.exch012.intermedia.net ([64.78.17.143]:38918 "HELO
	EXSMTP012-12.exch012.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1765054AbZLQRhe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 12:37:34 -0500
x-mimeole: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [lm-sensors] [PATCH 1/2] Wrong ADT7462_VOLT_COUNT for linux-2.6.30  adt7462 hwmon driver
Date: Thu, 17 Dec 2009 09:37:32 -0800
Message-ID: <AFEAE911EE22F64BACAB05ED86B4D4FC01C5CF2C@EXVBE012-13.exch012.intermedia.net>
In-Reply-To: <20091217171445.0bd28259@hyperion.delvare>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [lm-sensors] [PATCH 1/2] Wrong ADT7462_VOLT_COUNT for linux-2.6.30  adt7462 hwmon driver
Thread-Index: Acp/NA6fXJNCk1SyS+eaCGwo7U0ZygAC0qDA
References: <AFEAE911EE22F64BACAB05ED86B4D4FC018DA312@EXVBE012-13.exch012.intermedia.net><AFEAE911EE22F64BACAB05ED86B4D4FC018DA31A@EXVBE012-13.exch012.intermedia.net><AFEAE911EE22F64BACAB05ED86B4D4FC018DA328@EXVBE012-13.exch012.intermedia.net> <20091217171445.0bd28259@hyperion.delvare>
From: "Ray Copeland" <ray.copeland@aprius.com>
To: "Jean Delvare" <khali@linux-fr.org>
Cc: <linux-kernel@vger.kernel.org>, <lm-sensors@lm-sensors.org>
X-OriginalArrivalTime: 17 Dec 2009 17:37:34.0205 (UTC) FILETIME=[9DE30AD0:01CA7F3F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Jean, thanks for letting me know.  This is my first time sending a
patch, and I should have sent
it first to Darrick to have him review it before I posted directly to
the group.  He told me how to
rework it properly so that I will do it right next time.

Sorry if this caused any problem for you.

Regards,

Ray Copeland

-----Original Message-----
From: Jean Delvare [mailto:khali@linux-fr.org] 
Sent: Thursday, December 17, 2009 8:15 AM
To: Ray Copeland
Cc: linux-kernel@vger.kernel.org; lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH 1/2] Wrong ADT7462_VOLT_COUNT for
linux-2.6.30 adt7462 hwmon driver

Hi Ray,

On Wed, 16 Dec 2009 17:26:19 -0800, Ray Copeland wrote:
> From: Ray Copeland <ray.copeland@aprius.com>
> Date: Wed, 16 Dec 2009
> Subject: [PATCH 1/2] Wrong ADT7462_VOLT_COUNT for linux-2.6.30 adt7462
hwmon driver 
> 
> Description:
> 
> The #define ADT7462_VOLT_COUNT is wrong, it should be 13 not 12. All
the 
> for loops that use this as a limit count are of the typical form, "for

> (n = 0; n < ADT7462_VOLT_COUNT; n++)", so to loop through all voltages

> w/o missing the last one it is necessary for the count to be one
greater 
> than it is.  (Specifically, you will miss the +1.5V 3GPIO input with
count 
> = 12 vs. 13.)
> 
> Signed-off-by: Ray Copeland <ray.copeland@aprius.com>
> 
> Diff with changes vs. original adt7462.c 2.6.30 version:
> 
> --- adt7462.c.orig      2009-12-15 15:51:05.000000000 -0800
> +++ adt7462.c.volt_count        2009-12-16 14:06:01.000000000 -0800
> @@ -182,7 +182,7 @@
>   *
>   * Some, but not all, of these voltages have low/high limits.
>   */
> -#define ADT7462_VOLT_COUNT     12
> +#define ADT7462_VOLT_COUNT     13
> 
>  #define ADT7462_VENDOR         0x41
>  #define ADT7462_DEVICE         0x62

While the patch looks functionally correct, it is horribly broken in
its format. You sent a HTML mail instead of only plain text. Your
mailer turned the tabs into spaces. And the paths are missing from the
patch header.

Please learn how to send proper patches that kernel maintainers can
apply. Documentation/SubmittingPatches is a good start.

-- 
Jean Delvare
