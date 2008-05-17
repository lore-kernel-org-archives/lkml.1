Return-Path: <linux-kernel-owner+w=401wt.eu-S1760346AbYEQUqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760346AbYEQUqx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 16:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758581AbYEQUqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 16:46:45 -0400
Received: from testure.choralone.org ([194.9.77.134]:43220 "EHLO
	testure.choralone.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286AbYEQUqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 16:46:44 -0400
Date: Sat, 17 May 2008 16:47:25 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Takashi Iwai <tiwai@suse.de>
Cc: Theodore Tso <tytso@mit.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roberto Oppedisano <roberto.oppedisano@infracom.it>,
       Stas Sergeev <stsp@aknet.ru>
Subject: Re: [Bug #10679] 2.6.26-rc1 regression:
	e5e1d3cb20034a3cbcfff1f0bae12201aa2ce17e breaks artsd
Message-ID: <20080517204725.GA11460@codemonkey.org.uk>
Mail-Followup-To: Dave Jones <davej@codemonkey.org.uk>,
	Takashi Iwai <tiwai@suse.de>, Theodore Tso <tytso@mit.edu>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Roberto Oppedisano <roberto.oppedisano@infracom.it>,
	Stas Sergeev <stsp@aknet.ru>
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera> <88YBFoyd1CN.A._sF.Ov1JIB@chimera> <s5hskwmeb1h.wl%tiwai@suse.de> <20080514212011.GH7054@mit.edu> <s5hhcd0azv1.wl%tiwai@suse.de> <20080515130654.GC18825@mit.edu> <s5h8wybr0c2.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h8wybr0c2.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 06:36:29PM +0200, Takashi Iwai wrote:
 > At Thu, 15 May 2008 09:06:54 -0400,
 > Theodore Tso wrote:
 > > 
 > > On Thu, May 15, 2008 at 07:41:06AM +0200, Takashi Iwai wrote:
 > > > Sounds reasonable.  To where should it be added, BTW?
 > > > Little people seem to care about Kconfig help texts, and an extra
 > > > comment block (with depends on SND_PCSP) could be annoying...
 > > 
 > > That's a good question.  A note that including including this module
 > > could potentially cause sound cards to be renumbered might be
 > > reasonable, since I suspect most users (and most application
 > > programs!) have been accustomed to only having one sound card, and so
 > > building this module may cause sound cards to be renumbered in Kconfig
 > > would at least be a start.
 > 
 > Yes.
 > 
 > > I know this wouldn't help users of distro kernels, but this would at
 > > least be one way of warning distro maintainers to think twice about
 > > enabling it as a module.

That arrived in my inbox slightly to late :)

 > Well, yeah, for distro kernels, it's then a problem of distributors :)
 
>From todays Fedora kernel changelog :-

* Sat May 17 2008 Dave Jones <davej@redhat.com>
- Disable CONFIG_SND_PCSP (#447039)

Problem solved :-)

More seriously, it doesn't seem that there's any way we can build
this driver modular without it screwing up already working systems
unless we cripple its MODULE_ALIAS to not autoload, allowing users
who care about it (which will be in the minority anyway) to add it manually.

	Dave

-- 
http://www.codemonkey.org.uk
