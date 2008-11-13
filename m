Return-Path: <linux-kernel-owner+w=401wt.eu-S1752872AbYKMQii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872AbYKMQii (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 11:38:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751055AbYKMQi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 11:38:29 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:44854 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750948AbYKMQi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 11:38:29 -0500
Date: Thu, 13 Nov 2008 17:38:02 +0100
From: Pavel Machek <pavel@suse.cz>
To: Andres Salomon <dilinger@queued.net>
Cc: Takashi Iwai <tiwai@suse.de>, Jeremy Katz <katzj@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Jordan Crouse <jordan.crouse@amd.com>, linux-kernel@vger.kernel.org,
       dsaxena@laptop.org
Subject: Re: [PATCH] ALSA: cs5535audio: only build OLPC support if
	MGEODE_LX is defined
Message-ID: <20081113163802.GA1734@ucw.cz>
References: <s5hwsfapdoj.wl%tiwai@suse.de> <20081111140406.GA3244@elte.hu> <20081109201710.4c490f04@debxo> <1226498050.12791.45.camel@aglarond.local> <s5hbpwlj9w1.wl%tiwai@suse.de> <1226547898.13077.83.camel@aglarond.local> <s5h63msru7z.wl%tiwai@suse.de> <20081113153714.GA1520@ucw.cz> <s5h3ahvhb9w.wl%tiwai@suse.de> <20081113111428.59aa36cb@ephemeral>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081113111428.59aa36cb@ephemeral>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-11-13 11:14:28, Andres Salomon wrote:
> On Thu, 13 Nov 2008 16:54:19 +0100
> Takashi Iwai <tiwai@suse.de> wrote:
> 
> > At Thu, 13 Nov 2008 16:37:14 +0100,
> > Pavel Machek wrote:
> [...]
> > > 
> > > > IMO, the basic problem is rather that the platform and the CPU
> > > > selection is mixed up.  The geode GPIO stuff shouldn't belong to
> > > > CPU selection.
> > > 
> > > ACK... and suggested patch makes it worse.
> > > 
> > > There should be option 'support OLPC' somewhere, and that should
> > > enable the gpio bits. Alsa driver should depend on that one.
> > 
> > Any better fix patch is welcome, of course :)
> > This would make save a lot time than writing mails...

> 
> Okay, how about something like the following?

It is wrong. It is valid & useful to compile kernel for i386 and
expect all the features on OLPC (with small performance hit).

								Pavel

> This is a temporary work-around until the geode_gpio* calls are moved out
> into a separate config option.  We don't want to force generic kernel
> maintainers to have to build a specific OLPC kernel.
> 
> Signed-off-by: Andres Salomon <dilinger@debian.org>
> ---
>  sound/pci/cs5535audio/Makefile |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/sound/pci/cs5535audio/Makefile b/sound/pci/cs5535audio/Makefile
> index ccc6422..fda7a94 100644
> --- a/sound/pci/cs5535audio/Makefile
> +++ b/sound/pci/cs5535audio/Makefile
> @@ -4,7 +4,9 @@
>  
>  snd-cs5535audio-y := cs5535audio.o cs5535audio_pcm.o
>  snd-cs5535audio-$(CONFIG_PM) += cs5535audio_pm.o
> +ifdef CONFIG_MGEODE_LX
>  snd-cs5535audio-$(CONFIG_OLPC) += cs5535audio_olpc.o
> +endif
>  
>  # Toplevel Module Dependency
>  obj-$(CONFIG_SND_CS5535AUDIO) += snd-cs5535audio.o

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
