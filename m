Return-Path: <linux-kernel-owner+w=401wt.eu-S970907AbXFHUzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970907AbXFHUzz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 16:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753793AbXFHUzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 16:55:47 -0400
Received: from raven.upol.cz ([158.194.120.4]:33790 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752292AbXFHUzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 16:55:46 -0400
Date: Fri, 8 Jun 2007 23:07:12 +0200
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net, "H. Peter Anvin" <hpa@zytor.com>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] scripts: clean-whitespace.sh
Message-ID: <20070608210711.GZ7266@flower.upol.cz>
References: <20070606175026.GA6303@uranus.ravnborg.org> <20070606191426.GT7266@flower.upol.cz> <Pine.LNX.4.64.0706071634470.8762@fbirervta.pbzchgretzou.qr> <20070607230657.GV7266@flower.upol.cz> <4668929C.7040209@zytor.com> <E1HwY9K-0008Jz-CG@flower> <20070607234459.e4dffd65.akpm@linux-foundation.org> <20070608142849.GA23642@uranus.ravnborg.org> <20070608150215.GY7266@flower.upol.cz> <20070608190554.GA25468@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070608190554.GA25468@uranus.ravnborg.org>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2007 at 09:05:54PM +0200, Sam Ravnborg wrote:
[]
> > 
> > It does better whitespace cleanup, than
> > 
> > scripts/{cleanfile *and* cleanpatch}
> 
> Made a short test here.
> Added the following to a file:
> 
> static sam = "                    ";
> 
> clean-whitespace replaced spaces within "" with tabs.
> cleanfile did not.

So, user with `diff` will see that and fix or a way of usage spaces in
strings, or will update BRE, used for that kind of match ;)

Still, better job:
|-*- 
olecom@flower:/tmp$ ls -l ipv62.h.clean
-rw-r----- 1 olecom root 10591 Jun  8 22:47 ipv62.h.clean +2 bytes
olecom@flower:/tmp$ ls -l ipv66.h
-rw-r----- 1 olecom root 10704 Jun  8 22:47 ipv66.h
olecom@flower:/tmp$
|-*-

But there will be two shifted words, because it doesn't calculate
tabstops. I've choose to remove spaces before tab, so it will be visible
and easy to fix by hand. Only spaces up-to next tabstop - 1 after
possible tab is OK.
____
