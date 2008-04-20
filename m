Return-Path: <linux-kernel-owner+w=401wt.eu-S1757414AbYDTQRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414AbYDTQRe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 12:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbYDTQR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 12:17:26 -0400
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4901 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307AbYDTQR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 12:17:26 -0400
X-Greylist: delayed 576 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Apr 2008 12:17:25 EDT
From: Hans Verkuil <hverkuil@xs4all.nl>
To: video4linux-list@redhat.com
Subject: Re: [PATCH] Fix VIDIOCGAP corruption in ivtv
Date: Sun, 20 Apr 2008 18:06:33 +0200
User-Agent: KMail/1.9.7
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Mike Krufky <mkrufky@linuxtv.org>, ivtv-devel@ivtvdriver.org,
       "Frank Bennett" <biercenator@gmail.com>
References: <20080420122736.20d60eff@the-village.bc.nu>
In-Reply-To: <20080420122736.20d60eff@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804201806.33464.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 20 April 2008 13:27:36 Alan Cox wrote:
> Frank Bennett reported that ivtv was causing skype to crash. With
> help from one of their developers he showed it was a kernel problem.
> VIDIOCGCAP copies a name into a fixed length buffer - ivtv uses names
> that are too long and does not truncate them so corrupts a few bytes
> of the app data area.
>
> Possibly the names also want trimming but for now this should fix the
> corruption case.

Ouch, nasty one.

Mauro, can you apply this patch to the v4l-dvb master?

Mike, this one should obviously go into a 2.6.25 dot-release, and I 
think also to a 2.6.24 dot-release.

Frank, thank you for reporting this!

	Hans

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>

>
> Signed-off-by: Alan Cox <alan@redhat.com>
>
> ---
> linux.vanilla-2.6.25-rc8-mm2/drivers/media/video/ivtv/ivtv-ioctl.c	20
>08-04-13 15:36:53.000000000 +0100 +++
> linux-2.6.25-rc8-mm2/drivers/media/video/ivtv/ivtv-ioctl.c	2008-04-20
> 12:15:33.000000000 +0100 @@ -742,7 +742,8 @@
>
>  		memset(vcap, 0, sizeof(*vcap));
>  		strcpy(vcap->driver, IVTV_DRIVER_NAME);     /* driver name */
> -		strcpy(vcap->card, itv->card_name); 	    /* card type */
> +		strncpy(vcap->card, itv->card_name,
> +				sizeof(vcap->card)-1); 	    /* card type */
>  		strcpy(vcap->bus_info, pci_name(itv->dev)); /* bus info... */
>  		vcap->version = IVTV_DRIVER_VERSION; 	    /* version */
>  		vcap->capabilities = itv->v4l2_cap; 	    /* capabilities */
>
> --
> 		"Hello, welcome to Jon Masters' house of pain"
> 				- Jon after a particularly good night
>
> --
> video4linux-list mailing list
> Unsubscribe
> mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list


