Return-Path: <linux-kernel-owner+w=401wt.eu-S1756769AbYLKQCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769AbYLKQCf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 11:02:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756240AbYLKQCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 11:02:25 -0500
Received: from rv-out-0506.google.com ([209.85.198.233]:29189 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756233AbYLKQCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 11:02:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=tYd3BC2gi8eHOi/XwbqAQZJ+iqpEJYIZtyFHa7+wCo7u73rozPaWphDsB9dgz9UKvK
         ym2MttFnZ8qKKjBDoNc5P2yNsKUYH5G1qCbWu3KN9ZJxK8c8R/oc/Kk4S+K9qsd+ryGA
         uK+KrbIIoq3HggAiONKKDaaDttbFQXFicziw8=
Message-ID: <8bd0f97a0812110802k1faa1c67tc81b4bb5282a3d17@mail.gmail.com>
Date: Thu, 11 Dec 2008 11:02:24 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: broonie@opensource.wolfsonmicro.com
Subject: breakage in linux-next sound/soc/blackfin/bf5xx-i2s.c
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

your recent change 3f4b783cfd (ASoC: Register platform DAIs) is
incorrect for sound/soc/blackfin/bf5xx-i2s.c.

the change made there:
+static int __devinit bfin_i2s_init(void)
+{
+       return snd_soc_register_dai(&bfin_i2s_dai);
+}
+module_init(bfin_i2s_init);
+
+static void __exit bfin_i2s_exit(void)
+{
+       snd_soc_unregister_dai(&bfin_i2s_dai);
+}
+module_exit(bfin_i2s_exit);

leads to this:
sound/soc/blackfin/bf5xx-i2s.c:294: warning: initialization from
incompatible pointer type
sound/soc/blackfin/bf5xx-i2s.c: In function 'bfin_i2s_init':
sound/soc/blackfin/bf5xx-i2s.c:318: error: 'bfin_i2s_dai' undeclared
(first use in this function)
sound/soc/blackfin/bf5xx-i2s.c:318: error: (Each undeclared identifier
is reported only once
sound/soc/blackfin/bf5xx-i2s.c:318: error: for each function it appears in.)
sound/soc/blackfin/bf5xx-i2s.c: In function 'bfin_i2s_exit':
sound/soc/blackfin/bf5xx-i2s.c:324: error: 'bfin_i2s_dai' undeclared
(first use in this function)
make[3]: *** [sound/soc/blackfin/bf5xx-i2s.o] Error 1
make[2]: *** [sound/soc/blackfin] Error 2
make[1]: *** [sound/soc] Error 2
make: *** [sound] Error 2

since the variable is named "bf5xx_i2s_dai", not "bfin_i2s_dai"
-mike
