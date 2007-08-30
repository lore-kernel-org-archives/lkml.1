Return-Path: <linux-kernel-owner+w=401wt.eu-S1763451AbXH3Wox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763451AbXH3Wox (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 18:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763468AbXH3WoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 18:44:14 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52216 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763408AbXH3WoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 18:44:12 -0400
Date: Fri, 31 Aug 2007 04:27:13 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Jesper Juhl <jesper.juhl@gmail.com>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Vojtech Pavlik <vojtech@ucw.cz>,
       Johann Deneux <johann.deneux@gmail.com>, dtor@mail.ru,
       linux-input@atrey.karlin.mff.cuni.cz,
       linux-joystick@atrey.karlin.mff.cuni.cz
Subject: Re: [PATCH] input: Silence 'unused variable' warning in iforce
 joystick driver
In-Reply-To: <200708310013.12347.jesper.juhl@gmail.com>
Message-ID: <alpine.LFD.0.999.0708310422200.31519@enigma.security.iitk.ac.in>
References: <200708310013.12347.jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Fri, 31 Aug 2007, Jesper Juhl wrote:

> In the iforce driver we currently get this warning
> 
>  drivers/input/joystick/iforce/iforce-packets.c: In function 'iforce_get_id_packet':
>  drivers/input/joystick/iforce/iforce-packets.c:249: warning: unused variable 'status'
> 
> if CONFIG_JOYSTICK_IFORCE_USB is not defined.
> 
> The warning is easy to avoid by simply moving the variable inside 
> the only case in the switch that actually use it.
> 
> 
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
> ---
> 
> diff --git a/drivers/input/joystick/iforce/iforce-packets.c b/drivers/input/joystick/iforce/iforce-packets.c
> index 3154ccd..48d4a86 100644
> --- a/drivers/input/joystick/iforce/iforce-packets.c
> +++ b/drivers/input/joystick/iforce/iforce-packets.c
> @@ -246,13 +246,12 @@ void iforce_process_packet(struct iforce *iforce, u16 cmd, unsigned char *data)
>  
>  int iforce_get_id_packet(struct iforce *iforce, char *packet)
>  {
> -	int status;
> -
>  	switch (iforce->bus) {
>  
>  	case IFORCE_USB:
> -
>  #ifdef CONFIG_JOYSTICK_IFORCE_USB
> +		int status;
> +
>  		iforce->cr.bRequest = packet[0];
>  		iforce->ctrl->dev = iforce->usbdev;

Hmm, would this not still give a warning when JOYSTICK_IFORCE_USB=y?
[ I didn't know mixing code and declarations (not at top of statement
  block) was accepted style in the kernel ... ]

IMHO either you should at least wrap that case inside a {} of its
own (so that the int status; is at top of a statement block), or else,
preferably, just add "__maybe_unused" to the first declaration that you
removed just now.


Satyam
