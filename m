Return-Path: <linux-kernel-owner+w=401wt.eu-S1760437AbYGRXB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760437AbYGRXB5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 19:01:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754184AbYGRXBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 19:01:49 -0400
Received: from mail-in-13.arcor-online.net ([151.189.21.53]:40841 "EHLO
	mail-in-13.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753648AbYGRXBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 19:01:48 -0400
Subject: Re: [linux-dvb] [PATCH] V4L: Link tuner before saa7134
From: hermann pitton <hermann-pitton@arcor.de>
To: Simon Arlott <simon@fire.lp0.eu>, video4linux-list@redhat.com,
       v4l-dvb list <v4l-dvb-maintainer@linuxtv.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Brian Marete <bgmarete@gmail.com>, linux-dvb@linuxtv.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <38354.simon.1216381906@5ec7c279.invalid>
References: <6dd519ae0807180428k30abd15eo60fd2856f7a43821@mail.gmail.com>
	 <38354.simon.1216381906@5ec7c279.invalid>
Content-Type: text/plain
Date: Sat, 19 Jul 2008 00:56:39 +0200
Message-Id: <1216421799.2666.23.camel@pc10.localdom.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Am Freitag, den 18.07.2008, 12:51 +0100 schrieb Simon Arlott:
> On Fri, July 18, 2008 12:28, Brian Marete wrote:
> > On Jul 14, 6:00 am, hermann pitton <hermann-pit...@arcor.de> wrote:
> >>
> >> #1 users can't set thetunertype anymore,
> >>    but the few cases oftunerdetection from eeprom we have should
> >>    work again for that price.
> >
> > Hello,
> >
> > Any patch yet for above issue? It seems to have made it into 2.6.26.
> >
> > I use saa7134 with everything, including the tuner modules, compiled
> > as a module. My card is detected as a flyvideo2000. The default tuner
> > for that card (#37) allows me to tune into TV but not to FM Radio. I
> > can access both functions (TV and FM Radio) if I override with
> > tuner=69, which is what I usually do. That override does not work on
> > 2.6.26.
> >
> > Any suggestions?
> 
> Modify saa7134_board_init2 so that the manual tuner type setting isn't
> ignored. The first thing it does is to overwrite the current value
> (set earlier from module parameter) with the static values... even
> before trying to autodetect it.
> 
> In saa7134-core.c saa7134_initdev:
>  dev->tuner_type   = saa7134_boards[dev->board].tuner_type;
> +dev->tuner_addr   = saa7134_boards[dev->board].tuner_addr;
> 
> In saa7134-cards.c saa7134_board_init2:
> -dev->tuner_type   = saa7134_boards[dev->board].tuner_type;
> -dev->tuner_addr   = saa7134_boards[dev->board].tuner_addr;
> 
> I think that will fix it.
> 

this restores tuner behavior on the saa7134 driver.

I can't test XCeive tuners, which load different firmware dynamically.
Mauro was on them.

Please send the patch to Mauro and/or provide your signed-off-by.

This must go to the stable team ASAP as well.

Reviewed-by: Hermann Pitton <hermann-pitton@arcor.de>

Many thanks!

Cheers,
Hermann

