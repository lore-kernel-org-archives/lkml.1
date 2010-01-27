Return-Path: <linux-kernel-owner+w=401wt.eu-S1754182Ab0A0Scw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab0A0Scw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 13:32:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753344Ab0A0Scv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 13:32:51 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:36963 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898Ab0A0Scu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 13:32:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=pfn6cMeJeH9flmnVJamf3nSyM0Oky9O4EzGLR98jIr59W0xsWnGjNkbwpKCpfuEKQ+
         uanIDYOHVR135pfTv0XFN6szu+/LVDBto2I0v80heizK+5Pf1dJRKZuAgSJZnAXJuTQj
         I6hcmGDOQRQnvBHB6n0xtOeUjHba/lNvCsg9Q=
Subject: [RFC] checkpatch.pl: warn if an adding line introduce spaces
 before tabs.
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@canonical.com>, Daniel Walker <dwalker@fifo99.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Jan 2010 19:32:44 +0100
Message-ID: <1264617164.2463.181.camel@realization>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This apply to the linux-next tree.

It is a useful thing to warn.

Signed-off-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>
---
 scripts/checkpatch.pl |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index bc4114f..ab18a11 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1411,6 +1411,12 @@ sub process {
 			ERROR("code indent should use tabs where possible\n" . $herevet);
 		}
 
+# check for space before tabs.
+		if ($rawline =~ /^\+/ && $rawline =~ / \t/) {
+			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
+			WARN("please, no space before tabs\n" . $herevet);
+		}
+
 # check we are in a valid C source file if not then ignore this hunk
 		next if ($realfile !~ /\.(h|c)$/);
 
-- 
1.6.3.3



