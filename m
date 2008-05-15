Return-Path: <linux-kernel-owner+w=401wt.eu-S1752870AbYEONHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbYEONHk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 09:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754707AbYEONHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 09:07:23 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:53319 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753547AbYEONHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 09:07:21 -0400
Date: Thu, 15 May 2008 09:06:54 -0400
From: Theodore Tso <tytso@mit.edu>
To: Takashi Iwai <tiwai@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roberto Oppedisano <roberto.oppedisano@infracom.it>,
       Stas Sergeev <stsp@aknet.ru>
Subject: Re: [Bug #10679] 2.6.26-rc1 regression:
	e5e1d3cb20034a3cbcfff1f0bae12201aa2ce17e breaks artsd
Message-ID: <20080515130654.GC18825@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Takashi Iwai <tiwai@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Roberto Oppedisano <roberto.oppedisano@infracom.it>,
	Stas Sergeev <stsp@aknet.ru>
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera> <88YBFoyd1CN.A._sF.Ov1JIB@chimera> <s5hskwmeb1h.wl%tiwai@suse.de> <20080514212011.GH7054@mit.edu> <s5hhcd0azv1.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hhcd0azv1.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 07:41:06AM +0200, Takashi Iwai wrote:
> Sounds reasonable.  To where should it be added, BTW?
> Little people seem to care about Kconfig help texts, and an extra
> comment block (with depends on SND_PCSP) could be annoying...

That's a good question.  A note that including including this module
could potentially cause sound cards to be renumbered might be
reasonable, since I suspect most users (and most application
programs!) have been accustomed to only having one sound card, and so
building this module may cause sound cards to be renumbered in Kconfig
would at least be a start.

I know this wouldn't help users of distro kernels, but this would at
least be one way of warning distro maintainers to think twice about
enabling it as a module.  BTW, what *is* the utility of this card, and
how do you use it?  I haven't been able to figure out how to use it do
anything entertaining at all.  Any attempts to use it on my system
just lead to various confusing error messages.

Also, BTW, it might be nice to remove the following hunk of text from
drivers/sound/Kconfig:

	I'm told that even without a sound card, you can make your computer
	say more than an occasional beep, by programming the PC speaker.
	Kernel patches and supporting utilities to do that are in the pcsp
	package, available at <ftp://ftp.infradead.org/pub/pcsp/>.

What's there at the above URL is for the 2.2 and 2.4 kernels, and the
utilities at pcsnd-kit.tar.gz don't work (and didn't compile until I
futzed with them slightly).

So I'm still rather puzzled how to make the snd-pcsp actually do
anything useful, unless it simply doesn't work on my Thinkpad.  (Is it
normal that the sound volume levels reported by alsamixer can be muted
or unmounted, but always report 0, and can't be adjusted up?)

   	      	  	 	       - Ted
