Return-Path: <linux-kernel-owner+w=401wt.eu-S1752202AbZKOHOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202AbZKOHOf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 02:14:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbZKOHOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 02:14:32 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:63185 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbZKOHOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 02:14:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=A5S5qrq+36JwqcvDXS71iQwXDXQhJY8LThO5FJCx7jeBDYjuAZCzbB9d3tLTYrXkON
         LxrelNjPhLDSOMqFNlYUb8Lb4QXmywpQIgSUpvwojdk15dgXAuLA8YbFNissve1XeTiU
         5psqE34TMNcOMDpi3PjXRkavZSxivRX4ozz/4=
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
To: "linux list" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
Cc: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Subject: [PATCH v5 11/12] string: on strstrip(), first remove leading spaces before running over str
Date: Sat, 14 Nov 2009 05:11:59 -0200
Message-Id: <e77df9e76d27b3affad4cb1a9aef619dce09f1d4.1258181837.git.andre.goddard@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e.dirty
In-Reply-To: <cover.1258181836.git.andre.goddard@gmail.com>
References: <cover.1258181836.git.andre.goddard@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... so that strlen() iterates over a smaller string comprising of the
remaining characters only.

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
---
 lib/string.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/string.c b/lib/string.c
index 087d33b..c31d0f4 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -356,8 +356,8 @@ char *strstrip(char *s)
 	size_t size;
 	char *end;
 
+	s = skip_spaces(s);
 	size = strlen(s);
-
 	if (!size)
 		return s;
 
@@ -366,7 +366,7 @@ char *strstrip(char *s)
 		end--;
 	*(end + 1) = '\0';
 
-	return skip_spaces(s);
+	return s;
 }
 EXPORT_SYMBOL(strstrip);
 
-- 
1.6.5.2.180.gc5b3e.dirty

