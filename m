Return-Path: <linux-kernel-owner+w=401wt.eu-S1753668AbXE2V4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668AbXE2V4U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 17:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751023AbXE2V4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 17:56:11 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:36993 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717AbXE2V4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 17:56:10 -0400
Date: Tue, 29 May 2007 23:53:33 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Takashi Iwai <tiwai@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@suse.cz>
Subject: Re: BUG in 2.6.22-rc2-mm1: Parts of Alsa sound architecture broken
In-Reply-To: <1180471146.9509.115.camel@localhost>
Message-ID: <Pine.LNX.4.61.0705292349280.11140@yvahk01.tjqt.qr>
References: <20070524200052.234330@gmx.net>  <20070524130921.8dbd3777.akpm@linux-foundation.org>
  <s5hiragopsx.wl%tiwai@suse.de>  <20070525102806.77ee9c0c.akpm@linux-foundation.org>
  <s5h1wh4si5l.wl%tiwai@suse.de>  <Pine.LNX.4.61.0705261248150.7344@yvahk01.tjqt.qr>
  <s5hveebziom.wl%tiwai@suse.de>  <Pine.LNX.4.61.0705292212120.11140@yvahk01.tjqt.qr>
 <1180471146.9509.115.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 29 2007 17:39, Mauro Carvalho Chehab wrote:
>> >Anyway, I'd like to confirm that this really works before merging to
>> >the ALSA tree.  As Mauro suspected, kconfig seems not working as
>> >expected...
>> 
>> Unfortunately, there are sometimes non-visible options in menus (the
>> Networking>QoS menu for example) that, when converted to menuconfig-if-endif,
>> also get lost when the menuconfig object is deactivated. In case of QoS, this
>> can break compilation. For most subsystems however, it works alright because
>> the particular subsystem referencing CONFIG_INVISIBLE_THING is deactivated
>> anyway and does not get compiled.
>> Such strange menus (like QoS) have not been menuconfigized so far, it's just
>> too hard to keep the bits together. As far as other subsystems are concerned,
>> please give it some testing.
>
>Hmm... probably, this is what happened with V4L: there are several
>invisible items there for selecting some core items.

Well, what I wanted to describe is that CONFIG_RANDOM_INVISIBLE_THING
can be referenced _outside_ the particular subsys, and then it
breaks right on the spot -- some easier to find thanks to compile
failure, or a link failure, others may remain hidden until runtime.
A misplacement of invisible objects, I'd say, but that is another
story, another day, another patch perhaps.

>In the case of V4L, the problem is that, when the menu item is
>activated, sometimes, kconfig doesn't properly honor module/static link
>heritage.

RFC 1925, item 7 seems to fit ;-)


	Jan
-- 
