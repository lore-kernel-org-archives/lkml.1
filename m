Return-Path: <linux-kernel-owner+w=401wt.eu-S1761096AbZENWvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761096AbZENWvV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 18:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756798AbZENWmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 18:42:37 -0400
Received: from kroah.org ([198.145.64.141]:52454 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756446AbZENWmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 18:42:19 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu May 14 15:35:24 2009
Message-Id: <20090514223524.705172355@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 May 2009 15:33:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Steve French <smfrench@gmail.com>,
       Jeff Layton <jlayton@redhat.com>, Suresh Jayaraman <sjayaraman@suse.de>,
       Steve French <sfrench@us.ibm.com>
Subject: [patch 27/51] cifs: Fix buffer size in cifs_convertUCSpath
References: <20090514223235.348540705@mini.kroah.org>
Content-Disposition: inline; filename=cifs-fix-buffer-size-in-cifs_convertucspath.patch
In-Reply-To: <20090514223755.GA27019@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Suresh Jayaraman <sjayaraman@suse.de>

Relevant commits 7fabf0c9479fef9fdb9528a5fbdb1cb744a744a4 and
f58841666bc22e827ca0dcef7b71c7bc2758ce82. The upstream commits adds
cifs_from_ucs2 that includes functionality of cifs_convertUCSpath and
does cleanup.

Reported-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>
Acked-by: Steve French <sfrench@us.ibm.com>
Acked-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/misc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -691,14 +691,15 @@ cifs_convertUCSpath(char *target, const 
 						NLS_MAX_CHARSET_SIZE);
 				if (len > 0) {
 					j += len;
-					continue;
+					goto overrun_chk;
 				} else {
 					target[j] = '?';
 				}
 		}
 		j++;
 		/* make sure we do not overrun callers allocated temp buffer */
-		if (j >= (2 * NAME_MAX))
+overrun_chk:
+		if (j >= UNICODE_NAME_MAX)
 			break;
 	}
 cUCS_out:


