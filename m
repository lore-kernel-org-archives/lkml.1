Return-Path: <linux-kernel-owner+w=401wt.eu-S1756781AbZLITEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781AbZLITEl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 14:04:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756290AbZLITEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 14:04:40 -0500
Received: from smtp240.poczta.interia.pl ([217.74.64.240]:7219 "EHLO
	smtp240.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755934AbZLITEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 14:04:39 -0500
Date: Wed, 9 Dec 2009 20:06:27 +0100
From: Krzysztof Helt <krzysztof.h1@poczta.fm>
To: Randy Dunlap <randy.dunlap@ORACLE.COM>
Cc: lkml <linux-kernel@vger.kernel.org>,
       torvalds <torvalds@linux-foundation.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Krzysztof Helt <krzysztof.h1@wp.pl>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH] radio/sound/miro: fix build, cleanup depends/selects
Message-Id: <20091209200627.c2a22e41.krzysztof.h1@poczta.fm>
In-Reply-To: <20091208091307.7bff5964.randy.dunlap@oracle.com>
References: <20091208091307.7bff5964.randy.dunlap@oracle.com>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-EMID: aee2b138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Dec 2009 09:13:07 -0800
Randy Dunlap <randy.dunlap@ORACLE.COM> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> miropcm20 uses ALSA (snd_) interfaces from the SND_MIRO
> driver, so it should depend on SND.
> (selecting SND_MIRO when CONFIG_SND is not enabled is a
> problem.)
> 
> drivers/built-in.o: In function `vidioc_s_ctrl':
> radio-miropcm20.c:(.text+0x227499): undefined reference to `snd_aci_cmd'
> drivers/built-in.o: In function `vidioc_s_frequency':
> radio-miropcm20.c:(.text+0x227574): undefined reference to `snd_aci_cmd'
> radio-miropcm20.c:(.text+0x227588): undefined reference to `snd_aci_cmd'
> drivers/built-in.o: In function `pcm20_init':
> radio-miropcm20.c:(.init.text+0x2a784): undefined reference to `snd_aci_get_aci'
> 
> miropcm20 selects SND_MIRO but SND_ISA may be not enabled, so
> also select SND_ISA so that the snd-miro driver will be built.
> Otherwise there are missing symbols:
> 
> ERROR: "snd_opl4_create" [sound/isa/opti9xx/snd-miro.ko] undefined!
> ERROR: "snd_wss_pcm" [sound/isa/opti9xx/snd-miro.ko] undefined!
> ERROR: "snd_wss_timer" [sound/isa/opti9xx/snd-miro.ko] undefined!
> ERROR: "snd_wss_create" [sound/isa/opti9xx/snd-miro.ko] undefined!
> ERROR: "snd_wss_mixer" [sound/isa/opti9xx/snd-miro.ko] undefined!
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Acked-by: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: Krzysztof Helt <krzysztof.h1@wp.pl>
> Cc: Takashi Iwai <tiwai@suse.de>
> ---
>  drivers/media/radio/Kconfig |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 

Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>


----------------------------------------------------------------------
Internetowi nie placa! Otworz Konto Direct.
http://link.interia.pl/f24f7

