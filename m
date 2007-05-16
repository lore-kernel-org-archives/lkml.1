Return-Path: <linux-kernel-owner+w=401wt.eu-S1762284AbXEPDdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762284AbXEPDdp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 23:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756771AbXEPDdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 23:33:38 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38393 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756597AbXEPDdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 23:33:38 -0400
Date: Wed, 16 May 2007 04:33:35 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, zippel@linux-m68k.org,
       kbuild-devel@lists.sourceforge.net
Subject: [RFC] select and dependencies in Kconfig
Message-ID: <20070516033335.GH4095@ftp.linux.org.uk>
References: <E1Ho2om-0003TN-Ah@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Ho2om-0003TN-Ah@ZenIV.linux.org.uk>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2007 at 08:36:20PM +0100, Al Viro wrote:
> 
> stuff that does select USB should depend on USB_ARCH_HAS_HCD, or we'll
> end up with unbuildable configs.

BTW, this kind of situation happens often enough, so how about doing
the following: teach kconfig that if FOO selects BAR and BAR depends
on <expr>, we should act as if FOO had explicit depends on <expr>.

Rationale: if FOO selects BAR, BAR depends on <expr> and <expr> is false,
turning FOO on will land us into unbuildable configuration (BAR turned on,
dependencies of BAR are not satisfied).  It really happens often enough to
be very annoying.  And we have fsckloads of dependencies that are there
only because of such scenarios.  Gets especially nasty when BAR is selected
by several dozens of options and dependencies of BAR change...

Implementing that is pretty simply; the only thing I'm not sure how to deal
with is how to show such inherited dependencies in menuconfig et.al.

Comments?
