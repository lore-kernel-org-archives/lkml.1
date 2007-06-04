Return-Path: <linux-kernel-owner+w=401wt.eu-S1754619AbXFDOHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619AbXFDOHQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 10:07:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753165AbXFDOHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 10:07:01 -0400
Received: from lazybastard.de ([212.112.238.170]:59991 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160AbXFDOHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 10:07:00 -0400
Date: Mon, 4 Jun 2007 16:02:13 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: David Woodhouse <dwmw2@infradead.org>
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
Subject: Re: [Patch 04/18] include/linux/logfs.h
Message-ID: <20070604140212.GA15926@lazybastard.org>
References: <20070603183845.GA8952@lazybastard.org> <20070603184205.GE8952@lazybastard.org> <200706032342.27252.arnd@arndb.de> <20070604091245.GF14823@lazybastard.org> <1180964303.25232.358.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1180964303.25232.358.camel@pmac.infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 June 2007 14:38:23 +0100, David Woodhouse wrote:
> On Mon, 2007-06-04 at 11:12 +0200, Jörn Engel wrote:
> > On Sun, 3 June 2007 23:42:25 +0200, Arnd Bergmann wrote:
> > > On Sunday 03 June 2007, Jörn Engel wrote:
> > > > +struct logfs_je_spillout {
> > > > +       __be64  so_segment[0];
> > > > +}__packed;
> > > 
> > > All the on-disk data structures you define in this file have naturally
> > > aligned members, so the __packed attribute is not needed.
> > 
> > Amen.  It is purely paranoia and I don't even know who is out to get me.
> 
> You can _never_ know who is out to get you, or what architecture we'll
> be ported to next week.
> 
> The advice "don't tell the compiler what you want unless you _know_
> it'll do the wrong thing otherwise" runs counter to everything we've
> learned, slowly and painfully, over the last few years.
> 
> We should never rely on compiler behaviour which is undocumented and
> unrequired. Even if you know that the ABI forces it to continue to do
> the right thing on the platforms you _currently_ care about, it might
> not do it on new platforms (or existing platforms you didn't manage to
> test).
> 
> It would be better if GCC had a 'nopadding' attribute which gave us what
> we need without the _extra_ implications about alignment. In the absence
> of that, though, you should at _least_ have a check on the size of the
> structure if you're doing to drop the packed attribute.

Adding a size check is simple enough.  But given all this I'll put it to
the very end of my todo list.  There are many other optimizations
remaining.

Jörn

-- 
Joern's library part 14:
http://www.sandpile.org/
