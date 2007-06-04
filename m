Return-Path: <linux-kernel-owner+w=401wt.eu-S1756228AbXFDNjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228AbXFDNjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 09:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754809AbXFDNjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 09:39:00 -0400
Received: from canuck.infradead.org ([209.217.80.40]:35383 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788AbXFDNi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 09:38:58 -0400
Subject: Re: [Patch 04/18] include/linux/logfs.h
From: David Woodhouse <dwmw2@infradead.org>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
       akpm@osdl.org, Sam Ravnborg <sam@ravnborg.org>,
       John Stoffel <john@stoffel.org>, Jamie Lokier <jamie@shareable.org>,
       Artem Bityutskiy <dedekind@infradead.org>, CaT <cat@zip.com.au>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       David Weinehall <tao@acc.umu.se>, Willy Tarreau <w@1wt.eu>,
       Kyle Moffett <mrmacman_g4@mac.com>, Dongjun Shin <djshin90@gmail.com>,
       Pavel Machek <pavel@ucw.cz>, Bill Davidsen <davidsen@tmr.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Albert Cahalan <acahalan@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Roland Dreier <rdreier@cisco.com>,
       Ondrej Zajicek <santiago@crfreenet.org>,
       Ulisses Furquim <ulissesf@gmail.com>
In-Reply-To: <20070604091245.GF14823@lazybastard.org>
References: <20070603183845.GA8952@lazybastard.org>
	 <20070603184205.GE8952@lazybastard.org> <200706032342.27252.arnd@arndb.de>
	 <20070604091245.GF14823@lazybastard.org>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 04 Jun 2007 14:38:23 +0100
Message-Id: <1180964303.25232.358.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-17.fc7.dwmw2.1) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-04 at 11:12 +0200, Jörn Engel wrote:
> On Sun, 3 June 2007 23:42:25 +0200, Arnd Bergmann wrote:
> > On Sunday 03 June 2007, Jörn Engel wrote:
> > > +struct logfs_je_spillout {
> > > +       __be64  so_segment[0];
> > > +}__packed;
> > 
> > All the on-disk data structures you define in this file have naturally
> > aligned members, so the __packed attribute is not needed.
> 
> Amen.  It is purely paranoia and I don't even know who is out to get me.

You can _never_ know who is out to get you, or what architecture we'll
be ported to next week.

The advice "don't tell the compiler what you want unless you _know_
it'll do the wrong thing otherwise" runs counter to everything we've
learned, slowly and painfully, over the last few years.

We should never rely on compiler behaviour which is undocumented and
unrequired. Even if you know that the ABI forces it to continue to do
the right thing on the platforms you _currently_ care about, it might
not do it on new platforms (or existing platforms you didn't manage to
test).

It would be better if GCC had a 'nopadding' attribute which gave us what
we need without the _extra_ implications about alignment. In the absence
of that, though, you should at _least_ have a check on the size of the
structure if you're doing to drop the packed attribute.

-- 
dwmw2

