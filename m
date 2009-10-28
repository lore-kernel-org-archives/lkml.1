Return-Path: <linux-kernel-owner+w=401wt.eu-S1753175AbZJ1WFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175AbZJ1WFV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 18:05:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752995AbZJ1WFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 18:05:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46221 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752977AbZJ1WFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 18:05:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: 32-rc2: runtime_pm is noisy
Date: Wed, 28 Oct 2009 23:07:14 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc5-rjw; KDE/4.3.1; x86_64; ; )
Cc: kernel list <linux-kernel@vger.kernel.org>, linux-pm@vger.kernel.org
References: <20091006080241.GB1362@ucw.cz> <200910062342.20910.rjw@sisk.pl> <20091013110407.GC31984@elf.ucw.cz>
In-Reply-To: <20091013110407.GC31984@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910282307.14838.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 October 2009, Pavel Machek wrote:
> On Tue 2009-10-06 23:42:20, Rafael J. Wysocki wrote:
> > On Tuesday 06 October 2009, Pavel Machek wrote:
> > > Hi!
> > > 
> > > Maybe it is my config,
> > 
> > Yes it is.
> > 
> > > but pm_runtime_idle is a bit too noisy on
> > > zaurus... ok, I do have pm_debug & pm_verbose
> > 
> > Exactly.
> > 
> > > set... but still, is it useful to print message about devices that do not
> > > support it?
> > 
> > It may be useful, because, for example, PCI can put devices without drivers
> > into low power states using this mechanism.
> > 
> > Still, perhaps we can drop the debug messages from __pm_runtime_idle().
> > 
> > Care to send a patch?
> 
> Yep, something like this?

Applied to suspend-2.6/linux-next.

Thanks,
Rafael


> ---
> 
> pm_runtime_idle is somewhat noisy. Remove debug prints.
> 
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 
> --- a/drivers/base/power/runtime.c
> +++ b/drivers/base/power/runtime.c
> @@ -51,8 +51,6 @@ static int __pm_runtime_idle(struct device *dev)
>  {
>  	int retval = 0;
>  
> -	dev_dbg(dev, "__pm_runtime_idle()!\n");
> -
>  	if (dev->power.runtime_error)
>  		retval = -EINVAL;
>  	else if (dev->power.idle_notification)
> @@ -93,8 +91,6 @@ static int __pm_runtime_idle(struct device *dev)
>  	wake_up_all(&dev->power.wait_queue);
>  
>   out:
> -	dev_dbg(dev, "__pm_runtime_idle() returns %d!\n", retval);
> -
>  	return retval;
>  }
>  
> 
> 

