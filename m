Return-Path: <linux-kernel-owner+w=401wt.eu-S934298AbXEGPSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934298AbXEGPSb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 11:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934204AbXEGPS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 11:18:29 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:61345 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934188AbXEGPS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 11:18:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=lmycZAyvtNNXxjqlDwNpIms/sutxnTuhlWQu67PhPYjLMVNNbon4sKikGuikmuNeeb/pmyeGzGJwCficojYINur/79YDnuJLV3+NDQSjjKlyMUKZwUWPAsUc9KnXwwwwruPDj2eQx9dF/TkK3SgjYzwaUUsDMHAqJMnO/uYZwWA=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] improve scripts/gcc-version.sh output a bit when called without args
Date: Mon, 7 May 2007 17:18:00 +0200
User-Agent: KMail/1.9.6
Cc: jesper.juhl@gmail.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705071718.00334.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, if you call scripts/gcc-version.sh without arguments it will 
generate this output : 

$ sh scripts/gcc-version.sh
scripts/gcc-version.sh: line 17: -E: command not found
scripts/gcc-version.sh: line 18: -E: command not found
0000

Not too pretty. I believe this is an improvement : 

$ sh scripts/gcc-version.sh
Error: No compiler specified.
Usage:
        scripts/gcc-version.sh <gcc-command>

as implemented by the patch below.

Not really important, just something I noticed, cleaned up and generated a 
patch for.
If you like it you can have it. If you hate it just ignore it :)


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
--- 

 scripts/gcc-version.sh |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/scripts/gcc-version.sh b/scripts/gcc-version.sh
index bb4fbea..59a03a4 100644
--- a/scripts/gcc-version.sh
+++ b/scripts/gcc-version.sh
@@ -8,6 +8,12 @@
 
 compiler="$*"
 
+if [ ${#compiler} -eq 0 ]; then
+	echo "Error: No compiler specified."
+	echo -e "Usage:\n\t$0 <gcc-command>"
+	exit 1
+fi
+
 MAJOR=$(echo __GNUC__ | $compiler -E -xc - | tail -n 1)
 MINOR=$(echo __GNUC_MINOR__ | $compiler -E -xc - | tail -n 1)
 printf "%02d%02d\\n" $MAJOR $MINOR


