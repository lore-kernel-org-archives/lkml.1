Return-Path: <linux-kernel-owner+w=401wt.eu-S1759142AbXEXIXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759142AbXEXIXQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 04:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756132AbXEXIXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 04:23:05 -0400
Received: from chiark.greenend.org.uk ([193.201.200.170]:37504 "EHLO
	chiark.greenend.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755150AbXEXIXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 04:23:03 -0400
X-Greylist: delayed 1413 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 May 2007 04:23:03 EDT
From: Colin Watson <cjwatson@debian.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] kernel-doc: fix leading dot in man-mode output
In-Reply-To: <20070523205940.5bc4fdb2.randy.dunlap@oracle.com>
Organization: riva.ucam.org
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1Hr8EK-0003Zp-00@chiark.greenend.org.uk>
Date: Thu, 24 May 2007 08:59:28 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In article <20070523205940.5bc4fdb2.randy.dunlap@oracle.com>, you wrote:
>From: Randy Dunlap <randy.dunlap@oracle.com>
>
>If a parameter description begins with a '.', this indicates a
>"request" for "man" mode output (*roff), so it needs special
>handling.
>
>Problem case is in include/asm-i386/atomic.h for function
>atomic_add_unless():
> * @u: ...unless v is equal to u.
>This parameter description is currently not printed in man mode output.
>
>Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>---
> scripts/kernel-doc |    9 +++++++--
> 1 file changed, 7 insertions(+), 2 deletions(-)
>
>--- linux-2.6.21-rc2-git4.orig/scripts/kernel-doc
>+++ linux-2.6.21-rc2-git4/scripts/kernel-doc
>@@ -384,8 +384,13 @@ sub output_highlight {
>       if ($line eq ""){
> 	    print $lineprefix, $blankline;
> 	} else {
>-            $line =~ s/\\\\\\/\&/g;
>-	    print $lineprefix, $line;
>+	    $line =~ s/\\\\\\/\&/g;
>+	    if ($output_mode eq "man" && substr($line, 0, 1) eq ".") {
>+		print "\\{$line";

This is a very unusual way to escape leading "." in *roff, and I'm not
entirely sure the result is defined given that \{ is normally supposed
to be paired with \} and used to construct blocks. The more conventional
method would be:

  print "\\&$line";

(\& is a zero-width space.)

-- 
Colin Watson (Debian groff maintainer)             [cjwatson@debian.org]
