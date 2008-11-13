Return-Path: <linux-kernel-owner+w=401wt.eu-S1752916AbYKMQWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916AbYKMQWj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 11:22:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751358AbYKMQWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 11:22:30 -0500
Received: from mail.queued.net ([207.210.101.209]:1522 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315AbYKMQW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 11:22:29 -0500
Date: Thu, 13 Nov 2008 11:14:28 -0500
From: Andres Salomon <dilinger@queued.net>
To: Takashi Iwai <tiwai@suse.de>
Cc: Pavel Machek <pavel@suse.cz>, Jeremy Katz <katzj@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Jordan Crouse <jordan.crouse@amd.com>, linux-kernel@vger.kernel.org,
       dsaxena@laptop.org
Subject: [PATCH] ALSA: cs5535audio: only build OLPC support if MGEODE_LX is
 defined
Message-ID: <20081113111428.59aa36cb@ephemeral>
In-Reply-To: <s5h3ahvhb9w.wl%tiwai@suse.de>
References: <20081111125402.GB14989@elte.hu>
	<s5hzlk6pea6.wl%tiwai@suse.de>
	<20081111135306.GA32709@elte.hu>
	<s5hwsfapdoj.wl%tiwai@suse.de>
	<20081111140406.GA3244@elte.hu>
	<20081109201710.4c490f04@debxo>
	<1226498050.12791.45.camel@aglarond.local>
	<s5hbpwlj9w1.wl%tiwai@suse.de>
	<1226547898.13077.83.camel@aglarond.local>
	<s5h63msru7z.wl%tiwai@suse.de>
	<20081113153714.GA1520@ucw.cz>
	<s5h3ahvhb9w.wl%tiwai@suse.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2008 16:54:19 +0100
Takashi Iwai <tiwai@suse.de> wrote:

> At Thu, 13 Nov 2008 16:37:14 +0100,
> Pavel Machek wrote:
[...]
> > 
> > > IMO, the basic problem is rather that the platform and the CPU
> > > selection is mixed up.  The geode GPIO stuff shouldn't belong to
> > > CPU selection.
> > 
> > ACK... and suggested patch makes it worse.
> > 
> > There should be option 'support OLPC' somewhere, and that should
> > enable the gpio bits. Alsa driver should depend on that one.
> 
> Any better fix patch is welcome, of course :)
> This would make save a lot time than writing mails...
> 
> 
> thanks,
> 
> Takashi


Okay, how about something like the following?







This is a temporary work-around until the geode_gpio* calls are moved out
into a separate config option.  We don't want to force generic kernel
maintainers to have to build a specific OLPC kernel.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 sound/pci/cs5535audio/Makefile |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/sound/pci/cs5535audio/Makefile b/sound/pci/cs5535audio/Makefile
index ccc6422..fda7a94 100644
--- a/sound/pci/cs5535audio/Makefile
+++ b/sound/pci/cs5535audio/Makefile
@@ -4,7 +4,9 @@
 
 snd-cs5535audio-y := cs5535audio.o cs5535audio_pcm.o
 snd-cs5535audio-$(CONFIG_PM) += cs5535audio_pm.o
+ifdef CONFIG_MGEODE_LX
 snd-cs5535audio-$(CONFIG_OLPC) += cs5535audio_olpc.o
+endif
 
 # Toplevel Module Dependency
 obj-$(CONFIG_SND_CS5535AUDIO) += snd-cs5535audio.o
-- 
1.5.6.5
