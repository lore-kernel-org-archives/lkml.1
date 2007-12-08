Return-Path: <linux-kernel-owner+w=401wt.eu-S1756865AbXLHKIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865AbXLHKIa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 05:08:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753380AbXLHKIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 05:08:17 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53162 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753124AbXLHKIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 05:08:16 -0500
Date: Sat, 8 Dec 2007 02:07:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Zan Lynx <zlynx@acm.org>
Cc: linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org,
       linux-ide@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: 2.6.24-rc4-mm1 and Very Slow PCMCIA Compact Flash
Message-Id: <20071208020722.9c7d91d0.akpm@linux-foundation.org>
In-Reply-To: <1197090093.7157.2.camel@localhost>
References: <1197059904.15428.15.camel@localhost>
	<20071207150251.a0dbae23.akpm@linux-foundation.org>
	<1197068983.15428.29.camel@localhost>
	<20071207152249.360af326.akpm@linux-foundation.org>
	<1197090093.7157.2.camel@localhost>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Dec 2007 22:01:33 -0700 Zan Lynx <zlynx@acm.org> wrote:

> 
> On Fri, 2007-12-07 at 15:22 -0800, Andrew Morton wrote:
> > On Fri, 07 Dec 2007 23:09:43 +0000
> > Zan Lynx <zlynx@acm.org> wrote:
> [cut] 
> > > > > Now with MM kernels 2.6.24 rc1-4 the PCMCIA adapter works again, but I
> > > > > only get read rates of 1.6 MB/s.  When it used to work in 2.6.20 I got
> > > > > at least 16 MB/s.  The card itself is capable of 30+ in the USB-2
> > > > > reader.
> [cut]
> > Maybe pata_pcmcia-minor-cleanups-and-support-for-dual-channel-cards.patch?
> > 
> > Could you try a `patch -R' of the below?
> > 
> > 
> > From: Alan Cox <alan@lxorguk.ukuu.org.uk>
> > 
> > Signed-off-by: Alan Cox <alan@redhat.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---
> > 
> >  drivers/ata/pata_pcmcia.c |   31 +++++++++++++++++--------------
> >  1 file changed, 17 insertions(+), 14 deletions(-)
> > 
> > diff -puN drivers/ata/pata_pcmcia.c~pata_pcmcia-minor-cleanups-and-support-for-dual-channel-cards drivers/ata/pata_pcmcia.c
> [cut]
> 
> Nope, that did not change anything.  It still detects as PIO0 and still
> runs at 1.6 MB/s.

argh.  OK.  And Linus's current tree is OK, yes?

In which case we should be OK for 2.6.24 and I guess we can hope like heck
that the dud patch doesn't leak into mainline.  Hopefully Alan will get
some time to look into it before 2.6.25 opens.

<looks>

OK, there's a patch in Jeff's tree "pata_pcmcia: Add support for dumb 8bit
IDE emulations" which could be our guy.

I've uploaded two patches, against 2.6.24-rc4:

http://userweb.kernel.org/~akpm/zl.with.gz
	origin.patch + git-libata-all.patch

http://userweb.kernel.org/~akpm/zl.without.gz
	origin.patch + git-libata-all.patch - 5ddcddd4dfeb16a9509dad647f509828d6fee605

It would be great if you could test both.  If zl.with is bad and zl.without
is good then we know that 5ddcddd4dfeb16a9509dad647f509828d6fee605 caused
this problem.

Thanks.

