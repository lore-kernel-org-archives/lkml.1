Return-Path: <linux-kernel-owner+w=401wt.eu-S1756747AbYGBOqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747AbYGBOqo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 10:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754209AbYGBOqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 10:46:36 -0400
Received: from ns.suse.de ([195.135.220.2]:55829 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753330AbYGBOqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 10:46:35 -0400
Date: Wed, 2 Jul 2008 07:41:49 -0700
From: Greg KH <gregkh@suse.de>
To: =?utf-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@pardus.org.tr>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, greg@kroah.com,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Alan Cox <alan@redhat.com>
Subject: Re: [patch 1/9] TTY: fix for tty operations bugs
Message-ID: <20080702144149.GA16850@suse.de>
References: <20080701151057.930340322@mini.kroah.org> <20080701151859.GB3536@suse.de> <20080701160132.GA4496@suse.de> <200807021257.47593.caglar@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200807021257.47593.caglar@pardus.org.tr>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2008 at 12:57:44PM +0300, S.Çağlar Onur wrote:
> Hi Greg;
> 
> 01 Tem 2008 Sal tarihinde, Greg KH şunları yazmıştı: 
> > On Tue, Jul 01, 2008 at 08:18:59AM -0700, Greg KH wrote:
> > > 2.6.25-stable review patch.  If anyone has any objections, please let us know.
> > > 
> > > ------------------
> > > 
> > > From: Alan Cox <alan@lxorguk.ukuu.org.uk>
> > > 
> > > This is fixed with the recent tty operations rewrite in mainline in a
> > > different way, this is a selective backport of the relevant portions to
> > > the -stable tree.
> > > 
> > > Signed-off-by: Alan Cox <alan@redhat.com>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > > 
> > > ---
> > >  drivers/net/hamradio/6pack.c |    2 ++
> > >  drivers/net/hamradio/mkiss.c |    8 ++++++--
> > >  drivers/net/irda/irtty-sir.c |    4 +++-
> > 
> > Hm, there are a few build errors with this patch in these two files,
> > I'll go respin it and do a new -rc release...
> > 
> > Sorry for missing this before.
> 
> I still have following build error 
> 
> [...]
> drivers/net/hamradio/mkiss.c: In function 'ax_xmit':
> drivers/net/hamradio/mkiss.c:548: error: 'struct tty_struct' has no member named 'drivers'
> drivers/net/hamradio/mkiss.c:549: error: 'struct tty_struct' has no member named 'chars_in_buffer'
> drivers/net/hamradio/mkiss.c:552: warning: format '%s' expects type 'char *', but argument 3 has type 'int'
> drivers/net/hamradio/mkiss.c:552: error: expected ';' before ')' token
> drivers/net/hamradio/mkiss.c:552: error: expected statement before ')' token
> 
> *** 4 errors, 1 warnings
> [...]
> 
> after your 
> 
> commit bdd6248729d1f4a75e4623bce4f9c7737753b712
> Author: Greg Kroah-Hartman <gregkh@suse.de>
> Date:   Tue Jul 1 09:44:04 2008 -0700
> 
>     fix build error in tty patch
> 
> commit to stable-queue

Are you sure you redid your patch set, I see fixes for the error
messages above in that patch I did.  I also don't get the build problems
myself anymore.

confused,

greg k-h
