Return-Path: <linux-kernel-owner+w=401wt.eu-S1764510AbYEOS1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764510AbYEOS1T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 14:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752167AbYEOS1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 14:27:09 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:51030 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751563AbYEOS1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 14:27:08 -0400
Date: Thu, 15 May 2008 14:26:43 -0400
From: Theodore Tso <tytso@mit.edu>
To: Stas Sergeev <stsp@aknet.ru>
Cc: Takashi Iwai <tiwai@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roberto Oppedisano <roberto.oppedisano@infracom.it>
Subject: Re: [Bug #10679] 2.6.26-rc1 regression:
	e5e1d3cb20034a3cbcfff1f0bae12201aa2ce17e breaks artsd
Message-ID: <20080515182643.GL18825@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Stas Sergeev <stsp@aknet.ru>, Takashi Iwai <tiwai@suse.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Roberto Oppedisano <roberto.oppedisano@infracom.it>
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera> <88YBFoyd1CN.A._sF.Ov1JIB@chimera> <s5hskwmeb1h.wl%tiwai@suse.de> <20080514212011.GH7054@mit.edu> <s5hhcd0azv1.wl%tiwai@suse.de> <20080515130654.GC18825@mit.edu> <482C71B3.8090200@aknet.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <482C71B3.8090200@aknet.ru>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 09:24:03PM +0400, Stas Sergeev wrote:
> Hello.
> 
> Theodore Tso wrote:
> >> Sounds reasonable.  To where should it be added, BTW?
> >> Little people seem to care about Kconfig help texts, and an extra
> >> comment block (with depends on SND_PCSP) could be annoying...
> > That's a good question.  A note that including including this module
> > could potentially cause sound cards to be renumbered might be
> > reasonable,
> I guess so, and in the description
> string we can probably add something
> to the effect of "READ HELP!".

I don't know if this would be considered too ugly a suggestion to put
in the Kconfig description, but the suggestion in:

http://lkml.org/lkml/2008/5/11/172

To put the following in /etc/modprobe.conf:

options snd-pcsp index=2

Would probably avoid confusion for most users.  It's more than a
little bit hackish, and I imagine I can imagine hotplug/udev fanatics
throwing up all over their keyboard, but short of having udev rules
that run around editing user's ~/.asoundrc files, or creating some
kind of system wide naming scheme so that people can use stable names
in their alsa config files, this is going to be an, ah, "interesting"
problem for various sound applications to deal with.

	      	      	  	  		     - Ted
