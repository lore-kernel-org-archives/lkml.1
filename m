Return-Path: <linux-kernel-owner+w=401wt.eu-S1754687AbXLLOql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687AbXLLOql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 09:46:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbXLLOqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 09:46:33 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46943 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbXLLOqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 09:46:32 -0500
Subject: Re: [v4l-dvb-maintainer] build #340 failed for 2.6.24-rc5-g75b8c13
	in	linux/drivers/media/video/tuner.ko
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
       linux-kernel@vger.kernel.org, v4l-dvb-maintainer@linuxtv.org,
       video4linux-list@redhat.com
In-Reply-To: <475FE553.4020702@linuxtv.org>
References: <200712120934.46156.toralf.foerster@gmx.de>
	 <475FE553.4020702@linuxtv.org>
Content-Type: text/plain; charset=utf-8
Date: Wed, 12 Dec 2007 12:46:21 -0200
Message-Id: <1197470781.4744.41.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Qua, 2007-12-12 às 08:42 -0500, Michael Krufky escreveu:
> > ERROR: "tea5761_attach" [drivers/media/video/tuner.ko] undefined!
> > ERROR: "tea5761_autodetection" [drivers/media/video/tuner.ko] undefined!
> > ERROR: "tea5767_autodetection" [drivers/media/video/tuner.ko] undefined!
> > ERROR: "tea5767_attach" [drivers/media/video/tuner.ko] undefined!

> It looks like the problem has something to do with VIDEO_TUNER=m while
> both TUNER_TEA5761 & TUNER_TEA5767 are set to 'y'.
> 
> I thought that we had already seen this issue and fixed it, but I guess
> not :-/
> 
> One would think that this could be fixed by making TUNER_TEA5761 &
> TUNER_TEA5767 both depend on VIDEO_TUNER , but that would be wrong,
> since each of those modules can be attached directly to a bridge driver
> without tuner.ko being present at all (although this is not done in
> practice right now, but it *is* the case with some other tuner drivers)

I don't see any issue on making both dependent on VIDEO_TUNER for
2.6.24, since they are currently used only by tuner core module
(tuner.ko).

Yet, the same kind of trouble can happen with other drivers that can be
shared by both V4L and DVB cores, like tda9887 and tda8290.

The proper solution for 2.6.25 seems to create a drivers/media/tuners
directory and write some different rules at Kconfig.

-- 
Cheers,
Mauro

