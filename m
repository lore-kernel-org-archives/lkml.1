Return-Path: <linux-kernel-owner+w=401wt.eu-S1759929AbYAUKxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759929AbYAUKxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 05:53:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758957AbYAUKxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 05:53:43 -0500
Received: from pip9.gyao.ne.jp ([61.122.117.247]:11895 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757820AbYAUKxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 05:53:41 -0500
Date: Mon, 21 Jan 2008 19:52:57 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andreas Schwab <schwab@suse.de>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, linux-arch@vger.kernel.org,
       Greg KH <greg@kroah.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       Adrian Bunk <bunk@kernel.org>
Subject: Re: [PATCH] Use separate sections for __dev/__cpu/__mem code/data
Message-ID: <20080121105257.GA21567@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Sam Ravnborg <sam@ravnborg.org>, Andreas Schwab <schwab@suse.de>,
	linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
	linux-arch@vger.kernel.org, Greg KH <greg@kroah.com>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	Adrian Bunk <bunk@kernel.org>
References: <1200859743-24037-4-git-send-email-sam@ravnborg.org> <1200859743-24037-5-git-send-email-sam@ravnborg.org> <1200859743-24037-6-git-send-email-sam@ravnborg.org> <1200859743-24037-7-git-send-email-sam@ravnborg.org> <1200859743-24037-8-git-send-email-sam@ravnborg.org> <20080121073341.GA20050@linux-sh.org> <20080121095722.GA29145@uranus.ravnborg.org> <jebq7fqxnj.fsf@sykes.suse.de> <20080121104506.GA29585@uranus.ravnborg.org> <20080121104745.GA29721@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080121104745.GA29721@uranus.ravnborg.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2008 at 11:47:45AM +0100, Sam Ravnborg wrote:
> On Mon, Jan 21, 2008 at 11:45:06AM +0100, Sam Ravnborg wrote:
> > On Mon, Jan 21, 2008 at 11:29:52AM +0100, Andreas Schwab wrote:
> > > Sam Ravnborg <sam@ravnborg.org> writes:
> > > 
> > > > On Mon, Jan 21, 2008 at 04:33:41PM +0900, Paul Mundt wrote:
> > > >> so the ## is being taken directly rather than acting as a concatenation.
> > > >
> > > > Strange...
> > > > I can reproduce with gcc 3.4.5 here - will fix.
> > > 
> > > The ## operator does not work with -traditional.
> > 
> > Crap - then it breaks at the following architectures:
> > sh64, s390, m68k, m32r
> > 
> > Thanks Andreas.
> 
> OK - I was too quick it seem.
> sh has:
> arch/sh/Makefile:CPPFLAGS_vmlinux.lds := -traditional
> 
> So this needs to be ripped out as it is not needed.
> 
Yes, that can be killed. If this is aimed at 2.6.25, I'll just kill it
off in my tree. Otherwise, feel free to roll this in to your patch set.

Your kbuild.git works fine with this applied.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

diff --git a/arch/sh/Makefile b/arch/sh/Makefile
index e189fae..6a0eb7d 100644
--- a/arch/sh/Makefile
+++ b/arch/sh/Makefile
@@ -151,8 +151,6 @@ drivers-$(CONFIG_OPROFILE)	+= arch/sh/oprofile/
 
 boot := arch/sh/boot
 
-CPPFLAGS_vmlinux.lds := -traditional
-
 incdir-prefix	:= $(srctree)/include/asm-sh/
 
 #	Update machine arch and proc symlinks if something which affects
