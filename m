Return-Path: <linux-kernel-owner+w=401wt.eu-S933051AbXJLJYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933051AbXJLJYm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 05:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760602AbXJLJOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 05:14:12 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:56032 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760107AbXJLJOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 05:14:10 -0400
Message-ID: <470F3ADB.2000704@tiscali.nl>
Date: Fri, 12 Oct 2007 11:14:03 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: bryan.wu@analog.com
CC: dmitry.torokhov@gmail.com, linux-input@atrey.karlin.mff.cuni.cz,
       linux-joystick@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH try #2] Input/Joystick Driver: add support AD7142 joystick
 driver
References: <1192174727.6247.20.camel@roc-laptop>
In-Reply-To: <1192174727.6247.20.camel@roc-laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan Wu wrote:
> +static int ad7142_i2c_read(struct i2c_client *client, unsigned short offset,
> +		unsigned short *data, unsigned int len)
> +{
> +	int ret = -1;
> +	int i;
> +	u8 block_data[32];
> +
> +	if (len < 1 && len > 16) {

you want || here

> +		printk(KERN_ERR "AD7142: read data length error\n");
> +		return ret;
> +	}
> +
> +	/* Do raw I2C, not smbus compatible */
> +	block_data[0] = (offset & 0xFF00) >> 8;
> +	block_data[1] = (offset & 0x00FF);
> +
> +	ret = i2c_master_send(client, block_data, 2);
> +	if (ret < 0) {
> +		printk(KERN_ERR "AD7142: I2C read error\n");
> +		return ret;
> +	}
> +
> +	ret = i2c_master_recv(client, block_data, len * 2);
> +	if (ret < 0) {
> +		printk(KERN_ERR "AD7142: I2C transfer error\n");
> +		return ret;
> +	}
> +
> +	for (i = 0; i < len; i++) {
> +		unsigned short temp;
> +		temp = block_data[2 * i];
> +		temp = (temp << 8) & 0xFF00;
> +		*data++ = temp | block_data[2 * i + 1];
> +	}
> +
> +	return ret;
> +}


