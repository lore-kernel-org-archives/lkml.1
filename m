Return-Path: <linux-kernel-owner+w=401wt.eu-S1762892AbXJNSDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762892AbXJNSDy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 14:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757875AbXJNSDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 14:03:45 -0400
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1645 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758274AbXJNSDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 14:03:44 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6 patch] ivtv: fix NULL dereference
Date: Sun, 14 Oct 2007 20:03:20 +0200
User-Agent: KMail/1.9.7
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
References: <20071014175137.GM4211@stusta.de>
In-Reply-To: <20071014175137.GM4211@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710142003.20323.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 October 2007 19:51:37 Adrian Bunk wrote:
> We shouldn't dereference "itv" when we know it's NULL...
>
> Spotted by the Coverity checker.
>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
>
> ---
> --- linux-2.6/drivers/media/video/ivtv/ivtv-fileops.c.old	2007-10-14
> 19:17:12.000000000 +0200 +++
> linux-2.6/drivers/media/video/ivtv/ivtv-fileops.c	2007-10-14
> 19:18:05.000000000 +0200 @@ -947,7 +947,7 @@ int
> ivtv_v4l2_open(struct inode *inode,
>  	if (itv == NULL) {
>  		/* Couldn't find a device registered
>  		   on that minor, shouldn't happen! */
> -		IVTV_WARN("No ivtv device found on minor %d\n", minor);
> +		printk(KERN_WARNING "No ivtv device found on minor %d\n", minor);
>  		return -ENXIO;
>  	}


Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>

Luckily this is something that 'shoudn't happen' :-)
Oddly enough it is correct in my standalone driver.

Mauro, can you merge this with 2.6.24 as well? Or shall I add it to my 
ivtv tree with my other outstanding fixes?

Regards,

	Hans
