Return-Path: <linux-kernel-owner+w=401wt.eu-S1753761AbXLEPav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761AbXLEPav (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 10:30:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751865AbXLEPao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 10:30:44 -0500
Received: from mba.ocn.ne.jp ([122.1.235.107]:50767 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbXLEPan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 10:30:43 -0500
Date: Thu, 06 Dec 2007 00:32:58 +0900 (JST)
Message-Id: <20071206.003258.115905122.anemo@mba.ocn.ne.jp>
To: andy.sharp@onstor.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       p_gortmaker@yahoo.com, a.zummo@towertech.it
Subject: Re: [PATCH] Platform real time clock driver for Dallas 1511 chip.
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20071205004643.GA15429@onstor.com>
References: <20071205004643.GA15429@onstor.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Dec 2007 16:46:51 -0800, Andrew Sharp <andy.sharp@onstor.com> wrote:
> +struct rtc_plat_data {
> +	struct rtc_device *rtc;
> +	void __iomem *ioaddr;		/* virtual base address */
> +	unsigned long baseaddr;		/* physical base address */
> +	int size;				/* amount of memory mapped */
> +	int irq;
> +	unsigned int irqen;
> +	int alrm_sec;
> +	int alrm_min;
> +	int alrm_hour;
> +	int alrm_mday;
> +};
> +
> +static DEFINE_SPINLOCK(ds1511_lock);
> +
> +static __iomem char *ds1511_base;

If you used ds1511_base, ioaddr in rtc_plat_data is not needed.

> + static noinline void
> +rtc_write(uint8_t val, uint32_t reg)
> +{
> +	writeb(val, ds1511_base + (reg * reg_spacing));
> +}

Still "noinline" here and there.

> +static struct bin_attribute ds1511_nvram_attr = {
> +	.attr = {
> +		.name = "nvram",
> +		.mode = S_IRUGO | S_IWUGO,
> +		.owner = THIS_MODULE,
> +	},
> +	.size = DS1511_RAM_MAX,
> +	.read = ds1511_nvram_read,
> +	.write = ds1511_nvram_write,
> +};

It would be better to use S_IWUSR instead of S_IWUGO.  Please check
rtc-ds1553 changes in current git tree.

> +static struct platform_driver ds1511_rtc_driver = {
> +	.probe		= ds1511_rtc_probe,
> +	.remove		= __devexit_p(ds1511_rtc_remove),
> +	.driver		= {
> +		.name	= "ds1511",
> +		.owner	= THIS_MODULE,
> +	},
> +};

Use "rtc-ds1511" for driver name for hotplugging.  Please check
rtc-ds1553 changes in current git tree.

> + static void __exit
> +ds1511_rtc_exit(void)
> +{
> +	return platform_driver_unregister(&ds1511_rtc_driver);
> +}

Do not return void value.  Please check rtc-ds1553 changes in current
git tree.

---
Atsushi Nemoto
