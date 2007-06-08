Return-Path: <linux-kernel-owner+w=401wt.eu-S966702AbXFHBXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966702AbXFHBXl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 21:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934487AbXFHBXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 21:23:33 -0400
Received: from raven.upol.cz ([158.194.120.4]:34934 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933212AbXFHBXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 21:23:32 -0400
Date: Fri, 8 Jun 2007 03:35:21 +0200
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       kbuild-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Another version of cleanfile/cleanpatch
Message-ID: <20070608013521.GW7266@flower.upol.cz>
References: <20070605133834.GO7266@flower.upol.cz> <20070605141254.GA24722@uranus.ravnborg.org> <20070605145759.GP7266@flower.upol.cz> <20070605151101.GQ7266@flower.upol.cz> <20070606174556.GS7266@flower.upol.cz> <20070606175026.GA6303@uranus.ravnborg.org> <20070606191426.GT7266@flower.upol.cz> <Pine.LNX.4.64.0706071634470.8762@fbirervta.pbzchgretzou.qr> <20070607230657.GV7266@flower.upol.cz> <4668929C.7040209@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4668929C.7040209@zytor.com>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2007 at 04:19:56PM -0700, H. Peter Anvin wrote:
> Oleg Verych wrote:
> > 
> > Because of that, i think, following is redundant:
> > 
> > - to check for binary files
> 
> find . -type f | xargs cleanfile

What about patches?

Anyway, by agreement (with myself), i've stopped on having per-file-name
division (prev. message first patch, and that was last design remaining
from cleanfile/cleanpatch). So:

for f in $*
do clean-whitespace $f 2>&1 >/dev/null
done

But this doesn't look like interactive usage, which i've concluded.
Plus copy is saved in $f.clean file, so user can `diff -u` to see any
destruction and possibly report a bug.

[] 
> > - scan whole file for long lines, with useless bunch of messages about
> >   ones. Useless, because script doesn't fix that, it can't do that!
> 
> Still useful to let the human know what is going on, and why.

What i've done was `cleanpatch patch-2.6.21-rc4-rc5`
That's where usefulness comes from ;)

> 	-hpa
____
