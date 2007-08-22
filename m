Return-Path: <linux-kernel-owner+w=401wt.eu-S933287AbXHVW4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933287AbXHVW4R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 18:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761777AbXHVW4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 18:56:06 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38045 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760126AbXHVW4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 18:56:04 -0400
Subject: Re: TV card detected wrongly by the kernel. Any chance to get this
	fixed?
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Manuel Reimer <Manuel.Spam@nurfuerspam.de>
Cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       v4l-dvb-maintainer@linuxtv.org
In-Reply-To: <20070822215148.GL30705@stusta.de>
References: <fai89b$ms1$1@sea.gmane.org>  <20070822215148.GL30705@stusta.de>
Content-Type: text/plain
Date: Wed, 22 Aug 2007 19:55:57 -0300
Message-Id: <1187823357.7104.25.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.90-1mdv2008.0 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Manuel,

> > I have a BT878 based TV card (was sold by a german discounter some years 
> > ago).
> >
> > Unfortunately this card gets detected wrongly and so I'm unable to watch 
> > tv, if I allow the kernel to auto-detect the card.
> >
> > If I unload the module and reload it using the right "card=" value,
> then 
> > anything works well. So one of the first steps, I do if I install a
> new 
> > version of my distribution, is to place the "unload module and
> reload with 
> > the right value" code to my "rc.local" file.
> >
> > Is there any chance to get this card added to the kernel, so the
> right 
> > value gets auto-loaded?
> 
> It might be possible, but the driver maintainer (Cc'ed) should know
> best.

Most cheap bt8xx boards don't have eeprom or other means for properly
detecting the board internals. For such boards, you need to specify
card=<nr>, otherwise the driver will use a generic "default" that may
not work.

The proper way for handling this is by adding at /etc/modprobe.conf
(or /etc/modules, depending on your distro) a line like:

options bttv card=<nr>

This way, every time the module will load, the modprobe tools will use
the proper options.

If your board have an unique PCI ID, we may add it to the driver,
avoiding this need. For this, we will need the results of the following
command:

lspci -vv -nn

Cheers,
Mauro

