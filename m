Return-Path: <linux-kernel-owner+w=401wt.eu-S1751368AbXJVUbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751368AbXJVUbr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 16:31:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750761AbXJVUbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 16:31:40 -0400
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:34282 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750700AbXJVUbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 16:31:39 -0400
Date: Mon, 22 Oct 2007 13:31:38 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell4.speakeasy.net
To: Michael Krufky <mkrufky@linuxtv.org>
cc: Adrian Bunk <bunk@kernel.org>, v4l-dvb-maintainer@linuxtv.org,
       linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [v4l-dvb-maintainer] [2.6 patch] fix CONFIG_TUNER_TEA5761=m
In-Reply-To: <471C8C5E.1070901@linuxtv.org>
Message-ID: <Pine.LNX.4.58.0710221325350.16052@shell4.speakeasy.net>
References: <20071022024755.GJ30533@stusta.de> <471C19F1.8090505@linuxtv.org>
 <Pine.LNX.4.58.0710212201060.16052@shell4.speakeasy.net> <471C8C5E.1070901@linuxtv.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2007, Michael Krufky wrote:
> Trent Piepho wrote:
> >>> +++ b/drivers/media/video/tuner-core.c
> >>> @@ -30,9 +30,7 @@
> >>>
> >>>  /* standard i2c insmod options */
> >>>  static unsigned short normal_i2c[] = {
> >>> -#ifdef CONFIG_TUNER_TEA5761
> >>>  	0x10,
> >>> -#endif
> >>>
> >>>
> >> ^^^ I believe that we want to keep these #ifdef's above...  The removals
> >> below are fine.
> >>
> >
> > Won't leaving in the call to tea5761_autodetection() when tea5761 is not
> > compiled in result in an undefined symbol error?
> >
> It shouldn't -- See tea5761.h ... If the module is not selected, then a
> stub will report that the driver was disabled by Kconfig.

You're right, there's no need to have the tuner-core code remove the tea5761
function calls as the stubs will take care of it.

We could delete the #if/#endif around the 0x10 address to scan, or keep it.
What's better, to not scan the address if it's not needed, or to scan it and
then produce an error message if something is found there?

But if it stays, it should look like this:

> > #if defined(CONFIG_TUNER_TEA5761) || (defined(CONFIG_TUNER_TEA5761_MODULE) && defined(MODULE))

i.e., only scan 0x10 if there is callable tea5761 code to handle it.
