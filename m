Return-Path: <linux-kernel-owner+w=401wt.eu-S1765715AbXJQNPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765715AbXJQNPW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 09:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760017AbXJQNPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 09:15:07 -0400
Received: from main.gmane.org ([80.91.229.2]:40307 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759956AbXJQNPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 09:15:05 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Frank Mandarino <fmandarino@endrelia.com>
Subject: Re: audio codec control
Date: Wed, 17 Oct 2007 08:57:09 -0400
Organization: Endrelia Technologies Inc.
Message-ID: <471606A5.90807@endrelia.com>
References: <21590.1909782135$1192548826@news.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: linux-arm-kernel@lists.arm.linux.org.uk
X-Gmane-NNTP-Posting-Host: bas17-toronto12-1177718679.dsl.bell.ca
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
In-Reply-To: <21590.1909782135$1192548826@news.gmane.org>
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Savary wrote:
> Hello,
> 
> thank you for your help about my previous request concerning a problem in
> audio capture on CS42L51 codec. 
> 
> For your information, my problem came from a bad configuration of an ARM9
> register. As my register settings, the capture had to start with an event on
> RD pin, which is not connected with the codec on my board. Setting the START
> bits to 0 = "continuous" solved my problem.
> 
> Today, I need some more help to understand how your driver is used from an
> external application. Notably, how do you call the controls "Master Playback
> Volume", "Master Playback ZC Switch", "Capture Volume", etc, but also the
> "Input Select" and "Output Mixer", for example ?
> Shouldn't we modify the field at91_pcm_ops->ioctl (in
> /sound/soc/at91/at91-pcm.c), which is now set to the common function
> snd_pcm_lib_ioctl, in order to launch codec-related commands ?
> 
> Thank you in advance for your help.
> 
> 
> Sylvain
> 
> 
> -------------------------------------------------------------------
> List admin: http://lists.arm.linux.org.uk/mailman/listinfo/linux-arm-kernel
> FAQ:        http://www.arm.linux.org.uk/mailinglists/faq.php
> Etiquette:  http://www.arm.linux.org.uk/mailinglists/etiquette.php
> 

Pierre and/or Sylvain,

I'm not sure how you call the controls from an external application.  I
have only used the alsa-utils amixer command to set the controls, and
alsactl to save the settings in /etc/asound.state and then restore them
at boot.

So you could look at the amixer source to see how they are called.

The available controls are normally defined in the ASoC codec driver,
and you shouldn't need to modify the at91_pcm_ops->ioctl pointer to
access them.

../fam
-- 
Frank Mandarino                                fmandarino(a)endrelia.com
Endrelia Technologies Inc.
Toronto, Ontario, Canada

