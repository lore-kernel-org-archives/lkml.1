Return-Path: <linux-kernel-owner+w=401wt.eu-S1758718AbYCESVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718AbYCESVU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 13:21:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756182AbYCESVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 13:21:08 -0500
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:3396 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755948AbYCESVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 13:21:07 -0500
Subject: Re: [PATCH] em28xx-core.c: add missing parentheses in
	em28xx_write_ac97()
From: Joe Perches <joe@perches.com>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: mchehab@infradead.org, v4l-dvb-maintainer@linuxtv.org,
       video4linux-list@redhat.com, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <47CEDE8D.7090707@tiscali.nl>
References: <47CEDE8D.7090707@tiscali.nl>
Content-Type: text/plain
Date: Wed, 05 Mar 2008 10:16:14 -0800
Message-Id: <1204740974.17370.29.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.1mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-03-05 at 18:55 +0100, Roel Kluin wrote:
> diff --git a/drivers/media/video/em28xx/em28xx-core.c b/drivers/media/video/em28xx/em28xx-core.c
> index 7d1537c..da8189a 100644
> --- a/drivers/media/video/em28xx/em28xx-core.c
> +++ b/drivers/media/video/em28xx/em28xx-core.c
> @@ -267,7 +267,7 @@ static int em28xx_write_ac97(struct em28xx *dev, u8 reg, u8 *val)
>  	for (i = 0; i < 10; i++) {
>  		if ((ret = em28xx_read_reg(dev, AC97BUSY_REG)) < 0)
>  			return ret;
> -		if (!((u8) ret) & 0x01)
> +		if (!(((u8) ret) & 0x01))

I think it'd be clearer without the cast to (u8)
which is then implicit cast back to int anyway

	if (!(ret & 1))


