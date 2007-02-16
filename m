Return-Path: <linux-kernel-owner+w=401wt.eu-S1946216AbXBPSwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946216AbXBPSwz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 13:52:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946217AbXBPSwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 13:52:55 -0500
Received: from tomts10.bellnexxia.net ([209.226.175.54]:63671 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946216AbXBPSwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 13:52:54 -0500
Date: Fri, 16 Feb 2007 13:52:52 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tilman Schmidt <tilman@imap.cc>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Move include linux/marker.h from Makefile
Message-ID: <20070216185252.GA18128@Krystal>
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org> <45D483D7.2040609@imap.cc> <20070215144142.0c13580a.akpm@linux-foundation.org> <20070215224656.GB6297@Krystal> <20070215154418.88edfcbc.akpm@linux-foundation.org> <20070216003739.GC9851@Krystal> <20070215172242.ab7a6f1e.akpm@linux-foundation.org> <20070216180513.GC14004@Krystal> <20070216104340.3c6f2eed.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070216104340.3c6f2eed.akpm@linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 13:48:56 up 14 days,  8:56,  3 users,  load average: 1.59, 1.32, 1.30
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@linux-foundation.org) wrote:
> No, that's still crufty.  There's no reason why marker.h needs special
> treatment whereas, say, jiffies.h does not (is there?)
> 
> It is conventional and reasonable to require that any code which uses this
> mechanism must include its header file.
> 

Ok, let's simply revert it then (and update the documentation
accordingly in a following patch).

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- a/Makefile
+++ b/Makefile
@@ -308,9 +308,7 @@ AFLAGS_KERNEL	=
 # Needed to be compatible with the O= option
 LINUXINCLUDE    := -Iinclude \
                    $(if $(KBUILD_SRC),-Iinclude2 -I$(srctree)/include) \
-		   -include include/linux/autoconf.h \
-		   -include \
-		   	$(if $(KBUILD_SRC),$(srctree)/)include/linux/marker.h
+		   -include include/linux/autoconf.h
 
 CPPFLAGS        := -D__KERNEL__ $(LINUXINCLUDE)
 
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Candidate, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
