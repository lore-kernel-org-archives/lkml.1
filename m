Return-Path: <linux-kernel-owner+w=401wt.eu-S1751048AbXB1B7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751048AbXB1B7S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 20:59:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751057AbXB1B7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 20:59:18 -0500
Received: from relais.videotron.ca ([24.201.245.36]:16134 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbXB1B7R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 20:59:17 -0500
Date: Tue, 27 Feb 2007 20:59:17 -0500
From: Veronique & Vincent <vinctre@videotron.ca>
Subject: Re: Sound 2.6.19:  Soundcard driver often fail to load?
In-reply-to: <s5hk5y95da1.wl%tiwai@suse.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
Message-id: <200702272059.17644.vinctre@videotron.ca>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 8BIT
Content-disposition: inline
References: <200702210550.48322.vinctre@videotron.ca>
 <s5hk5y95da1.wl%tiwai@suse.de>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 23 février 2007, vous avez écrit :
> At Wed, 21 Feb 2007 05:50:48 -0500,
> Veronique & Vincent wrote:
> > 
> > Hi,
> > 
> > I'm currently running a 2.6.19 kernel and 2 times out of 3 the sound driver fails to load hence probing me a no sound device available in KDE.
> > ....
> > Could the snd-usb-audio interfere with the on-board sound driver?
> 
> Yes, if you set index=0 module option to snd-intel8x0 driver and
> nothing to snd-usb-audio, they may conflict according to the order of
> loaded modules.  Pass index=1 (or index=-2) to snd-usb-audio module
> option to make the index order consistent.
> 

Now there is a bug opened up at redhat:
https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=229227

I've ran into this info:
http://www.lavrsen.dk/twiki/bin/view/PWC/FrequentlyAskedQuestionsPWC#modprobe_fails_with_FATAL_Error
and did removed the index=X line associated with the pwc driver.  This still create a problem from time to time.

Seems like the index=X option is broken in the alsa driver (or maybie deprecated, remove, buggy, duno?). There is another way to fix the problem by using a /etc/asound.conf file (see http://alsa.opensrc.org/FAQ026) and removing the index=X entries from your mdoprobe.conf file

Maybie the Fedora team should use the asound.conf configuration instead?

> Takashi

thnx!

- vin



