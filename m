Return-Path: <linux-kernel-owner+w=401wt.eu-S1752716AbZLOGDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716AbZLOGDg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 01:03:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752530AbZLOGDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 01:03:35 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55066 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751573AbZLOGDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 01:03:34 -0500
Date: Mon, 14 Dec 2009 22:02:33 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Russ Dill <russ.dill@gmail.com>
cc: Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
Subject: Re: [GIT PATCH] USB patches for 2.6.33-git
In-Reply-To: <1260852335.1886.0.camel@russ-laptop>
Message-ID: <alpine.LFD.2.00.0912142158260.14385@localhost.localdomain>
References: <g383sjib9r8nlmw354UYAxe124vaj_firegpg@mail.gmail.com>  <1260849652.28808.1.camel@russ-laptop>  <alpine.LFD.2.00.0912142031170.14385@localhost.localdomain> <1260852335.1886.0.camel@russ-laptop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 Dec 2009, Russ Dill wrote:
>
> From: Russ Dill <Russ.Dill@gmail.com>
> Date: Wed, 18 Nov 2009 10:31:27 -0700
> Subject: [PATCH] Close usb_find_interface race v3
 [...]

Ok, patch looks good to me.

However, now I just wonder whether this re-introduces the original race.

In the original race description:

> USB drivers that create character devices call usb_register_dev in their
> probe function. This associates the usb_interface device with that minor
> number and creates the character device and announces it to the world.
> However, the driver's probe function is called before the new
> usb_interface is added to the driver's klist_devices.

and now we obviously no longer care about that klist_devices thing any 
more, but we _do_ care about 'dev->driver'.

Has that been set by the time the driver's probe function is called? Or 
are we now going to have the same situation as before the original patch?

[ That obviously always worked for my printer situation, but I'm just 
  wondering if this patch actually now helps whatever problem the original 
  patch was supposed to help? ]

Somebody who knows the USB driver binding code better than I do should 
look at this. Greg?

		Linus
