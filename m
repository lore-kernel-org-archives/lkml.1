Return-Path: <linux-kernel-owner+w=401wt.eu-S1757451AbYGDGfO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451AbYGDGfO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 02:35:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbYGDGfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 02:35:00 -0400
Received: from mail28.messagelabs.com ([216.82.249.131]:61084 "EHLO
	mail28.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbYGDGe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 02:34:59 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-12.tower-28.messagelabs.com!1215153298!17277768!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.13]
Date: Fri, 4 Jul 2008 08:34:55 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: <linux-kernel@vger.kernel.org>
CC: David Woodhouse <dwmw2@infradead.org>
Subject: alphabetic ordering of MAINTAINERS
Message-ID: <20080704063455.GA13999@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 04 Jul 2008 06:34:55.0566 (UTC) FILETIME=[128AEEE0:01C8DDA0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I wanted to add an entry to MAINTAINERS and while doing it I saw that in
the corresponding region the alphabetic ordering is broken.  Then I
inteded to fix that up for a trivial patch.  Next was to check the rest
of the file and there are so much misorderings that it's not sensible to
choose the trivial path anymore as there are currently 114 entries out
of order[1].

Below is a script that shows the misorderings after applying the
following patch:

diff --git a/MAINTAINERS b/MAINTAINERS
index e6c06fa..e9e36f8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1585,7 +1585,7 @@ S:	Supported
 EMBEDDED LINUX
 P:	Paul Gortmaker
 M:	paul.gortmaker@windriver.com
-P	David Woodhouse
+P:	David Woodhouse
 M:	dwmw2@infradead.org
 L:	linux-embedded@vger.kernel.org
 S:	Maintained

IMHO there are two good ways to continue:
 - just ignore the misorderings; or
 - write a more clever script that not only shows the misorderings but
   fixes them and optimally let Linus directly apply it.

I will try to come up with a script to prepare the second way.

Best regards
Uwe

#! /bin/sh

tempfile="$(mktemp)";

# extract topics from MAINTAINERS
sed -n -e '1,/^P:/d' -e '/^[0-9a-zA-Z][^:]/p' MAINTAINERS >
"${tempfile}"

sort "${tempfile}" | diff -u "${tempfile}" -

rm "${tempfile}"

[1] ukleinek@zentaur:~/gsrc/linux-2.6$ order_maintainers | grep ^- | wc -l
114

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
