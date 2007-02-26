Return-Path: <linux-kernel-owner+w=401wt.eu-S1030522AbXBZV0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030522AbXBZV0E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 16:26:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030525AbXBZV0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 16:26:04 -0500
Received: from twin.jikos.cz ([213.151.79.26]:34695 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030522AbXBZV0C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 16:26:02 -0500
Date: Mon, 26 Feb 2007 22:25:55 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
cc: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI: ibm-acpi: improve backlight power handling (v2)
In-Reply-To: <20070226182604.GJ2909@khazad-dum.debian.net>
Message-ID: <Pine.LNX.4.64.0702262217490.10496@twin.jikos.cz>
References: <Pine.LNX.4.64.0702260154460.10496@twin.jikos.cz>
 <1172490091.5824.30.camel@localhost.localdomain> <Pine.LNX.4.64.0702261329270.10496@twin.jikos.cz>
 <20070226142157.GA2909@khazad-dum.debian.net> <1172501357.5824.91.camel@localhost.localdomain>
 <20070226152035.GB2909@khazad-dum.debian.net> <20070226161203.GD2909@khazad-dum.debian.net>
 <1172507907.5824.105.camel@localhost.localdomain> <20070226181202.GH2909@khazad-dum.debian.net>
 <20070226182604.GJ2909@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Feb 2007, Henrique de Moraes Holschuh wrote:

>  static int brightness_update_status(struct backlight_device *bd)
>  {
> -	return brightness_set(bd->props.brightness);
> +	return brightness_set(
> +		(bd->props.fb_blank == FB_BLANK_UNBLANK &&
> +		 bd->props.power == FB_BLANK_UNBLANK) ?
> +				bd->props.brightness : 0);
>  }

Are you sure about the '&&'? The original patch I submitted to you earlier 
today was checking for (bd->props.fb_blank == FB_BLANK_UNBLANK || 
bd->props.power == FB_BLANK_UNBLANK), and I tested it (to some extent) and 
it worked well - no sudden unblanking without reason, no blinking, etc.

I also think that common sense implies that the condition should be 
logical or - backlight layer could request blanking without requesting 
powering the device off, right? We want to handle unblanking from such 
situation properly, which doesn't necessairly mean we will get 
bd->props.power == FB_BLANK_UNBLANK, right?

-- 
Jiri Kosina
