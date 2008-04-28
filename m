Return-Path: <linux-kernel-owner+w=401wt.eu-S937345AbYD1VAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937345AbYD1VAZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 17:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964950AbYD1VAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 17:00:05 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:49571 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934255AbYD1VAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 17:00:01 -0400
Date: Mon, 28 Apr 2008 23:00:34 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Adrian Bunk <bunk@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: [GIT PATCH] SCSI updates for 2.6.25
Message-ID: <20080428210034.GE18248@uranus.ravnborg.org>
References: <1208540517.3063.18.camel@localhost.localdomain> <20080419151934.GA17089@elte.hu> <1208620484.3280.23.camel@localhost.localdomain> <20080419170530.GD1595@cs181133002.pp.htv.fi> <1208626496.3280.40.camel@localhost.localdomain> <alpine.LFD.1.10.0804191305360.2779@woody.linux-foundation.org> <20080419204511.GP20637@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080419204511.GP20637@parisc-linux.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 19, 2008 at 02:45:11PM -0600, Matthew Wilcox wrote:
> On Sat, Apr 19, 2008 at 01:14:23PM -0700, Linus Torvalds wrote:
> > So people: stop this total *idiocy* with "select is bad". It's not. The 
> > lack of select is *much* worse.
> 
> Could we consider applying this patch then?

I applied the following.

	Sam

commit dfecbec8b54038ef02835d2f8181e1f44bd080d2
Author: Matthew Wilcox <matthew@wil.cx>
Date:   Sat Apr 19 14:45:11 2008 -0600

    kconifg: 'select' considered less evil
    
    While select should be used with care, it is not actually evil.
    
    Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
    Signed-off-by: Sam Ravnborg <sam@ravnborg.org>

diff --git a/Documentation/kbuild/kconfig-language.txt b/Documentation/kbuild/kconfig-language.txt
index 649cb87..00b950d 100644
--- a/Documentation/kbuild/kconfig-language.txt
+++ b/Documentation/kbuild/kconfig-language.txt
@@ -104,14 +104,15 @@ applicable everywhere (see syntax).
   Reverse dependencies can only be used with boolean or tristate
   symbols.
   Note:
-	select is evil.... select will by brute force set a symbol
-	equal to 'y' without visiting the dependencies. So abusing
-	select you are able to select a symbol FOO even if FOO depends
-	on BAR that is not set. In general use select only for
-	non-visible symbols (no prompts anywhere) and for symbols with
-	no dependencies. That will limit the usefulness but on the
-	other hand avoid the illegal configurations all over. kconfig
-	should one day warn about such things.
+	select should be used with care. select will force
+	a symbol to a value without visiting the dependencies.
+	By abusing select you are able to select a symbol FOO even
+	if FOO depends on BAR that is not set.
+	In general use select only for non-visible symbols
+	(no prompts anywhere) and for symbols with no dependencies.
+	That will limit the usefulness but on the other hand avoid
+	the illegal configurations all over.
+	kconfig should one day warn about such things.
 
 - numerical ranges: "range" <symbol> <symbol> ["if" <expr>]
   This allows to limit the range of possible input values for int
