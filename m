Return-Path: <linux-kernel-owner+w=401wt.eu-S1755379AbZBUXZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379AbZBUXZG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 18:25:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754471AbZBUXYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 18:24:54 -0500
Received: from THUNK.ORG ([69.25.196.29]:49946 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754388AbZBUXYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 18:24:53 -0500
Date: Sat, 21 Feb 2009 12:56:46 -0500
From: Theodore Tso <tytso@mit.edu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Federico Cuello <fedux@lugmen.org.ar>,
       Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bug #12610] sync-Regression in 2.6.28.2?
Message-ID: <20090221175646.GB3750@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Federico Cuello <fedux@lugmen.org.ar>,
	Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>,
	bugme-daemon@bugzilla.kernel.org
References: <juADNmcceYF.A.mdD.Mr0lJB@chimera> <rjPbZ5GRJPO.A.xTF.As0lJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <rjPbZ5GRJPO.A.xTF.As0lJB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 14, 2009 at 09:38:18PM +0100, Rafael J. Wysocki wrote:
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12610
> Subject		: sync-Regression in 2.6.28.2?
> Submitter	: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
> Date		: 2009-01-27 9:35 (19 days old)
> References	: http://marc.info/?l=linux-kernel&m=123304977706620&w=4

This fix for this has landed in mainline post 2.6.29-rc5, as commit
2acf2c.  The deadlock is technically not a regression but it was made
*much* more likely to show up because of commit 31a1266: ("mm:
write_cache_pages cyclic fix, which show up in 2.6.28.1").  

Commit 3a4c68 in mainline backs up the change made in 31a1266, so you
probably won't see this much after 2.6.28.6 (when 3a4c68 was
backported to 2.6.28.y), but we should get commit 2acf2c pushed to
2.6.28.x and 2.6.27.y to completely solve the deadlock problem.

						- Ted
