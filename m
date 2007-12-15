Return-Path: <linux-kernel-owner+w=401wt.eu-S1761695AbXLOXkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761695AbXLOXkj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 18:40:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753195AbXLOXk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 18:40:29 -0500
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:41384 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752539AbXLOXk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 18:40:28 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=PEgIiVBAgZqAuhZeZwTXrz3VuOWv3QuHjAyVeLvaIQN2awgCQ8nTSr68xRme4f4otWXreA8c05cBJejgDg5YI+oQswxPRecjf12Go1YBT0jPdV8Gg11KOaREILqTeDnIBuLNuSS7cnlp4sI1xCHCPK7UTXIMviPjgZXkWvVzOEU=  ;
X-YMail-OSG: wHhNBzUVM1nVyufDR2ZVVBGWWzWzwnCCBlpHffcPY76Zsja_jPIi9JOrdYzp7mDYIV9os1FIsg--
Date: Sat, 15 Dec 2007 15:40:24 -0800
From: David Brownell <david-b@pacbell.net>
To: linux-kernel@vger.kernel.org, i2c@lm-sensors.org, eric.y.miao@gmail.com
Subject: Re: [PATCH 2.6.24-rc5-mm 1/3] gpiolib: basic support for 16-bit 
 PCA9539 GPIO expander
Cc: khali@linux-fr.org, bgardner@wabtec.com
References: <f17812d70712142014s3e2bf56es9c9e2b24ed164c3e@mail.gmail.com>
In-Reply-To: <f17812d70712142014s3e2bf56es9c9e2b24ed164c3e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071215234024.2B4DA10C75D@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	/* initialize cached registers from their original values */
> +	pca9539_read_reg(chip, PCA9539_OUTPUT, &chip->reg_output);
> +	pca9539_read_reg(chip, PCA9539_DIRECTION, &chip->reg_direction);
> +
> +	/* set platform specific polarity inversion */
> +	pca9539_write_reg(chip, PCA9539_INVERT, pdata->invert);
> +
> +	ret = pca9539_init_gpio(chip);
> +	if (ret)
> +		goto out_failed;

I'm glad to see this patch no longer trashes previous chip state,
but there's still an issue in that area.  Surely the code should

	ret = pca9539_read_reg(...)
	if (ret)
		goto out_failed;

and likewise for the write?  If the chip isn't present (and thus
an I/O error is reported), its probe() should fail.

- Dave

