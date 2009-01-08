Return-Path: <linux-kernel-owner+w=401wt.eu-S1758540AbZAHEEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758540AbZAHEEB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 23:04:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbZAHEDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 23:03:51 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59723 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905AbZAHEDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 23:03:50 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org
Subject: kbuild vs ccache
X-Fcc: ~/Mail/linus
X-Zippy-Says: I'm also pre-POURED pre-MEDITATED and pre-RAPHAELITE!!
Message-Id: <20090108040336.28B10FC3E0@magilla.sf.frob.com>
Date: Wed,  7 Jan 2009 20:03:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


make clean; ccache -s > before-`git describe`; make -j9; ccache -s > after-`git describe`; diff -u {before,after}-`git describe`

v2.6.28:

-cache hit                         737661
-cache miss                        979624
-called for link                    78268
+cache hit                         738093		= +432
+cache miss                        980524		= +900
+called for link                    78289		= +21
 multiple source files                373
 compile failed                      5679
 preprocessor error                  1594
-not a C/C++ file                   44512
+not a C/C++ file                   44549		= +37

1332	cacheable
58	uncacheable


v2.6.28-7485-g9e42d0c:

-cache hit                         738096		= +9
+cache hit                         738105
 cache miss                        980524		= +0
-called for link                    78293
+called for link                    79659		= +1366
 multiple source files                373
 compile failed                      5679
 preprocessor error                  1594
-not a C/C++ file                   44549		= +1384
+not a C/C++ file                   45933

9	cacheable
2750	uncacheable


What changed?


Thanks,
Roland
