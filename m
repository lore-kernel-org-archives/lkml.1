Return-Path: <linux-kernel-owner+w=401wt.eu-S1161230AbXBZVmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161230AbXBZVmQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 16:42:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161228AbXBZVmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 16:42:15 -0500
Received: from tim.rpsys.net ([194.106.48.114]:56687 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161230AbXBZVmO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 16:42:14 -0500
Subject: Re: [PATCH] ACPI: ibm-acpi: improve backlight power handling (v2)
From: Richard Purdie <rpurdie@rpsys.net>
To: Jiri Kosina <jikos@jikos.cz>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0702262217490.10496@twin.jikos.cz>
References: <Pine.LNX.4.64.0702260154460.10496@twin.jikos.cz>
	 <1172490091.5824.30.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0702261329270.10496@twin.jikos.cz>
	 <20070226142157.GA2909@khazad-dum.debian.net>
	 <1172501357.5824.91.camel@localhost.localdomain>
	 <20070226152035.GB2909@khazad-dum.debian.net>
	 <20070226161203.GD2909@khazad-dum.debian.net>
	 <1172507907.5824.105.camel@localhost.localdomain>
	 <20070226181202.GH2909@khazad-dum.debian.net>
	 <20070226182604.GJ2909@khazad-dum.debian.net>
	 <Pine.LNX.4.64.0702262217490.10496@twin.jikos.cz>
Content-Type: text/plain
Date: Mon, 26 Feb 2007 21:42:01 +0000
Message-Id: <1172526121.24429.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-26 at 22:25 +0100, Jiri Kosina wrote:
> On Mon, 26 Feb 2007, Henrique de Moraes Holschuh wrote:
> 
> >  static int brightness_update_status(struct backlight_device *bd)
> >  {
> > -	return brightness_set(bd->props.brightness);
> > +	return brightness_set(
> > +		(bd->props.fb_blank == FB_BLANK_UNBLANK &&
> > +		 bd->props.power == FB_BLANK_UNBLANK) ?
> > +				bd->props.brightness : 0);
> >  }
> 
> Are you sure about the '&&'? The original patch I submitted to you earlier 
> today was checking for (bd->props.fb_blank == FB_BLANK_UNBLANK || 
> bd->props.power == FB_BLANK_UNBLANK), and I tested it (to some extent) and 
> it worked well - no sudden unblanking without reason, no blinking, etc.
> 
> I also think that common sense implies that the condition should be 
> logical or - backlight layer could request blanking without requesting 
> powering the device off, right? We want to handle unblanking from such 
> situation properly, which doesn't necessairly mean we will get 
> bd->props.power == FB_BLANK_UNBLANK, right?

In the above context, && is correct, || isn't.

We want to blank (set to 0) if either fb_blank or power isn't set to
FB_BLANK_UNBLANK. This is the same as setting to brightness if both
fb_blank and power are set to FB_BLANK_UNBLANK. This is what the above
expression does.

Richard

