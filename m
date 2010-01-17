Return-Path: <linux-kernel-owner+w=401wt.eu-S1753436Ab0AQNfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab0AQNfy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 08:35:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752845Ab0AQNfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 08:35:47 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:39623 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab0AQNfp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 08:35:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type
         :content-transfer-encoding;
        b=JH2R4g1+rTgzsVlDtAft/7ezeSye8dUjFso0CiAvFdxClLiw0ebygr0hF+zsqlS5Mi
         HBIdG8slaLmk3XBE4bpYvHN8RU5YMLcZy5QWbDn1dvBCZZrl285f6L0WDRFE87HlVMxS
         Q5RmlqPh8F+C+bzXXOpLeBJj8tgncqXa3ile8=
MIME-Version: 1.0
From: Hui Zhu <teawater@gmail.com>
Date: Sun, 17 Jan 2010 21:35:25 +0800
Message-ID: <daef60381001170535q6abfd29cp1b8d07709c00e1db@mail.gmail.com>
Subject: [PATCH] Fix markup_oops.pl get $func_offset error in x8664
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

This patch like the prev patch in http://lkml.org/lkml/2010/1/6/57
The x8664 part have the same trouble with it.  This patch is to fix it.

Thanks,
Hui

Signed-off-by: Hui Zhu <teawater@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Ozan Çaglayan <ozan@pardus.org.tr>
Cc: Matthew Wilcox <willy@linux.intel.com>
---
 scripts/markup_oops.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/markup_oops.pl
+++ b/scripts/markup_oops.pl
@@ -158,7 +158,7 @@ while (<STDIN>) {
 		$function = $1;
 		$func_offset = $2;
 	}
-	if ($line =~ /RIP: 0010:\[\<[0-9a-f]+\>\]  \[\<[0-9a-f]+\>\]
([a-zA-Z0-9\_]+)\+(0x[0-9a-f]+)\/0x[a-f0-9]/) {
+	if ($line =~ /RIP: 0010:\[\<[0-9a-f]+\>\]  \[\<[0-9a-f]+\>\]
([a-zA-Z0-9\_]+)\+0x([0-9a-f]+)\/0x[a-f0-9]/) {
 		$function = $1;
 		$func_offset = $2;
 	}
