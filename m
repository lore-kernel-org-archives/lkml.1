Return-Path: <linux-kernel-owner+w=401wt.eu-S1753150AbZAFB3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150AbZAFB3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 20:29:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751293AbZAFB3C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 20:29:02 -0500
Received: from mx2.redhat.com ([66.187.237.31]:42884 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbZAFB3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 20:29:00 -0500
Date: Tue, 6 Jan 2009 01:27:59 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Milan Broz <mbroz@redhat.com>,
       Jaya Kumar <jayakumar.video@gmail.com>,
       Laurent Pinchart <laurent.pinchart@skynet.be>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Gene Sally <Gene.Sally@timesys.com>, Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: strncat() misuse (was: Re: dm_attr_{name,uuid}_show buffer overflow? (was: Re: linux-next: Tree for January 5))
Message-ID: <20090106012759.GA3512@agk.fab.redhat.com>
Mail-Followup-To: Alasdair G Kergon <agk@redhat.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Milan Broz <mbroz@redhat.com>,
	Jaya Kumar <jayakumar.video@gmail.com>,
	Laurent Pinchart <laurent.pinchart@skynet.be>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Gene Sally <Gene.Sally@timesys.com>,
	Sam Ravnborg <sam@ravnborg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <20090105173517.deeff918.sfr@canb.auug.org.au> <Pine.LNX.4.64.0901052225400.5451@anakin> <Pine.LNX.4.64.0901052259420.5451@anakin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0901052259420.5451@anakin>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2009 at 11:18:38PM +0100, Geert Uytterhoeven wrote:
> On Mon, 5 Jan 2009, Geert Uytterhoeven wrote:
> > On Mon, 5 Jan 2009, Stephen Rothwell wrote:

> > |         strncat(buf, "\n", DM_NAME_LEN);
> > |         return strnlen(buf, DM_NAME_LEN);

> > Probably the intention was to limit the string in _buf_ (not the source string
> > "\n") to DM_NAME_LEN? If yes, this may cause a buffer overflow.

Both the 'n's look bogus to me as runtime checks.  But I think the code happens
to work correctly - apart from your compilation problem.

buf is always a page and both strings (name and uuid) are NULL-terminated and
the longest possible is 128 chars of uuid plus the "\n" i.e. 130 (except for a
bug I noticed on one code path which we'll fix).

Alasdair
-- 
agk@redhat.com
