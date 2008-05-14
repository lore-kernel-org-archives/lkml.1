Return-Path: <linux-kernel-owner+w=401wt.eu-S1763606AbYENTHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763606AbYENTHj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 15:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757623AbYENTHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 15:07:31 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:48265 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757708AbYENTHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 15:07:30 -0400
Message-ID: <482B38D6.5030804@keyaccess.nl>
Date: Wed, 14 May 2008 21:09:10 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Takashi Iwai <tiwai@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       ALSA devel <alsa-devel@alsa-project.org>
Subject: Re: 2.6.26-rc1 regression: ISA DMA broken (bisected)
References: <4823AAF2.7070102@keyaccess.nl> <482B0807.9050404@keyaccess.nl> <482B3274.2060006@keyaccess.nl> <200805141250.57115.bjorn.helgaas@hp.com>
In-Reply-To: <200805141250.57115.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-05-08 20:50, Bjorn Helgaas wrote:

> On Wednesday 14 May 2008 12:41:56 pm Rene Herman wrote:

>> You're in a maze of struct device *s, all alike... I was passing the 
>> pnp_card->dev instead of the initialized pnp_dev->dev.
>>
>> And, not doing so brings out a difference between ISAPnP and legacy ISA 
>> again insofar that legacy ISA does not consist of cards with multiple 
>> devices. We just have the single struct device * for the ISA device.
>>
>> This therefore would be the easiest solution (and works fine) but seems 
>> a bit of a hack. Bjorn, do you have an opinion? If I abstract things out 
>> a bit more I might be able to do this nicer. One might on the other hand 
>> argue that the dma_mask is going to be constant for all card devices so 
>> might as well just use the card dev.
> 
> I agree, it seems a bit of a hack to use a DMA mask from the card
> instead of from the device, since the driver should be programming
> the device to do the DMA.
> 
> But I know very little about pnp_card in general, so don't attach too
> much weight to my opinion.

Okay, I'll sit on this for a bit. Right now we're using a global device even 
but this is exactly about cleaning that up so couldn't convince myself. Will 
see what happens when I try to make it nice...

Rene.
