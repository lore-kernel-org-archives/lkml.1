Return-Path: <linux-kernel-owner+w=401wt.eu-S1758441AbYLCUVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758441AbYLCUVt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:21:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755470AbYLCT5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:57:40 -0500
Received: from kroah.org ([198.145.64.141]:56532 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754460AbYLCT5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:57:39 -0500
Date: Wed, 3 Dec 2008 11:56:02 -0800
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
       Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@us.ibm.com>,
       Suresh Jayaraman <sjayaraman@suse.de>
Subject: [patch 078/104] cifs: fix check for dead tcon in smb_init
Message-ID: <20081203195602.GA8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="cifs-fix-check-for-dead-tcon-in-smb_init.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Steve French <sfrench@us.ibm.com>

commit bfb59820ee46616a7bdb4af6b8f7e109646de6ec upstream

This was recently changed to check for need_reconnect, but should
actually be a check for a tidStatus of CifsExiting.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Cc: Suresh Jayaraman <sjayaraman@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 fs/cifs/cifssmb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -295,7 +295,7 @@ smb_init(int smb_command, int wct, struc
 	   check for tcp and smb session status done differently
 	   for those three - in the calling routine */
 	if (tcon) {
-		if (tcon->need_reconnect) {
+		if (tcon->tidStatus == CifsExiting) {
 			/* only tree disconnect, open, and write,
 			  (and ulogoff which does not have tcon)
 			  are allowed as we start force umount */

