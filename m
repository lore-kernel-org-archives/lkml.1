Return-Path: <linux-kernel-owner+w=401wt.eu-S1756241AbYGHPP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241AbYGHPP2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 11:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753752AbYGHPPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 11:15:19 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:34040 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753827AbYGHPPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 11:15:18 -0400
Date: Tue, 8 Jul 2008 19:15:15 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix broken fix for fsl-diu-db
Message-ID: <20080708151515.GA22707@polina.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <s5h8wwc72he.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <s5h8wwc72he.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2008 at 06:41:17PM +0200, Takashi Iwai wrote:
> On 2.6.26-rc9, the commit 05946bce839b4fed5442dbfab77060fb75e051f3
>     fsl_diu_fb: fix build with CONFIG_PM=y, plus fix some warnings
> breaks its previous fix f969c5672b16b857e5231ad3c78f08d8ef3305aa
>     fsl-diu-db: compile fix

Yeah, I sent the fix on Jun 06, it hanged around in the mailing list
for month, meanwhile Linus directly applied Jeff Mahoney's fix on Jun
12 (git says).

Quite funny they didn't conflict.

> This patch reverts the broken part.
> 
> Signed-off-by: Takashi Iwai <tiwai@suse.de>

So... ack, and it wasn't my fault, FWIW. :-P

> ---
> diff --git a/drivers/video/fsl-diu-fb.c b/drivers/video/fsl-diu-fb.c
> index 712dabc..09d7e22 100644
> --- a/drivers/video/fsl-diu-fb.c
> +++ b/drivers/video/fsl-diu-fb.c
> @@ -1324,7 +1324,7 @@ static int fsl_diu_suspend(struct of_device *ofdev, pm_message_t state)
>  {
>  	struct fsl_diu_data *machine_data;
>  
> -	machine_data = dev_get_drvdata(&dev->dev);
> +	machine_data = dev_get_drvdata(&ofdev->dev);
>  	disable_lcdc(machine_data->fsl_diu_info[0]);
>  
>  	return 0;
> @@ -1334,7 +1334,7 @@ static int fsl_diu_resume(struct of_device *ofdev)
>  {
>  	struct fsl_diu_data *machine_data;
>  
> -	machine_data = dev_get_drvdata(&dev->dev);
> +	machine_data = dev_get_drvdata(&ofdev->dev);
>  	enable_lcdc(machine_data->fsl_diu_info[0]);
>  
>  	return 0;

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
