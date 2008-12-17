Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759325AbYLQAI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759325AbYLQAI1 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 19:08:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759497AbYLQAGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 19:06:08 -0500
Received: from kroah.org ([198.145.64.141]:41304 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759677AbYLQAGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 19:06:04 -0500
Date: Tue, 16 Dec 2008 16:04:23 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
        Zwane Mwaikambo <zwane@arm.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
        Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
        Chris Wedgwood <reviews@ml.cw.f00f.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Chuck Ebbert <cebbert@redhat.com>,
        Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
        Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
        Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ingo Brueckl <ib@wupperonline.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch 12/22] unicode table for cp437
Message-ID: <20081217000423.GM4504@kroah.com>
References: <20081216235704.347182084@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="unicode-table-for-cp437.patch"
In-Reply-To: <20081217000306.GA4504@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ingo Brueckl <ib@wupperonline.de>

commit f75bc06e5d00a827d3ec5d57bbb5b73a4adec855 upstream.

There is a major bug in the cp437 to unicode translation table.  Char
0x7c is mapped to U+00a5 which is the Yen sign and wrong.  The right
mapping is U+00a6 (broken bar).

Furthermore, a mapping for U+00b4 (a widely used character) is missing
even though easily possible.

The patch fixes these, as well as it provides a few other useful
mappings.

The changes are as follows:

  0x0f (enhancement) enables a sort of currency symbol
  0x27 (bug) enables a sort of acute accent which is a widely used character
  0x44 (enhancement) enables a sort of icelandic capital letter eth
  0x7c (major bug) corrects mapping
  0xeb (enhancement) enables a sort of icelandic small letter eth
  0xee (enhancement) enables a sort of math 'element of'

Signed-off-by: Ingo Brueckl <ib@wupperonline.de>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/cp437.uni |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/char/cp437.uni
+++ b/drivers/char/cp437.uni
@@ -27,7 +27,7 @@
 0x0c	U+2640
 0x0d	U+266a
 0x0e	U+266b
-0x0f	U+263c
+0x0f	U+263c U+00a4
 0x10	U+25b6 U+25ba
 0x11	U+25c0 U+25c4
 0x12	U+2195
@@ -55,7 +55,7 @@
 0x24	U+0024
 0x25	U+0025
 0x26	U+0026
-0x27	U+0027
+0x27	U+0027 U+00b4
 0x28	U+0028
 0x29	U+0029
 0x2a	U+002a
@@ -84,7 +84,7 @@
 0x41	U+0041 U+00c0 U+00c1 U+00c2 U+00c3
 0x42	U+0042
 0x43	U+0043 U+00a9
-0x44	U+0044
+0x44	U+0044 U+00d0
 0x45	U+0045 U+00c8 U+00ca U+00cb
 0x46	U+0046
 0x47	U+0047
@@ -140,7 +140,7 @@
 0x79	U+0079 U+00fd
 0x7a	U+007a
 0x7b	U+007b
-0x7c	U+007c U+00a5
+0x7c	U+007c U+00a6
 0x7d	U+007d
 0x7e	U+007e
 #
@@ -263,10 +263,10 @@
 0xe8	U+03a6 U+00d8
 0xe9	U+0398
 0xea	U+03a9 U+2126
-0xeb	U+03b4
+0xeb	U+03b4 U+00f0
 0xec	U+221e
 0xed	U+03c6 U+00f8
-0xee	U+03b5
+0xee	U+03b5 U+2208
 0xef	U+2229
 0xf0	U+2261
 0xf1	U+00b1

