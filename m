Return-Path: <linux-kernel-owner+w=401wt.eu-S1758149AbXFLDXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758149AbXFLDXs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 23:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754132AbXFLDXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 23:23:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45899 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755666AbXFLDXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 23:23:39 -0400
Date: Mon, 11 Jun 2007 23:22:24 -0400
From: Dave Jones <davej@redhat.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, avi@qumranet.com,
       linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: Re: 2.6.22-rc4-mm2: kvm compile breakage with X86_CMPXCHG64=n
Message-ID: <20070612032224.GA19293@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Adrian Bunk <bunk@stusta.de>,
	Andrew Morton <akpm@linux-foundation.org>, avi@qumranet.com,
	linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org> <20070612000718.GS3588@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070612000718.GS3588@stusta.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2007 at 02:07:18AM +0200, Adrian Bunk wrote:
 
 > I'm getting the following compile error with CONFIG_X86_CMPXCHG64=n 
 > (with -Werror-implicit-function-declaration - otherwise it would be a 
 > link error):

We really should just get that flag into mainline so that it breaks
for people before they submit patches.  We run into this constantly.


Add -Werror-implicit-function-declaration
This makes builds fail sooner if something is implicitly defined instead
of having to wait half an hour for it to fail at the linking stage.

Signed-off-by: Dave Jones <davej@redhat.com>

--- linux-2.6/Makefile~	2007-06-04 16:46:24.000000000 -0400
+++ linux-2.6/Makefile	2007-06-04 16:46:53.000000000 -0400
@@ -313,7 +313,8 @@ LINUXINCLUDE    := -Iinclude \
 CPPFLAGS        := -D__KERNEL__ $(LINUXINCLUDE)
 
 CFLAGS          := -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
-                   -fno-strict-aliasing -fno-common
+		   -fno-strict-aliasing -fno-common \
+		   -Werror-implicit-function-declaration
 AFLAGS          := -D__ASSEMBLY__
 
 # Read KERNELRELEASE from include/config/kernel.release (if it exists)

-- 
http://www.codemonkey.org.uk
