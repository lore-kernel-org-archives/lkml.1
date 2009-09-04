Return-Path: <linux-kernel-owner+w=401wt.eu-S1756926AbZIDPDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926AbZIDPDQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 11:03:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756856AbZIDPDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 11:03:15 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:49915 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756778AbZIDPDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 11:03:14 -0400
X-Greylist: delayed 2023 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Sep 2009 11:03:14 EDT
Date: Fri, 4 Sep 2009 16:28:07 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Mikael Pettersson <mikpe@it.uu.se>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Cox <alan@linux.intel.com>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bug #14015] pty regressed again, breaking expect and gcc's
 testsuite
Message-ID: <20090904162807.1dba7a32@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.00.0909031353360.15956@eeepc.linux-foundation.org>
References: <riPp5fx5ECC.A.2IG.qsGlKB@chimera>
	<19099.52899.620345.326521@pilspetsen.it.uu.se>
	<19100.31254.666066.755541@pilspetsen.it.uu.se>
	<200909012042.59856.rjw@sisk.pl>
	<alpine.LFD.2.00.0909021429360.3590@eeepc.linux-foundation.org>
	<87pra89sgp.fsf@devron.myhome.or.jp>
	<alpine.LFD.2.00.0909031353360.15956@eeepc.linux-foundation.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And if it _doesn't_ fix it, then I think we'll just have to revert the 
> commits in question. We won't have time to root-cause it if the above 
> isn't it.

In which case ppp will no longer work properly in some cases (ditto
other protocols) and things like the pppoe gateway wont work as they
don't in 2.6.30 - you need to go back to somewhere between 2.6.28/29 to
undo this, then apply the alternative locking patches to the
ppp/slip/ax25/etc ldiscs

Is the missing byte always part of the \r\n - that is handled slightly
specially by the n_tty ldisc code and has always been buggy if there is
flow control buffering - back to 1.3 and probably earlier. It happens on
real ttys too given sufficient flow control blockage because the char by
char opost stuff never did space/buffering checks. At least I don't think
the n_tty rework fixed it.
