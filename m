Return-Path: <linux-kernel-owner+w=401wt.eu-S1757329AbZIEKql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329AbZIEKql (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 06:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757288AbZIEKqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 06:46:40 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:48094 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757217AbZIEKqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 06:46:39 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19106.16773.461397.654704@pilspetsen.it.uu.se>
Date: Sat, 5 Sep 2009 12:46:29 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mikael Pettersson <mikpe@it.uu.se>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Cox <alan@linux.intel.com>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [Bug #14015] pty regressed again, breaking expect and gcc's
 testsuite
In-Reply-To: <alpine.LFD.2.00.0909040917120.4537@eeepc.linux-foundation.org>
References: <riPp5fx5ECC.A.2IG.qsGlKB@chimera>
	<19099.52899.620345.326521@pilspetsen.it.uu.se>
	<19100.31254.666066.755541@pilspetsen.it.uu.se>
	<200909012042.59856.rjw@sisk.pl>
	<alpine.LFD.2.00.0909021429360.3590@eeepc.linux-foundation.org>
	<19105.5352.28380.230615@pilspetsen.it.uu.se>
	<alpine.LFD.2.00.0909040729490.5232@eeepc.linux-foundation.org>
	<alpine.LFD.2.00.0909040739060.17375@eeepc.linux-foundation.org>
	<alpine.LFD.2.00.0909040753370.17375@eeepc.linux-foundation.org>
	<alpine.LFD.2.00.0909040804450.23850@eeepc.linux-foundation.org>
	<alpine.LFD.2.00.0909040910140.4537@eeepc.linux-foundation.org>
	<alpine.LFD.2.00.0909040917120.4537@eeepc.linux-foundation.org>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds writes:
 > 
 > 
 > On Fri, 4 Sep 2009, Linus Torvalds wrote:
 > > 
 > > I'm sure you already figured the obvious meaning out, but here's a fixed 
 > > version.
 > 
 > And here's another patch that may also fix this, simply by virtue of 
 > writing the "\r\n" as a single string, rather than as two characters. That 
 > way, we should never get into the situation that th '\r' allocates a new 
 > buffer (larger than one character), and then the later '\n' writing 
 > decides that we've filled up.

Thanks, I'm testing this and the pty_write() fix on i686 and ppc64 now.

Sometimes the bug is difficult to trigger, so I may need to do loads of
testing with different gcc versions before I dare to say that it's fixed.

/Mikael
