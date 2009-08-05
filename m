Return-Path: <linux-kernel-owner+w=401wt.eu-S1755710AbZHELPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710AbZHELPR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 07:15:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbZHELPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 07:15:16 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56195 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751223AbZHELPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 07:15:15 -0400
Date: Wed, 5 Aug 2009 12:15:51 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Takashi Iwai <tiwai@suse.de>
Cc: Colin Guthrie <cguthrie@mandriva.org>, Tejun Heo <teheo@suse.de>,
       Greg KH <greg@kroah.com>, Al Viro <viro@ftp.linux.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] sound: make OSS device number claiming optional
Message-ID: <20090805121551.7449f748@lxorguk.ukuu.org.uk>
In-Reply-To: <s5hzlaemtdx.wl%tiwai@suse.de>
References: <4A79283E.7030202@kernel.org>
	<4A79296A.4090600@suse.de>
	<20090805101551.6ee053e5@lxorguk.ukuu.org.uk>
	<4A794FB9.30403@mandriva.org>
	<20090805105916.28f84a05@lxorguk.ukuu.org.uk>
	<s5h63d2o9ds.wl%tiwai@suse.de>
	<20090805112649.4a59ce70@lxorguk.ukuu.org.uk>
	<s5hzlaemtdx.wl%tiwai@suse.de>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Not really :)  The soundcore is only for OSS device files.  As long as
> you use only ALSA-native APIs, you don't need it.  But, currently it's
> loaded and initialized just because of the module dependency.  This is
> no bug but also not an intended feature.

Sure for the ALSA device node it makes sense because ALSA is the mux for
it. Fortunately soundcore is tiny anyway.

> > This makes it worse.
> 
> Well, the only regression would be the case where you create static
> /dev/dsp (or else) devices and let auto-loading through sound-slot-*
> or sound-service-*-* aliases.  Of course, this still works if you
> load soundcore in some way.

Unless some ugly cuse hack got there first.

> What I suggested in the above is to cut off an unneeded dependency
> between soundcore and ALSA-native stuff instead of hacking soundcore.
> It won't change anything else, so everything else can coexist as
> before.

Agreed - but that is really a separate issue to having something break
the soundcore by being rude.

Alan
