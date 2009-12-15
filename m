Return-Path: <linux-kernel-owner+w=401wt.eu-S1755099AbZLOEgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099AbZLOEgv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 23:36:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753446AbZLOEgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 23:36:48 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59246 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751449AbZLOEgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 23:36:46 -0500
Date: Mon, 14 Dec 2009 20:36:36 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Russ Dill <russ.dill@gmail.com>
cc: Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
Subject: Re: [GIT PATCH] USB patches for 2.6.33-git
In-Reply-To: <1260849652.28808.1.camel@russ-laptop>
Message-ID: <alpine.LFD.2.00.0912142031170.14385@localhost.localdomain>
References: <g383sjib9r8nlmw354UYAxe124vaj_firegpg@mail.gmail.com> <1260849652.28808.1.camel@russ-laptop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 Dec 2009, Russ Dill wrote:
> @@ -144,10 +144,9 @@ static int __find_interface(struct device *dev, void *data)
>  		return 0;
>  
>  	intf = to_usb_interface(dev);
> -	if (intf->minor != -1 && intf->minor == arg->minor) {
> -		arg->interface = intf;
> +	if (intf->minor != -1 && intf->minor == arg->minor &&
> +		dev->driver == arg->drv)
>  		return 1;
> -	}
>  	return 0;
>  }

Btw, can we please write this somewhat more readably, and just do

	if (dev->driver != arg->drv)
		return 0;
	intf = to_usb_interface(dev);
	return intf->minor == arg->minor;

because the whole "intf->minor != -1" thing is pointless (we're going to 
test it against 'arg->minor', and if that is -1, then the caller damn well 
gets what he deserves anyway).

This way there are no complex multi-line crud expressions, and it all 
looks simpler. No?

			Linus
