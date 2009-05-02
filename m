Return-Path: <linux-kernel-owner+w=401wt.eu-S1752467AbZEBEvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467AbZEBEvV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 00:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750746AbZEBEvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 00:51:10 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:40409 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730AbZEBEvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 00:51:09 -0400
Date: Fri, 1 May 2009 21:51:03 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Christoph Hellwig <hch@infradead.org>, Steve French <smfrench@gmail.com>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Ogawa Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Michael Tokarev <mjt@tls.msk.ru>, Andrew Tridgell <tridge@samba.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
Message-ID: <20090502045103.GA7141@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <524f69650905011318m34e0027dt57877d225b3fe2da@mail.gmail.com> <20090501210109.GA3079@infradead.org> <20090502013729.GI6996@linux.vnet.ibm.com> <20090502015927.GJ8822@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090502015927.GJ8822@parisc-linux.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 07:59:28PM -0600, Matthew Wilcox wrote:
> On Fri, May 01, 2009 at 06:37:29PM -0700, Paul E. McKenney wrote:
> > On Fri, May 01, 2009 at 05:01:09PM -0400, Christoph Hellwig wrote:
> > > >From the complete lack of technical arguments it's pretty obvious that
> > > this seems to be some FUD fallout from the MS vs TomTom patent lawsuite.
> > > 
> > > I'm not a lawyer so I don't know how much of a threat it is.  But either
> > > the case gets shot down by showing prior art and everything is fine, or
> > > we indeed are in deep trouble and should remove it completely.  Given
> > > the Cc list on here IBM seems to have some legal opinion on it, so can
> > > we please see it and discuss what we want to with all cards on the
> > > table?
> > 
> > Hello, Christoph!
> > 
> > Hmmm...  Both Tridge and Dave have Signed-off-by on the original patch,
> > and Steve has Acked-by, Mingming has Cc, and Dave is on the From list
> > rather than the Cc list, so I have to guess that there is a good chance
> > that you are talking about me.  ;-)
> > 
> > However, as far as I know, none of us are lawyers, and LKML is definitely
> > a technical rather than a legal forum, so we really do need to stick to
> > technical topics.  I understand that this might be a bit frustrating
> > to you.  On the other hand, I for one much prefer being in a forum
> > restricted to technical topics than to be in those places designed to
> > handle legal topics!
> 
> So what's the purely technical argument for including this patch?

Pretty much what it says in the config-variable description in the patch
itself.  To recap, with some technical elaboration:

1.	It allows you to read VFAT media, mixed-case long names and all.
	Full compatibility for reading from existing media.

2.	It allows opening existing mixed-case long-named files
	both for reading and writing.

3.	For file creation, only the 8.3-format filename is permitted.
	Such a name can be stored in a single VFAT directory entry.

4.	It allows you to create files with both uppercase and lowercase
	8.3-format names, as long as the 8-character portion is either
	entirely uppercase or entirely lowercase, and as long as
	the 3-character extension is either entirely uppercase
	or entirely lowercase.  This again keeps the name confined
	to a single VFAT directory entry.

>From the original patch, with a couple additional examples added:

o	Creating FILE1234.TXT is allowed.

o	Creating FILE12345.TXT or FILE1234.TEXT is prohibited, as
	neither fits the 8.3 format.

o	Creating FILE.TXT, FILE.txt, file.TXT, and file.txt would all
	be allowed, and would create files by exactly those names.

o	Attempting to create File.TxT will give you a file named FILE.TXT.

There you have it!

							Thanx, Paul
