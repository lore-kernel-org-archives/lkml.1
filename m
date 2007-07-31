Return-Path: <linux-kernel-owner+w=401wt.eu-S1756912AbXGaKMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912AbXGaKMw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 06:12:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754450AbXGaKMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 06:12:45 -0400
Received: from ozlabs.org ([203.10.76.45]:55922 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754249AbXGaKMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 06:12:44 -0400
Subject: [PATCH] Fix lguest driver config options
From: Rusty Russell <rusty@rustcorp.com.au>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Satyam Sharma <satyam.sharma@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       lguest <lguest@ozlabs.org>
In-Reply-To: <46ADB8BD.6010600@googlemail.com>
References: <46ACAFBF.6060609@googlemail.com>
	 <1185755123.12151.102.camel@localhost.localdomain>
	 <a781481a0707291748x5a70c2d3i83ef54d7f2336b33@mail.gmail.com>
	 <1185757669.12151.108.camel@localhost.localdomain>
	 <46ADB8BD.6010600@googlemail.com>
Content-Type: text/plain
Date: Tue, 31 Jul 2007 20:11:59 +1000
Message-Id: <1185876719.6131.82.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-30 at 12:09 +0200, Gabriel C wrote:
> BTW the wrong patch without the default y got merged.

Thanks.  Linus, please apply.

Lguest drivers need to default to "Y" otherwise they're never selected
for new builds.  We don't bother prompting, because they're less than
4k combined.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r e6b25e5473dc drivers/lguest/Kconfig
--- a/drivers/lguest/Kconfig	Tue Jul 31 20:04:51 2007 +1000
+++ b/drivers/lguest/Kconfig	Tue Jul 31 20:06:00 2007 +1000
@@ -21,8 +21,10 @@ config LGUEST_GUEST
 
 config LGUEST_NET
 	tristate
+	default y
 	depends on LGUEST_GUEST && NET
 
 config LGUEST_BLOCK
 	tristate
+	default y
 	depends on LGUEST_GUEST && BLOCK


