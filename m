Return-Path: <linux-kernel-owner+w=401wt.eu-S1757936AbXEISgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936AbXEISgo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 14:36:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756754AbXEISgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 14:36:37 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:45738 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756722AbXEISgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 14:36:36 -0400
Date: Wed, 9 May 2007 11:36:36 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Valdis.Kletnieks@vt.edu
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-mm2 - Kconfig horkage
In-Reply-To: <7574.1178731018@turing-police.cc.vt.edu>
Message-ID: <Pine.LNX.4.64.0705091136010.29025@schroedinger.engr.sgi.com>
References: <20070509012322.199f292b.akpm@linux-foundation.org>
 <5713.1178722647@turing-police.cc.vt.edu>           
 <Pine.LNX.4.64.0705091007050.28520@schroedinger.engr.sgi.com>
 <7574.1178731018@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2007, Valdis.Kletnieks@vt.edu wrote:

> Just seemed odd to do a 'make oldconfig' and get prompted for the value, and it
> gave a value of 'Y' to a debug  option of a feature that wasn't selected.  :)

Indeed strange. This should fix it.



SLUB: SLUB_DEBUG must depend on SLUB

Otherwise people get asked about SLUB_DEBUG even if they have another
slab allocator enabled.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 init/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: slub/init/Kconfig
===================================================================
--- slub.orig/init/Kconfig	2007-05-09 11:32:40.000000000 -0700
+++ slub/init/Kconfig	2007-05-09 11:33:26.000000000 -0700
@@ -569,6 +569,7 @@ config VM_EVENT_COUNTERS
 config SLUB_DEBUG
 	default y
 	bool "Enable SLUB debugging support" if EMBEDDED
+	depends on SLUB
 	help
 	  SLUB has extensive debug support features. Disabling these can
 	  result in significant savings in code size. This also disables
