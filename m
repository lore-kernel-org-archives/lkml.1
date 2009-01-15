Return-Path: <linux-kernel-owner+w=401wt.eu-S1759553AbZAON0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759553AbZAON0e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 08:26:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754587AbZAON0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 08:26:25 -0500
Received: from web23602.mail.ird.yahoo.com ([87.248.115.45]:39099 "HELO
	web23602.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753603AbZAON0Y convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 08:26:24 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Jan 2009 08:26:23 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=PDMBBHStwSG24D+7Ibpx/mP2rsvDmBxHeIeqn7CqIv+tLtwI3f0oz/C5zPXD3Cy9DeV3B46KTlB6EHyFvnDMC3dFsMDxXEfTG/FYQF8hLlncLtnqzXmOh3+Wfa8kX154HgMf9rnB6r6L1Mpy8JzcR0bjK1Fv01mwz5OED0Q8yz8=;
X-YMail-OSG: GF3XN.0VM1mYyhnWGR1SS6ZHCIRPH1dpRJKj3xw_U_1IRh9B6_TGiFIXOmlDibhkar1zr4F05srgrcBw_.uUt7yDbPL0e4zTBkMYQZwl1m1.g36zcFsk6bIwmJACrwSeZy7ow7peIrnwX1jPjUfimungcJOmFlysFT2gTpBU8PWGSsxos_kHyypqY1U8DRqXHGuJaMymQUH4nGzB3fUt8Pn5sCqu80mAJM3flAN2YkOkQCkEyOuTl_zdb4XC.8Sov0GUmLBvT4Q9fvHzbG.XIZEcyuPbvpMctwGpOptxS8upJBjpF7.E457rXau3BQlgDBQ0g_aZajJn1AMQRnP41rmVw.tNRDX2ERzx5v9qOo_.nL69T53D
X-Mailer: YahooMailWebService/0.7.260.1
Date: Thu, 15 Jan 2009 13:19:42 +0000 (GMT)
From: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Reply-To: etienne_lorrain@yahoo.fr
Subject: [GIT PULL] bzip2/lzma kernel compression
To: linux-kernel@vger.kernel.org, hpa@zytor.com
Cc: torvalds@linux-foundation.org, alain@knaff.lu, sam@ravnborg.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <758512.74881.qm@web23602.mail.ird.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lib/decompress_inflate.c:
+	/* skip over asciz filename */
+	if (zbuf[3] & 0x8) {
+		while (strm->next_in[0])
+			strm->next_in++;
+		strm->next_in++;
+	}
+	strm->avail_in = len - (strm->next_in - zbuf);

How about also allowing a GZIP comment (as specs) if (zbuf[3] & 0x10) ?
To test, generating a GZIP with comment is easily done by my gzcopy:
gzcopy -a="a comment" in.gz out.gz
found in this other bootloader, and can be downloaded at:
http://www.mirrorservice.org/sites/download.sourceforge.net/pub/sourceforge/g/gu/gujin/install-2.4.tar.gz/install/gzcopy?extract=true

Etienne.


      
