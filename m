Return-Path: <linux-kernel-owner+w=401wt.eu-S932751AbYCUXOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932751AbYCUXOk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 19:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763290AbYCUWxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:53:18 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:41358 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763390AbYCUWxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:53:16 -0400
Message-Id: <20080321224436.781154937@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:43:49 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, torvalds@osdl.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Samuel Thibault <samuel.thibault@ens-lyon.org>,
       Tony Breeds <tony@bakeyournoodle.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 59/76] Fix default compose table initialization
Content-Disposition: inline; filename=fix-default-compose-table-initialization.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Samuel Thibault <samuel.thibault@ens-lyon.org>

Oddly enough, unsigned int c = '\300'; puts a "negative" value in c, not
0300...  This fixes the default unicode compose table by using integers
instead of character constants.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Fold in upstream commit 10a7f3135ac4937a3dc8ed11614a2b70cbd44728 (Build
fix for drivers/s390/char/defkeymap.c) from Tony Breeds.

Commit 5ce2087ed0eb424e0889bdc9102727f65d2ecdde (Fix default compose
table initialization) left a trailing quote.

  CC      drivers/s390/char/defkeymap.o
drivers/s390/char/defkeymap.c:155: error: missing terminating ' character
drivers/s390/char/defkeymap.c:156: error: syntax error before ';' token
make[3]: *** [drivers/s390/char/defkeymap.o] Error 1

Fix that.

Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/acorn/char/defkeymap-l7200.c |   68 +++++++++++++++++------------------
 drivers/char/defkeymap.c_shipped     |   68 +++++++++++++++++------------------
 drivers/s390/char/defkeymap.c        |    4 +-
 3 files changed, 70 insertions(+), 70 deletions(-)

--- a/drivers/acorn/char/defkeymap-l7200.c
+++ b/drivers/acorn/char/defkeymap-l7200.c
@@ -347,40 +347,40 @@ char *func_table[MAX_NR_FUNC] = {
 };
 
 struct kbdiacruc accent_table[MAX_DIACR] = {
-	{'`', 'A', '\300'},	{'`', 'a', '\340'},
-	{'\'', 'A', '\301'},	{'\'', 'a', '\341'},
-	{'^', 'A', '\302'},	{'^', 'a', '\342'},
-	{'~', 'A', '\303'},	{'~', 'a', '\343'},
-	{'"', 'A', '\304'},	{'"', 'a', '\344'},
-	{'O', 'A', '\305'},	{'o', 'a', '\345'},
-	{'0', 'A', '\305'},	{'0', 'a', '\345'},
-	{'A', 'A', '\305'},	{'a', 'a', '\345'},
-	{'A', 'E', '\306'},	{'a', 'e', '\346'},
-	{',', 'C', '\307'},	{',', 'c', '\347'},
-	{'`', 'E', '\310'},	{'`', 'e', '\350'},
-	{'\'', 'E', '\311'},	{'\'', 'e', '\351'},
-	{'^', 'E', '\312'},	{'^', 'e', '\352'},
-	{'"', 'E', '\313'},	{'"', 'e', '\353'},
-	{'`', 'I', '\314'},	{'`', 'i', '\354'},
-	{'\'', 'I', '\315'},	{'\'', 'i', '\355'},
-	{'^', 'I', '\316'},	{'^', 'i', '\356'},
-	{'"', 'I', '\317'},	{'"', 'i', '\357'},
-	{'-', 'D', '\320'},	{'-', 'd', '\360'},
-	{'~', 'N', '\321'},	{'~', 'n', '\361'},
-	{'`', 'O', '\322'},	{'`', 'o', '\362'},
-	{'\'', 'O', '\323'},	{'\'', 'o', '\363'},
-	{'^', 'O', '\324'},	{'^', 'o', '\364'},
-	{'~', 'O', '\325'},	{'~', 'o', '\365'},
-	{'"', 'O', '\326'},	{'"', 'o', '\366'},
-	{'/', 'O', '\330'},	{'/', 'o', '\370'},
-	{'`', 'U', '\331'},	{'`', 'u', '\371'},
-	{'\'', 'U', '\332'},	{'\'', 'u', '\372'},
-	{'^', 'U', '\333'},	{'^', 'u', '\373'},
-	{'"', 'U', '\334'},	{'"', 'u', '\374'},
-	{'\'', 'Y', '\335'},	{'\'', 'y', '\375'},
-	{'T', 'H', '\336'},	{'t', 'h', '\376'},
-	{'s', 's', '\337'},	{'"', 'y', '\377'},
-	{'s', 'z', '\337'},	{'i', 'j', '\377'},
+	{'`', 'A', 0300},	{'`', 'a', 0340},
+	{'\'', 'A', 0301},	{'\'', 'a', 0341},
+	{'^', 'A', 0302},	{'^', 'a', 0342},
+	{'~', 'A', 0303},	{'~', 'a', 0343},
+	{'"', 'A', 0304},	{'"', 'a', 0344},
+	{'O', 'A', 0305},	{'o', 'a', 0345},
+	{'0', 'A', 0305},	{'0', 'a', 0345},
+	{'A', 'A', 0305},	{'a', 'a', 0345},
+	{'A', 'E', 0306},	{'a', 'e', 0346},
+	{',', 'C', 0307},	{',', 'c', 0347},
+	{'`', 'E', 0310},	{'`', 'e', 0350},
+	{'\'', 'E', 0311},	{'\'', 'e', 0351},
+	{'^', 'E', 0312},	{'^', 'e', 0352},
+	{'"', 'E', 0313},	{'"', 'e', 0353},
+	{'`', 'I', 0314},	{'`', 'i', 0354},
+	{'\'', 'I', 0315},	{'\'', 'i', 0355},
+	{'^', 'I', 0316},	{'^', 'i', 0356},
+	{'"', 'I', 0317},	{'"', 'i', 0357},
+	{'-', 'D', 0320},	{'-', 'd', 0360},
+	{'~', 'N', 0321},	{'~', 'n', 0361},
+	{'`', 'O', 0322},	{'`', 'o', 0362},
+	{'\'', 'O', 0323},	{'\'', 'o', 0363},
+	{'^', 'O', 0324},	{'^', 'o', 0364},
+	{'~', 'O', 0325},	{'~', 'o', 0365},
+	{'"', 'O', 0326},	{'"', 'o', 0366},
+	{'/', 'O', 0330},	{'/', 'o', 0370},
+	{'`', 'U', 0331},	{'`', 'u', 0371},
+	{'\'', 'U', 0332},	{'\'', 'u', 0372},
+	{'^', 'U', 0333},	{'^', 'u', 0373},
+	{'"', 'U', 0334},	{'"', 'u', 0374},
+	{'\'', 'Y', 0335},	{'\'', 'y', 0375},
+	{'T', 'H', 0336},	{'t', 'h', 0376},
+	{'s', 's', 0337},	{'"', 'y', 0377},
+	{'s', 'z', 0337},	{'i', 'j', 0377},
 };
 
 unsigned int accent_table_size = 68;
--- a/drivers/char/defkeymap.c_shipped
+++ b/drivers/char/defkeymap.c_shipped
@@ -223,40 +223,40 @@ char *func_table[MAX_NR_FUNC] = {
 };
 
 struct kbdiacruc accent_table[MAX_DIACR] = {
-	{'`', 'A', '\300'},	{'`', 'a', '\340'},
-	{'\'', 'A', '\301'},	{'\'', 'a', '\341'},
-	{'^', 'A', '\302'},	{'^', 'a', '\342'},
-	{'~', 'A', '\303'},	{'~', 'a', '\343'},
-	{'"', 'A', '\304'},	{'"', 'a', '\344'},
-	{'O', 'A', '\305'},	{'o', 'a', '\345'},
-	{'0', 'A', '\305'},	{'0', 'a', '\345'},
-	{'A', 'A', '\305'},	{'a', 'a', '\345'},
-	{'A', 'E', '\306'},	{'a', 'e', '\346'},
-	{',', 'C', '\307'},	{',', 'c', '\347'},
-	{'`', 'E', '\310'},	{'`', 'e', '\350'},
-	{'\'', 'E', '\311'},	{'\'', 'e', '\351'},
-	{'^', 'E', '\312'},	{'^', 'e', '\352'},
-	{'"', 'E', '\313'},	{'"', 'e', '\353'},
-	{'`', 'I', '\314'},	{'`', 'i', '\354'},
-	{'\'', 'I', '\315'},	{'\'', 'i', '\355'},
-	{'^', 'I', '\316'},	{'^', 'i', '\356'},
-	{'"', 'I', '\317'},	{'"', 'i', '\357'},
-	{'-', 'D', '\320'},	{'-', 'd', '\360'},
-	{'~', 'N', '\321'},	{'~', 'n', '\361'},
-	{'`', 'O', '\322'},	{'`', 'o', '\362'},
-	{'\'', 'O', '\323'},	{'\'', 'o', '\363'},
-	{'^', 'O', '\324'},	{'^', 'o', '\364'},
-	{'~', 'O', '\325'},	{'~', 'o', '\365'},
-	{'"', 'O', '\326'},	{'"', 'o', '\366'},
-	{'/', 'O', '\330'},	{'/', 'o', '\370'},
-	{'`', 'U', '\331'},	{'`', 'u', '\371'},
-	{'\'', 'U', '\332'},	{'\'', 'u', '\372'},
-	{'^', 'U', '\333'},	{'^', 'u', '\373'},
-	{'"', 'U', '\334'},	{'"', 'u', '\374'},
-	{'\'', 'Y', '\335'},	{'\'', 'y', '\375'},
-	{'T', 'H', '\336'},	{'t', 'h', '\376'},
-	{'s', 's', '\337'},	{'"', 'y', '\377'},
-	{'s', 'z', '\337'},	{'i', 'j', '\377'},
+	{'`', 'A', 0300},	{'`', 'a', 0340},
+	{'\'', 'A', 0301},	{'\'', 'a', 0341},
+	{'^', 'A', 0302},	{'^', 'a', 0342},
+	{'~', 'A', 0303},	{'~', 'a', 0343},
+	{'"', 'A', 0304},	{'"', 'a', 0344},
+	{'O', 'A', 0305},	{'o', 'a', 0345},
+	{'0', 'A', 0305},	{'0', 'a', 0345},
+	{'A', 'A', 0305},	{'a', 'a', 0345},
+	{'A', 'E', 0306},	{'a', 'e', 0346},
+	{',', 'C', 0307},	{',', 'c', 0347},
+	{'`', 'E', 0310},	{'`', 'e', 0350},
+	{'\'', 'E', 0311},	{'\'', 'e', 0351},
+	{'^', 'E', 0312},	{'^', 'e', 0352},
+	{'"', 'E', 0313},	{'"', 'e', 0353},
+	{'`', 'I', 0314},	{'`', 'i', 0354},
+	{'\'', 'I', 0315},	{'\'', 'i', 0355},
+	{'^', 'I', 0316},	{'^', 'i', 0356},
+	{'"', 'I', 0317},	{'"', 'i', 0357},
+	{'-', 'D', 0320},	{'-', 'd', 0360},
+	{'~', 'N', 0321},	{'~', 'n', 0361},
+	{'`', 'O', 0322},	{'`', 'o', 0362},
+	{'\'', 'O', 0323},	{'\'', 'o', 0363},
+	{'^', 'O', 0324},	{'^', 'o', 0364},
+	{'~', 'O', 0325},	{'~', 'o', 0365},
+	{'"', 'O', 0326},	{'"', 'o', 0366},
+	{'/', 'O', 0330},	{'/', 'o', 0370},
+	{'`', 'U', 0331},	{'`', 'u', 0371},
+	{'\'', 'U', 0332},	{'\'', 'u', 0372},
+	{'^', 'U', 0333},	{'^', 'u', 0373},
+	{'"', 'U', 0334},	{'"', 'u', 0374},
+	{'\'', 'Y', 0335},	{'\'', 'y', 0375},
+	{'T', 'H', 0336},	{'t', 'h', 0376},
+	{'s', 's', 0337},	{'"', 'y', 0377},
+	{'s', 'z', 0337},	{'i', 'j', 0377},
 };
 
 unsigned int accent_table_size = 68;
--- a/drivers/s390/char/defkeymap.c
+++ b/drivers/s390/char/defkeymap.c
@@ -151,8 +151,8 @@ char *func_table[MAX_NR_FUNC] = {
 };
 
 struct kbdiacruc accent_table[MAX_DIACR] = {
-	{'^', 'c', '\003'},	{'^', 'd', '\004'},
-	{'^', 'z', '\032'},	{'^', '\012', '\000'},
+	{'^', 'c', 0003},	{'^', 'd', 0004},
+	{'^', 'z', 0032},	{'^', 0012, 0000},
 };
 
 unsigned int accent_table_size = 4;

-- 
