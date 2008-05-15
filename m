Return-Path: <linux-kernel-owner+w=401wt.eu-S1764213AbYEOVki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764213AbYEOVki (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 17:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755107AbYEOVka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 17:40:30 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:38401 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754917AbYEOVk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 17:40:28 -0400
Date: Thu, 15 May 2008 17:40:20 -0400
From: Theodore Tso <tytso@mit.edu>
To: Stas Sergeev <stsp@aknet.ru>
Cc: Takashi Iwai <tiwai@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roberto Oppedisano <roberto.oppedisano@infracom.it>
Subject: Re: [patch] snd-pcsp: adjust help texts to frighten users
Message-ID: <20080515214020.GO18825@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Stas Sergeev <stsp@aknet.ru>, Takashi Iwai <tiwai@suse.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Roberto Oppedisano <roberto.oppedisano@infracom.it>
References: <88YBFoyd1CN.A._sF.Ov1JIB@chimera> <s5hskwmeb1h.wl%tiwai@suse.de> <20080514212011.GH7054@mit.edu> <s5hhcd0azv1.wl%tiwai@suse.de> <20080515130654.GC18825@mit.edu> <482C71B3.8090200@aknet.ru> <20080515182643.GL18825@mit.edu> <482C8A43.1020208@aknet.ru> <20080515195331.GM18825@mit.edu> <482C99A4.8030201@aknet.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <482C99A4.8030201@aknet.ru>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2008 at 12:14:28AM +0400, Stas Sergeev wrote:
> Hello.
> 
> Theodore Tso wrote:
> > I tried replacing it, but I'm still getting silence when I use "aplay
> > -D plughw:0,0 /usr/share/sounds/login.wav".  If I use "aplay -D
> > hw:0,0", I still get the "aplay: set_params:900: Sample format non
> > available" error message.
> You don't need to specify anything
> with the fixed conf. You probably
> even _should_ not. Could you please
> just try "aplay /usr/share/sounds/login.wav"
> or mpg123 or anything else the most
> usual way you do?
> Oh, and it would be best to remove
> for the moment the custom /etc/asound.conf
> if any.

OK, with my ~/.asoundrc file moved out of the way (but with the fixed
config file installed):

# aplay /usr/share/sounds/login.wav 
ALSA lib pcm_direct.c:901:(snd_pcm_direct_initialize_slave) requested or auto-format is not available
ALSA lib pcm_dmix.c:876:(snd_pcm_dmix_open) unable to initialize slave

# aplay -D hw:0,0 /usr/share/sounds/login.wav 
Playing WAVE '/usr/share/sounds/login.wav' : Signed 16 bit Little Endian, Rate 44100 Hz, Stereo
aplay: set_params:900: Sample format non available

# aplay -D plughw:0 /usr/share/sounds/login.wav 
Playing WAVE '/usr/share/sounds/login.wav' : Signed 16 bit Little Endian, Rate 44100 Hz, Stereo
  <no sound, but aplay sits there as if it was sending sound to a muted
  speaker and exits after approximately the amount of time for the wav
  file would take to play>

Is moving ~/.asoundrc out of the way sufficient?  Or do I need to
reboot or logout/login again to clear something?  I don't think there
are any user space daemons involved here, but...

> > This is with Ubuntu Gutsy; for a variety of
> > reasons, I haven't yet updated my primary laptop to Hardy yet.  I can
> > try booting a bleeding edge kernel on my Hardy machine and see whether
> > it works any better there.
> Well, yeah, it would be nice to have
> alsa-lib 1.0.16, which one is on Gutsy?

1.0.14.  Yeah, it's over 12 months old.....

						- Ted

> PS: your messages are a bit strange.
> When I press "Reply to All" in a
> thunderbird mailer, it sets all the
> e-mail addresses as "To:". And it
> includes my own address. And it includes
> your address twice. This is weird. I
> am fixing that by hands.
> With all other messages, by pressing
> "reply to all", it composes the message
> with all addresses set to "Cc:", and only
> one is set to "To:", with my own address
> not included at all

Hmm, I don't know.  I'm not setting a reply-to header.  My e-mail
messages do have an SMTP envelope from field of tytso@thunk.org, but
that shouldn't be visible to MUA's.  (It just means that MTA's send
bounce messages to tytso@thunk.org, which I need to do since my
outgoing e-mail path goes through thunk.org, and if I didn't do I
might trip certain spam filters which check to see if the domain of
the SMTP "MAIL FROM" matches the domain of the sending SMTP server.)

In any case, my outgoing RFC 822 message headers on my end looks like
this:

To: Stas Sergeev <stsp@aknet.ru>
Cc: Takashi Iwai <tiwai@suse.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Roberto Oppedisano <roberto.oppedisano@infracom.it>
Bcc: tytso@mit.edu
Subject: Re: [patch] snd-pcsp: adjust help texts to frighten users
Reply-To: 
In-Reply-To: <482C99A4.8030201@aknet.ru>

It might be interesting to see what you receive it on your end.
