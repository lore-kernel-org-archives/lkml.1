Return-Path: <linux-kernel-owner+w=401wt.eu-S1758295AbZELMa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758295AbZELMa1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 08:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754263AbZELMaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 08:30:14 -0400
Received: from mail.atmel.fr ([81.80.104.162]:43520 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752229AbZELMaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 08:30:13 -0400
Message-ID: <4A096BCB.3030403@atmel.com>
Date: Tue, 12 May 2009 14:30:03 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Daniel_Gl=F6ckner?= <dg@emlix.com>
CC: linux-fbdev-devel@lists.sourceforge.net, Ben Nizette <bn@niasdigital.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: atmel_lcdfb: max pixclock check
References: <49F1C0E4.9050906@emlix.com>
In-Reply-To: <49F1C0E4.9050906@emlix.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Glöckner :
> Hi,
> in the current Atmel LCD framebuffer driver there is the following check in the
> fb_check_var callback:
> 
> if ((PICOS2KHZ(var->pixclock) * var->bits_per_pixel / 8) > clk_value_khz) {
> 	dev_err(dev, "%lu KHz pixel clock is too fast\n",
> 		PICOS2KHZ(var->pixclock));
> 	return -EINVAL;
> }
> 
> I can't find any constraint like this in the data sheets and application note.
> What I can find is a minimum for clk_value_khz/PICOS2KHZ(var->pixclock)
> depending on the display type, scan mode, and interface width.

Indeed, I have just acked a patch from Ben Nizette removing this constrain.
http://lkml.org/lkml/2009/5/12/189

> Is the quoted if-statement correct or should it be changed to a minimum clock
> divider check?

We can imagine such a check depending on display type. Patches welcome ;-)

> And while we're at it, is it correct to return -EINVAL here instead of changing
> var->pixclock to the closest supported value?

I do not know... Maybe someone on linux-fb-devel can answer ?

Bye,
-- 
Nicolas Ferre
