Return-Path: <linux-kernel-owner+w=401wt.eu-S1756056AbYENVUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056AbYENVUj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 17:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754029AbYENVU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 17:20:27 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:33990 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752371AbYENVUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 17:20:25 -0400
Date: Wed, 14 May 2008 17:20:11 -0400
From: Theodore Tso <tytso@mit.edu>
To: Takashi Iwai <tiwai@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roberto Oppedisano <roberto.oppedisano@infracom.it>,
       Stas Sergeev <stsp@aknet.ru>
Subject: Re: [Bug #10679] 2.6.26-rc1 regression:
	e5e1d3cb20034a3cbcfff1f0bae12201aa2ce17e breaks artsd
Message-ID: <20080514212011.GH7054@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Takashi Iwai <tiwai@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Roberto Oppedisano <roberto.oppedisano@infracom.it>,
	Stas Sergeev <stsp@aknet.ru>
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera> <88YBFoyd1CN.A._sF.Ov1JIB@chimera> <s5hskwmeb1h.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hskwmeb1h.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 12:46:50PM +0200, Takashi Iwai wrote:
> At Sun, 11 May 2008 22:04:16 +0200 (CEST),
> Rafael J. Wysocki wrote:
> > 
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> 
> It's no regression but just a problem of a new driver.  The reporter
> must have added the new config (CONFIG_SND_PCSP=[y,m]) explicitly.

People who include this driver (either because they added it thinking
it wouldn't do much), or because their distro compiles lots of stuff
as module, could potentially get surprised, if it renumbers how the
soundcards are enumerated.  On my system, my sound card ended up going
from hw:0 to hw:1, which given my ~/.asoundrc, meant that sound
appeared to be broken with errors such as this:

aplay: set_params:900: Sample format non available

Once I edited by ~/.asoundrc file to use hw:1 instead of hw:0 the
problem went away, so it's really not a kernel _bug_ per se, but the
result might be surprising.  Maybe there should be a quick warning in
the Kconfig file?  It's not that big of a deal, but I did end up
spending quite a bit of time trying to track down what I initially
thought was a regression.

Regards,

						- Ted
