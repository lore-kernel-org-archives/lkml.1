Return-Path: <linux-kernel-owner+w=401wt.eu-S1754646AbYKVUcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbYKVUcP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 15:32:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751093AbYKVUcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 15:32:00 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:36297 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbYKVUb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 15:31:59 -0500
Date: Sat, 22 Nov 2008 21:33:41 +0100
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: strict_strto* is not strict enough
Message-ID: <20081122203341.GA1895@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It decodes "\n" as 0, which is bad, because stray echo into backlight
will turn your backlight off, etc...

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index a013bbc..87d12a7 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -170,6 +170,8 @@ int strict_strtoul(const char *cp, unsig
 		return -EINVAL;
 
 	val = simple_strtoul(cp, &tail, base);
+	if (tail == cp)
+		return -EINVAL;
 	if ((*tail == '\0') ||
 		((len == (size_t)(tail - cp) + 1) && (*tail == '\n'))) {
 		*res = val;
@@ -241,6 +243,8 @@ int strict_strtoull(const char *cp, unsi
 		return -EINVAL;
 
 	val = simple_strtoull(cp, &tail, base);
+	if (tail == cp)
+		return -EINVAL;
 	if ((*tail == '\0') ||
 		((len == (size_t)(tail - cp) + 1) && (*tail == '\n'))) {
 		*res = val;

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
