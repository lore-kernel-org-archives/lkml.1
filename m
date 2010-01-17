Return-Path: <linux-kernel-owner+w=401wt.eu-S1753342Ab0AQNhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342Ab0AQNhV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 08:37:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752267Ab0AQNhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 08:37:20 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:56599 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245Ab0AQNhT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 08:37:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type
         :content-transfer-encoding;
        b=Cnj2uquVpx/UyRftSt1xSB/ZP8IwCYKyQv9JYsKtRNcxjwWkcqDAwxynqsA4JyYjUU
         wjTc2Bf7bQdSx9LXSjJplVrobBD0wDIIWEz31pUE8vR6GgbGMsHOixammhelm3ISt3XO
         r9KoDud0fw3Vt7fDalbhH8OMlB5JmNs1mChw4=
MIME-Version: 1.0
From: Hui Zhu <teawater@gmail.com>
Date: Sun, 17 Jan 2010 21:36:58 +0800
Message-ID: <daef60381001170536s79551f0drb573181d18db6369@mail.gmail.com>
Subject: [PATCH] Change hex to Math::BigInt->from_hex in markup_oops.pl
To: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Sam Ravnborg <sam@ravnborg.org>,
       =?ISO-8859-1?Q?Ozan_=C7aglayan?= <ozan@pardus.org.tr>,
       Matthew Wilcox <willy@linux.intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hex cannot work well in x86 to parse the oops message for x8664.
So this patch change it.

Thanks,
Hui

Signed-off-by: Hui Zhu <teawater@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Ozan Çaglayan <ozan@pardus.org.tr>
Cc: Matthew Wilcox <willy@linux.intel.com>

---
 scripts/markup_oops.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/scripts/markup_oops.pl
+++ b/scripts/markup_oops.pl
@@ -196,7 +196,7 @@ if ($module ne "") {
 	while (<FILE>) {
 		if ($_ =~ /^([0-9a-f]+) \<$function\>\:/) {
 			my $fu = $1;
-			$vmaoffset = hex($target) - hex($fu) - hex($func_offset);
+			$vmaoffset = Math::BigInt->from_hex("0x$target") -
Math::BigInt->from_hex("0x$fu") -
Math::BigInt->from_hex("0x$func_offset");
 		}
 	}
 	close(FILE);
@@ -212,7 +212,7 @@ sub InRange {
 	my ($address, $target) = @_;
 	my $ad = "0x".$address;
 	my $ta = "0x".$target;
-	my $delta = hex($ad) - hex($ta);
+	my $delta = Math::BigInt->from_hex($ad) - Math::BigInt->from_hex($ta);

 	if (($delta > -4096) && ($delta < 4096)) {
 		return 1;
