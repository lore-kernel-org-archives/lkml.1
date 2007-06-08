Return-Path: <linux-kernel-owner+w=401wt.eu-S1751388AbXFHTFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388AbXFHTFH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 15:05:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751562AbXFHTEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 15:04:54 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:38158 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438AbXFHTEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 15:04:53 -0400
Date: Fri, 8 Jun 2007 21:05:54 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net, "H. Peter Anvin" <hpa@zytor.com>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] scripts: clean-whitespace.sh
Message-ID: <20070608190554.GA25468@uranus.ravnborg.org>
References: <20070606174556.GS7266@flower.upol.cz> <20070606175026.GA6303@uranus.ravnborg.org> <20070606191426.GT7266@flower.upol.cz> <Pine.LNX.4.64.0706071634470.8762@fbirervta.pbzchgretzou.qr> <20070607230657.GV7266@flower.upol.cz> <4668929C.7040209@zytor.com> <E1HwY9K-0008Jz-CG@flower> <20070607234459.e4dffd65.akpm@linux-foundation.org> <20070608142849.GA23642@uranus.ravnborg.org> <20070608150215.GY7266@flower.upol.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070608150215.GY7266@flower.upol.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2007 at 05:02:15PM +0200, Oleg Verych wrote:
> On Fri, Jun 08, 2007 at 04:28:49PM +0200, Sam Ravnborg wrote:
> > On Thu, Jun 07, 2007 at 11:44:59PM -0700, Andrew Morton wrote:
> > > 
> > > Then again, it's a better strategy than trying to read the code ;)
> > > 
> > > Please, tell us what it does, so that we can decide whether we want it in
> > > Linux.
> > 
> > It does the same as cleanfile.pl.
> > I have seen no reason to replace cleanfile.pl with this version.
> 
> It does better whitespace cleanup, than
> 
> scripts/{cleanfile *and* cleanpatch}

Made a short test here.
Added the following to a file:

static sam = "                    ";

clean-whitespace replaced spaces within "" with tabs.
cleanfile did not.

Seems that clean-whitespace has the wrong assumption that any sequence
of <tab-stop>8 spaces<tab-stop> must be replaced with a tab.
It should obviously default to beginning of file.


Running latest cleanfile (it is -mm) on your testfile
gave following output:
cleanfile: ipv6.h
ipv6.h:105: line exceeds 79 characters (89)
ipv6.h:111: line exceeds 79 characters (89)
ipv6.h:350: line exceeds 79 characters (85)
ipv6.h:356: line exceeds 79 characters (85)
ipv6.h:362: line exceeds 79 characters (85)
ipv6.h:386: line exceeds 79 characters (82)
ipv6.h:413: line exceeds 79 characters (85)

And spaces were replaced with tabs only where
it is safe.

	Sam
