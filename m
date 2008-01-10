Return-Path: <linux-kernel-owner+w=401wt.eu-S1756916AbYAJB4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916AbYAJB4O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 20:56:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753504AbYAJB4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 20:56:05 -0500
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:45182 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458AbYAJB4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 20:56:04 -0500
Message-ID: <47857A82.4050005@keyaccess.nl>
Date: Thu, 10 Jan 2008 02:53:06 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, alsa-devel@alsa-project.org,
       Jaroslav Kysela <perex@suse.cz>, Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [alsa-devel] PNP_DRIVER_RES_DISABLE breaks swsusp at least with
 snd_cs4236
References: <200801092343.48726.linux@rainbow-software.org>
In-Reply-To: <200801092343.48726.linux@rainbow-software.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09-01-08 23:43, Ondrej Zary wrote:

Jaroslav -- in your role as ISA-PnP maintainer and Bjorn, in yours as having 
been foollish enough to touch PnP recently:

> as hibernation (swsusp) started to work with my CPU, I found that my Turtle 
> Beach Malibu stops working after resume from hibernation. It's caused by fact 
> that the card is not enabled on the pnp layer during resume - and thus card 
> registers are inaccessible (reads return FFs, writes go nowhere).
> 
> During resume, pnp_bus_resume() in drivers/pnp/driver.c is called for each pnp 
> device. This function calls pnp_start_dev() only when the 
> PNP_DRIVER_RES_DO_NOT_CHANGE bit is NOT seting pnp_drv->flags. But the cs4236 
> driver in sound/isa/cs423x/cs4236.c explicitly sets the .flags to 
> PNP_DRIVER_RES_DISABLE - it's value is 3 and that includes 
> PNP_DRIVER_RES_DO_NOT_CHANGE bit.

Ehm. Isn't that a bit unexpected:

#define PNP_DRIVER_RES_DO_NOT_CHANGE    0x0001  /* do not change the state 
of the device */
#define PNP_DRIVER_RES_DISABLE          0x0003  /* ensure the device is 
disabled */

I'd say that disabling is changing, so isn't this just a braino where 
someone meant to write 2 instead of 3?

> The same .flags value is present in many of the ALSA ISA sound drivers.
> 
> Removing that .flags line caused this to appear inlog when loading snd_cs4236 
> module:
> CS4236+ WSS PnP manual resources are invalid, using auto config
> CS4236+ CTRL PnP manual resources are invalid, using auto config
> CS4236+ MPU401 PnP manual resources are invalid, using auto config
> 
> and the sound now works after resume!
> 
> So the question is: why is this line present?
> 
> Is this a bug? What's the correct fix?

Rene.

