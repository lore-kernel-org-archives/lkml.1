Return-Path: <linux-kernel-owner+w=401wt.eu-S1761590AbYEVWp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761590AbYEVWp1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 18:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752259AbYEVWpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 18:45:11 -0400
Received: from rn-out-0910.google.com ([64.233.170.185]:39533 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbYEVWpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 18:45:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=xBgLnmyxkNFmIFFDK2Sh9I91u/J2vfZQXrfKp+Mp6GIMVbyvqZ3ZDri2Ai2bXM0zFW5Wo2WV8XSkVwUtJr7PR8BfVYBt+jY0Ii4OrtgYGLYBjj+49cz1jGfO/iMHGfaJd7IlRUdKGMvqukT2et/gQq0/qlWG3BmE+nJkCdMU/p0=
Subject: [PATCH 1/5] x86: fix integer as NULL pointer warning
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 22 May 2008 15:45:06 -0700
Message-Id: <1211496306.6888.8.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/x86/boot/printf.c:59:10: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/boot/printf.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/boot/printf.c b/arch/x86/boot/printf.c
index c1d00c0..50e47cd 100644
--- a/arch/x86/boot/printf.c
+++ b/arch/x86/boot/printf.c
@@ -56,7 +56,7 @@ static char *number(char *str, long num, int base, int size, int precision,
 	if (type & LEFT)
 		type &= ~ZEROPAD;
 	if (base < 2 || base > 36)
-		return 0;
+		return NULL;
 	c = (type & ZEROPAD) ? '0' : ' ';
 	sign = 0;
 	if (type & SIGN) {
-- 
1.5.5.1.579.g4e43


