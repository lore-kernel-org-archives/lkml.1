Return-Path: <linux-kernel-owner+w=401wt.eu-S1760749AbXISPvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760749AbXISPvv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 11:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755984AbXISPvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 11:51:43 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:17253 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655AbXISPvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 11:51:42 -0400
Date: Wed, 19 Sep 2007 08:50:32 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Philipp Marek <philipp@marek.priv.at>
Cc: Jeff Dike <jdike@addtoit.com>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org
Subject: Re: UML dead with current -git?
Message-Id: <20070919085032.dd5c1732.randy.dunlap@oracle.com>
In-Reply-To: <200709191443.24158@x5>
References: <200709181714.34035@x5>
	<20070918175513.GD26539@uranus.ravnborg.org>
	<20070919013512.GA10873@c2.user-mode-linux.org>
	<200709191443.24158@x5>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007 14:43:23 +0200 Philipp Marek wrote:

> On Wednesday 19 September 2007 Jeff Dike wrote:
> > On Tue, Sep 18, 2007 at 07:55:13PM +0200, Sam Ravnborg wrote:
> > > Sounds to me like a known issue by you. Can you give a few more details
> > > so we maybe can get it fixed?
> > I believe what happened here is an x86_64 build followed by a
> > UML/x86_64 build with no intervening mrproper.
> Yes, after a "make mrproper" it compiles fine.
> However, the .config is gone afterwards ...
> 
> > I've always considered this to be a "don't do that" sort of thing.
> > However, maybe we could stick the arch of the current build somewhere
> > in the tree, check that before any serious part of a subsequent
> > build, and error out if $ARCH is different.
> Well, on this line it may be nice to be able to put the target architecture 
> somewhere ...
> 	make mrproper
> 	make menuconfig ARCH=um
> 	make ARCH=um
> ... some tweaking
> 	make menuconfig
> and the .config is overwritten with the "wrong" architecture.
> (I know about .config.bak and so on ... just a small wish)

Yes, I've tried to coerce the top-level Makefile into honoring/using
the include/asm symlink if it exists, i.e., taking ARCH from
readlink include/asm && sed -e 's/include-asm//', but sadly my
makefile foo was not good enough.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
