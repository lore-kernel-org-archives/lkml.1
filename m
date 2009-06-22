Return-Path: <linux-kernel-owner+w=401wt.eu-S1752928AbZFVQx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928AbZFVQx2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 12:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbZFVQxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 12:53:20 -0400
Received: from india601.server4you.de ([85.25.151.105]:58356 "EHLO
	india601.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbZFVQxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 12:53:20 -0400
X-Greylist: delayed 646 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Jun 2009 12:53:20 EDT
Message-ID: <4A3FB479.2090902@lsrfire.ath.cx>
Date: Mon, 22 Jun 2009 18:42:33 +0200
From: =?ISO-8859-1?Q?Ren=E9_Scharfe?= <rene.scharfe@lsrfire.ath.cx>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: roel kluin <roel.kluin@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, git@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Junio C Hamano <gitster@pobox.com>
Subject: [PATCH] fread does not return negative on error
References: <4A3FB09D.9050903@gmail.com> <20090622153431.GA18466@elte.hu> <25e057c00906220847t15425f38maf486c291d1d2468@mail.gmail.com>
In-Reply-To: <25e057c00906220847t15425f38maf486c291d1d2468@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the following patch is for git.  I just removed the unneeded check for
res == 0 from your version.  Does it look OK?

Thanks,
René

--- snip! ---
From: Roel Kluin <roel.kluin@gmail.com>

size_t res cannot be less than 0. fread returns 0 on error.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 strbuf.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/strbuf.c b/strbuf.c
index a884960..f03d117 100644
--- a/strbuf.c
+++ b/strbuf.c
@@ -260,7 +260,7 @@ size_t strbuf_fread(struct strbuf *sb, size_t size, FILE *f)
 	res = fread(sb->buf + sb->len, 1, size, f);
 	if (res > 0)
 		strbuf_setlen(sb, sb->len + res);
-	else if (res < 0 && oldalloc == 0)
+	else if (oldalloc == 0)
 		strbuf_release(sb);
 	return res;
 }
