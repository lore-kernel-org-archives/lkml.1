Return-Path: <linux-kernel-owner+w=401wt.eu-S1760840AbZLKEgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760840AbZLKEgR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:36:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932326AbZLKEgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:36:14 -0500
Received: from kroah.org ([198.145.64.141]:52842 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756158AbZLKEfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:35:34 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:27:25 2009
Message-Id: <20091211042725.199040442@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:24:40 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Sesterhenn <eric.sesterhenn@lsexperts.de>,
       "Theodore Tso" <tytso@mit.edu>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [02/90] ext4: Avoid null pointer dereference when decoding EROFS w/o a journal
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0002-ext4-Avoid-null-pointer-dereference-when-decoding-ER.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
(cherry picked from commit 78f1ddbb498283c2445c11b0dfa666424c301803)

We need to check to make sure a journal is present before checking the
journal flags in ext4_decode_error().

Signed-off-by: Eric Sesterhenn <eric.sesterhenn@lsexperts.de>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/super.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -344,7 +344,8 @@ static const char *ext4_decode_error(str
 		errstr = "Out of memory";
 		break;
 	case -EROFS:
-		if (!sb || EXT4_SB(sb)->s_journal->j_flags & JBD2_ABORT)
+		if (!sb || (EXT4_SB(sb)->s_journal &&
+			    EXT4_SB(sb)->s_journal->j_flags & JBD2_ABORT))
 			errstr = "Journal has aborted";
 		else
 			errstr = "Readonly filesystem";


