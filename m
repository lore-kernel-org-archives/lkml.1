Return-Path: <linux-kernel-owner+w=401wt.eu-S1757663AbZD3U2F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757663AbZD3U2F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 16:28:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755393AbZD3U1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 16:27:52 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:38485 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760268AbZD3U1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 16:27:51 -0400
Date: Thu, 30 Apr 2009 22:30:00 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Tim Abbott <tabbott@MIT.EDU>
Subject: in_suspend and __nosave
Message-ID: <20090430203000.GA10999@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael & Linus.

While unifying vmlinux.lds for x86 I stumbled
over the .data.nosave section.

Searching a bit I found only a single user:

swsusp.c:int in_suspend __nosavedata = 0;

Do we really needs all this complexity for this single integer?
We have this section defined in several arch lds files.

I understand that in_suspend is special as in that we do not
want the value restored while resuming.
But is there no other way to do so today?

All I want is to kill a lot from the vmlinux.lds files.

It also occur to me that only: x86, powerpc, and sh
implement pfn_is_nosave() which I think is the only
place where we decide if we want to save a page or not.

But we define the .data.nosave section in following
architectures:
arm, m32r, mips, mn10300, parisc, s390 in addition
to the above archs that define pfn_is_nosave().
Is this something to be cleaned up?

	Sam
