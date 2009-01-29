Return-Path: <linux-kernel-owner+w=401wt.eu-S1757329AbZA2IeM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329AbZA2IeM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 03:34:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbZA2Id4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 03:33:56 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37520 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751317AbZA2Idz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 03:33:55 -0500
Date: Thu, 29 Jan 2009 00:33:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Henrik Rydberg" <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] input: bcm5974: Prepare for a new trackpad header
 type
Message-Id: <20090129003321.e9c8c36c.akpm@linux-foundation.org>
In-Reply-To: <1233138229-12489-2-git-send-email-rydberg@euromail.se>
References: <1233138229-12489-1-git-send-email-rydberg@euromail.se>
	<1233138229-12489-2-git-send-email-rydberg@euromail.se>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2009 11:23:44 +0100 "Henrik Rydberg" <rydberg@euromail.se> wrote:

> static int report_tp_state(struct bcm5974 *dev, int size)
>  {
>  	const struct bcm5974_config *c = &dev->cfg;
> -	const struct tp_finger *f = dev->tp_data->finger;
> +	const struct tp_finger *f;
>  	struct input_dev *input = dev->input;
> -	const int fingers = (size - 26) / 28;
> -	int raw_p, raw_w, raw_x, raw_y;
> +	int raw_p, raw_w, raw_x, raw_y, raw_n;
>  	int ptest = 0, origin = 0, nmin = 0, nmax = 0;
>  	int abs_p = 0, abs_w = 0, abs_x = 0, abs_y = 0;
>  
> -	if (size < 26 || (size - 26) % 28 != 0)
> +	if (size < c->tp_offset || (size - c->tp_offset) % SIZEOF_FINGER != 0)
>  		return -EIO;
>  
> +	f = (const struct tp_finger *)(dev->tp_data + c->tp_offset);

Is there anything which guarantees that `f' is sufficiently aligned? 
If not, the code might cause unaligned exceptions on some
architectures?

