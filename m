Return-Path: <linux-kernel-owner+w=401wt.eu-S1753141AbXFDJGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141AbXFDJGU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 05:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751297AbXFDJGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 05:06:08 -0400
Received: from lazybastard.de ([212.112.238.170]:55183 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbXFDJGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 05:06:06 -0400
Date: Mon, 4 Jun 2007 11:01:26 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       Sam Ravnborg <sam@ravnborg.org>, John Stoffel <john@stoffel.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Jamie Lokier <jamie@shareable.org>,
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
Subject: Re: [Patch 09/18] fs/logfs/gc.c
Message-ID: <20070604090126.GB14823@lazybastard.org>
References: <20070603183845.GA8952@lazybastard.org> <20070603184604.GJ8952@lazybastard.org> <200706040007.38578.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200706040007.38578.arnd@arndb.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 June 2007 00:07:36 +0200, Arnd Bergmann wrote:
> On Sunday 03 June 2007, Jörn Engel wrote:
> > +static long decay(long t0, long t, long theta)
> > +{
> > +       long shift, fac;
> > +
> > +       if (t >= 32*theta)
> > +               return 0;
> > +
> > +       shift = t/theta;
> > +       fac = theta - (t%theta)/2;
> > +       return (t0 >> shift) * fac / theta;
> > +}
> 
> I think it's confusion to work with 'long' arguments
> here. If you actually allow larger than 32 bit arguments,
> that means that the gc logic behaves differently on
> 32 and 64 bit CPUs, which I don't think is what you
> intended.

Different behaviour would be fine.  This function will be used to pick
good candidates for garbage collection.  If one segment will get chosen
over another depending on BITS_PER_LONG, either one would have been a
good candidate anyway.

Hmm.  Maybe I should s/32/BITS_PER_LONG/ in the function.

> Also, can any of the arguments be negative? How about
> making them all explicit u32 and u64 variables?

That would make sense, yes.

Jörn

-- 
I've never met a human being who would want to read 17,000 pages of
documentation, and if there was, I'd kill him to get him out of the
gene pool.
-- Joseph Costello
