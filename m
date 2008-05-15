Return-Path: <linux-kernel-owner+w=401wt.eu-S1757532AbYEOKNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532AbYEOKNX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 06:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753555AbYEOKNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 06:13:16 -0400
Received: from mx0.towertech.it ([213.215.222.73]:47629 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753532AbYEOKNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 06:13:15 -0400
Date: Thu, 15 May 2008 12:13:12 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: Kim.Heino@bluegiga.com, linux-kernel@vger.kernel.org
Subject: Re: [rtc-linux] [PATCH] add support for ST M41T94 SPI RTC (patch
 rev. 2)
Message-ID: <20080515121312.4af159d9@i1501.lan.towertech.it>
In-Reply-To: <482C0801.7030007@bluegiga.com>
References: <482C0801.7030007@bluegiga.com>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2008 12:53:05 +0300
"Kim B. Heino" <Kim.Heino@bluegiga.com> wrote:

> 
> +struct m41t94 {
> +	struct rtc_device *rtc;
> +};

 [...]


> +
> +static int __devinit m41t94_probe(struct spi_device *spi)
> +{
> +	struct rtc_device *rtc;
> +	struct m41t94 *m41t94;
> +	int res;
> +
> +	m41t94 = kzalloc(sizeof(struct m41t94), GFP_KERNEL);
> +	if (!m41t94)
> +		return -ENOMEM;
> +	dev_set_drvdata(&spi->dev, m41t94);

 [..]

> +	rtc = rtc_device_register(m41t94_driver.driver.name,
> +		&spi->dev, &m41t94_rtc_ops, THIS_MODULE);
> +	if (IS_ERR(rtc)) {
> +		kfree(m41t94);
> +		return PTR_ERR(rtc);
> +	}
> +
> +	m41t94->rtc = rtc;
> +
> +	return 0;
> +}
>

 thanks for having implemented the sugestions.

 one more thing. now that the struct m41t94 is
 almost empty it makes no sense to keep it.

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

