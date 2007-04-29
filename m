Return-Path: <linux-kernel-owner+w=401wt.eu-S1755330AbXD2OK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbXD2OK5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 10:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756492AbXD2OK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 10:10:56 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:48186 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755330AbXD2OKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 10:10:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=NQciCy4G/0OkYqb7vY25d6UxF2rPYTJ3jG+sUHbkwzXm8iBLNjW8w5bxd3U8w8/D0QPvQWnuFH4B3rYlxsYknCyDlLv9bDhaaA3fBhupz1x6EwshHUjMKtAmxoEXuuFABUVCrIUGq6NzBL0ybnboAcn63wX+3VYchLqO4TB2xUU=
Subject: Re: [PATCH] [37/48] i386: ignore vgacon if hardware not present
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Andi Kleen <ak@suse.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200704291524.54080.ak@suse.de>
References: <200704291252.514680000@suse.de>
	 <20070429105327.2ECA6151C5@wotan.suse.de> <1177849070.17715.0.camel@daplas>
	 <200704291524.54080.ak@suse.de>
Content-Type: text/plain
Date: Sun, 29 Apr 2007 22:10:38 +0800
Message-Id: <1177855838.17715.18.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-29 at 15:24 +0200, Andi Kleen wrote:
> > The subject does not reflect the content of the patch :-). And I believe
> > ignore-vgacon-if-hardware-not-present is already in mainline.
> 
> Patch dropped thanks

Note that this is the patch which have the above title. So I don't know
if you have to drop the patch or just change the title to an appropriate
one.

Tony

The patch titled
     ignore vgacon if hardware not present
has been removed from the -mm tree.  Its filename was
     ignore-vgacon-if-hardware-not-present.patch

This patch was dropped because it was merged into mainline or a
subsystem tree

------------------------------------------------------
Subject: ignore vgacon if hardware not present
From: Gerd Hoffmann <kraxel@suse.de>

Avoid trying to set up vgacon if there's no vga hardware present.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Alan <alan@lxorguk.ukuu.org.uk>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/vgacon.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN
drivers/video/console/vgacon.c~ignore-vgacon-if-hardware-not-present
drivers/video/console/vgacon.c
---
a/drivers/video/console/vgacon.c~ignore-vgacon-if-hardware-not-present
+++ a/drivers/video/console/vgacon.c
@@ -371,7 +371,8 @@ static const char *vgacon_startup(void)
        }
 
        /* VGA16 modes are not handled by VGACON */
-       if ((ORIG_VIDEO_MODE == 0x0D) ||        /* 320x200/4 */
+       if ((ORIG_VIDEO_MODE == 0x00) ||        /* SCREEN_INFO not
initialized */
+           (ORIG_VIDEO_MODE == 0x0D) ||        /* 320x200/4 */
            (ORIG_VIDEO_MODE == 0x0E) ||        /* 640x200/4 */
            (ORIG_VIDEO_MODE == 0x10) ||        /* 640x350/4 */
            (ORIG_VIDEO_MODE == 0x12) ||        /* 640x480/4 */
> -Andi

