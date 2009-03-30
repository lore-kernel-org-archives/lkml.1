Return-Path: <linux-kernel-owner+w=401wt.eu-S1762291AbZC3WL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762291AbZC3WL2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 18:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757173AbZC3WLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 18:11:15 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:56233 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982AbZC3WLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 18:11:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:reply-to:mime-version
         :content-type:content-disposition:x-pgp-key:user-agent;
        b=G+SHHgNe8XIiz0gzBfD7pZntVucgmKJV2QSlbZmqG3f3T5hCGrDW97kzqOfar/dScF
         PQOchirkha28FNNcgRZWEYI9SQj0gU15g2XjT/KQMlkk5zVp981lj/8uymfaG0wQGjnn
         wm15ZaYZkEb8Tkgi1HSpXC7wwkEJumiGPHv6Q=
Date: Tue, 31 Mar 2009 00:11:04 +0200
From: Michal Januszewski <spock@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fbdev-devel@lists.sourceforge.net
Subject: [PATCH] s3fb: fix color component length for pseudocolor modes
Message-ID: <20090330221104.GD6993@spock.one.pl>
Reply-To: spock@gentoo.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-PGP-Key: http://dev.gentoo.org/~spock/spock.gpg
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s3fb incorrectly sets the length of the color fields to 6 bits
for PSEUDOCOLOR modes, even though 8 or 4 bits are used per pixel.
Fix this by setting the length to 8 or 4, respectively.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
---
diff --git a/drivers/video/s3fb.c b/drivers/video/s3fb.c
index 4dcec48..c3fad34 100644
--- a/drivers/video/s3fb.c
+++ b/drivers/video/s3fb.c
@@ -45,11 +45,11 @@ struct s3fb_info {
 static const struct svga_fb_format s3fb_formats[] = {
 	{ 0,  {0, 6, 0},  {0, 6, 0},  {0, 6, 0}, {0, 0, 0}, 0,
 		FB_TYPE_TEXT, FB_AUX_TEXT_SVGA_STEP4,	FB_VISUAL_PSEUDOCOLOR, 8, 16},
-	{ 4,  {0, 6, 0},  {0, 6, 0},  {0, 6, 0}, {0, 0, 0}, 0,
+	{ 4,  {0, 4, 0},  {0, 4, 0},  {0, 4, 0}, {0, 0, 0}, 0,
 		FB_TYPE_PACKED_PIXELS, 0,		FB_VISUAL_PSEUDOCOLOR, 8, 16},
-	{ 4,  {0, 6, 0},  {0, 6, 0},  {0, 6, 0}, {0, 0, 0}, 1,
+	{ 4,  {0, 4, 0},  {0, 4, 0},  {0, 4, 0}, {0, 0, 0}, 1,
 		FB_TYPE_INTERLEAVED_PLANES, 1,		FB_VISUAL_PSEUDOCOLOR, 8, 16},
-	{ 8,  {0, 6, 0},  {0, 6, 0},  {0, 6, 0}, {0, 0, 0}, 0,
+	{ 8,  {0, 8, 0},  {0, 8, 0},  {0, 8, 0}, {0, 0, 0}, 0,
 		FB_TYPE_PACKED_PIXELS, 0,		FB_VISUAL_PSEUDOCOLOR, 4, 8},
 	{16,  {10, 5, 0}, {5, 5, 0},  {0, 5, 0}, {0, 0, 0}, 0,
 		FB_TYPE_PACKED_PIXELS, 0,		FB_VISUAL_TRUECOLOR, 2, 4},


