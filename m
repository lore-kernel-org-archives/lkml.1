Return-Path: <linux-kernel-owner+w=401wt.eu-S1765736AbXLOH1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765736AbXLOH1T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 02:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751256AbXLOH1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 02:27:13 -0500
Received: from web52005.mail.re2.yahoo.com ([206.190.49.252]:32098 "HELO
	web52005.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751236AbXLOH1M convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 02:27:12 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 Dec 2007 02:27:11 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=LJeEIIVaxO7PWnJlv6E9dvuaVvTgBtFN52JBC9LjKEf45Fq+anxK1zhLmf5+tjDQhbuIEewOV3p7sPFzUlYAWPDEoNIobynm0cfZFhXRVIAkXmsgPz/sv0W1yuvK1sxOb/pf+OobW9eQexCPGQYbtKpyVkZ2HHivUA4rhwOX9xQ=;
X-YMail-OSG: ud7pnH4VM1kXFH6VcFjo9_NbXgvsjk5HprhPIvSJH.pVrpVOg0m_U8bP0Emv3RTXtB2bdIwj_PDtEX1aTQoTlrcSUd8nccGzgspGCWihFSoZQEqfNi6aw8mwMmVdLCLS1i8V.CzVfAoeqPgMbCtvpVY-
X-Mailer: YahooMailRC/818.31 YahooMailWebService/0.7.158.1
Date: Fri, 14 Dec 2007 23:20:30 -0800 (PST)
From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
Subject: /dev/urandom uses uninit bytes, leaks user data
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <977119.41267.qm@web52005.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matti Linnanvuori <mattilinnnvuori@yahoo.com>

/dev/urandom use no uninit bytes, leak no user data

Signed-off-by: Matti Linnanvuori <mattilinnnvuori@yahoo.com>

---

--- a/drivers/char/random.c	2007-12-15 09:09:37.895414000 +0200
+++ b/drivers/char/random.c	2007-12-15 09:12:02.607831500 +0200
@@ -689,7 +689,7 @@ static ssize_t extract_entropy(struct en
  */
 static void xfer_secondary_pool(struct entropy_store *r, size_t nbytes)
 {
-	__u32 tmp[OUTPUT_POOL_WORDS];
+	static __u32 tmp[OUTPUT_POOL_WORDS];
 
 	if (r->pull && r->entropy_count < nbytes * 8 &&
 	    r->entropy_count < r->poolinfo->POOLBITS) {




      Machen Sie Yahoo! zu Ihrer Startseite. Los geht's: 
http://de.yahoo.com/set
