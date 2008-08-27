Return-Path: <linux-kernel-owner+w=401wt.eu-S1754257AbYH0IMJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257AbYH0IMJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 04:12:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752795AbYH0ILz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 04:11:55 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:60325 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbYH0ILx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 04:11:53 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] USB: add USB test and measurement class driver
Date: Wed, 27 Aug 2008 10:13:06 +0200
User-Agent: KMail/1.9.9
Cc: linux-usb@vger.kernel.org, Stefan Kopp <stefan_kopp@agilent.com>,
       Marcel Janssen <korgull@home.nl>, Felipe Balbi <me@felipebalbi.com>,
       linux-kernel@vger.kernel.org
References: <20080827000501.GA29570@kroah.com>
In-Reply-To: <20080827000501.GA29570@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Message-Id: <200808271013.07561.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m7R8CDdq018130

Am Mittwoch 27 August 2008 02:05:01 schrieb Greg KH:> +static ssize_t usbtmc_read(struct file *filp, char __user *buf,> +                          size_t count, loff_t *f_pos)> +{> +       struct usbtmc_device_data *data;> +       struct device *dev;> +       unsigned long int n_characters;> +       u8 *buffer;> +       int actual;> +       int done;> +       int remaining;> +       int retval;> +       int this_part;> +> +       /* Get pointer to private data structure */> +       data = filp->private_data;> +       dev = &data->intf->dev;> +       buffer = data->buffer;> +> +       remaining = count;> +       done = 0;> +> +       while (remaining > 0) {> +               if (remaining > USBTMC_SIZE_IOBUFFER - 12 - 3)> +                       this_part = USBTMC_SIZE_IOBUFFER - 12 - 3;> +               else> +                       this_part = remaining;> +> +               /* Setup IO buffer for DEV_DEP_MSG_IN message> +                * Refer to class specs for details> +                */> +               buffer[0] = 2;> +               buffer[1] = data->bTag;> +               buffer[2] = ~(data->bTag);> +               buffer[3] = 0; /* Reserved */> +               buffer[4] = (this_part - 12 - 3) & 255;> +               buffer[5] = ((this_part - 12 - 3) >> 8) & 255;> +               buffer[6] = ((this_part - 12 - 3) >> 16) & 255;> +               buffer[7] = ((this_part - 12 - 3) >> 24) & 255;> +               buffer[8] = data->TermCharEnabled * 2;> +               /* Use term character? */> +               buffer[9] = data->TermChar;> +               buffer[10] = 0; /* Reserved */> +               buffer[11] = 0; /* Reserved */
This function will go bad if concurrent readers enter, yet it has no locking.
	Regards		Oliver
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
