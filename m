Return-Path: <linux-kernel-owner+w=401wt.eu-S1757410AbZKCBte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410AbZKCBte (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 20:49:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756433AbZKCBtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 20:49:33 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:58956 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755277AbZKCBtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 20:49:33 -0500
Date: Tue, 03 Nov 2009 10:49:32 +0900 (JST)
Message-Id: <20091103.104932.625281420231629894.mitake@dcl.info.waseda.ac.jp>
To: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: [PATCH][RFC] Removing wrong judgement of checkpatch.pl for return
 as function
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I found a strange behaviour of checkpatch.pl.

The C statement:
	return (type)value;
is regarded as return like a function form by checkpatch.pl.
So checkpatch.pl causes "Return is not a function." error
when processing statements like this.

I think statements like above are innocence. These are only doing type cast.
This patch removes the behaviour of checkpatch.pl.

But I don't have confidence about coding style of Linux kernel.
Is my thought correct? Or the behaviour of current checkpatch.pl is correct?
Request for comment.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>

---
 scripts/checkpatch.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index bc4114f..04a876c 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2117,7 +2117,7 @@ sub process {
 		}
 
 # Return is not a function.
-		if (defined($stat) && $stat =~ /^.\s*return(\s*)(\(.*);/s) {
+		if (defined($stat) && $stat =~ /^.\s*return(\s*)(\(.*)\);/s) {
 			my $spacing = $1;
 			my $value = $2;
 
-- 
1.5.6.5

