Return-Path: <linux-kernel-owner+w=401wt.eu-S1758667AbXGDWTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758667AbXGDWTg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 18:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbXGDWT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 18:19:26 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:50859 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751328AbXGDWTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 18:19:25 -0400
Date: Thu, 5 Jul 2007 00:19:53 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Paul Mackerras <paulus@samba.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org
Subject: The big suspend mess
Message-ID: <20070704221952.GM3492@stusta.de>
References: <20070703042916.GA17240@srcf.ucam.org> <200707031456.40890.rjw@sisk.pl> <1183497290.3388.4.camel@localhost.localdomain> <200707032332.49694.rjw@sisk.pl> <18059.5165.861038.392332@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <18059.5165.861038.392332@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 04, 2007 at 01:29:49PM +1000, Paul Mackerras wrote:
> Rafael J. Wysocki writes:
> 
> > Still, do you really think that we're ready to drop it _right_ _now_ (I'm
> > referring to suspend only) and if so than on what basis (except that you
> > don't like it, which falls short of being a techical argument)?
> 
> The basis is that it (the freezer) causes more deadlocks and other
> problems than it avoids, so it's a net win to remove it.

You forget one important point:
Regressions are much worse than normal bugs.

It's not about the question whether the driver was "correct" or
"buggy" - for a user the important question is whether it worked in 
practice, and if yes, whether it continues to work.

And my impression is that every time someone touches some part of the 
suspend code some drivers break.

During 2.6.21-rc, it wasn't unusual for users to run with one kernel 
into up to three distinct suspend regressions on one machine.

And no, it wasn't always the same set of distinct regressions.

IMHO the suspend code is currently way too much of a moving target which 
results in this mess.

The correct order seems to be:
1. agree on what the suspend code as a whole should look like
2. implement this
3. fix ALL drivers to work at least as good as they do today
4. get it tested in -mm
5. fix all bugs people run into
6. submit it for inclusion in Linus' tree
7. quickly work on the most likely big amount of bug reports

Step 1 is the most important one - evolving code is often something 
good, but in this case with different people trying to evolve the 
suspend code in different directions it simply results in a big mess.

> Paul.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

