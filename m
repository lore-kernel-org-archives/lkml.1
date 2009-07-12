Return-Path: <linux-kernel-owner+w=401wt.eu-S1753302AbZGLXjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbZGLXjn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 19:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751671AbZGLXjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 19:39:35 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:32907 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbZGLXje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 19:39:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=OQq6i0ysi3jQp1eNRp1/nK3t9ZzaDx55MN4hHpYIP5Z0fH9r/erLfRXSiEdAH13lue
         /+7RNVDHYBd2Mt7PTqrnKl3ZmWmgaI0uOpW9u3uY3g68hfuocuMp9r8SIm7wpBtG4lvs
         Bgo7d/3xU7/F2oV7Zj4RVZMzinh/VN0ChJFps=
Message-ID: <4A5A748D.1000109@gmail.com>
Date: Mon, 13 Jul 2009 01:41:01 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] hvsi: Keep index within state_names[]
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keep index within state_names[]

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/char/hvsi.c b/drivers/char/hvsi.c
index 2989056..05dd854 100644
--- a/drivers/char/hvsi.c
+++ b/drivers/char/hvsi.c
@@ -196,7 +196,7 @@ static inline void print_state(struct hvsi_struct *hp)
 	};
 	const char *name = state_names[hp->state];
 
-	if (hp->state > ARRAY_SIZE(state_names))
+	if (hp->state >= ARRAY_SIZE(state_names))
 		name = "UNKNOWN";
 
 	pr_debug("hvsi%i: state = %s\n", hp->index, name);
