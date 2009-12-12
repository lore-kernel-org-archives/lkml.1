Return-Path: <linux-kernel-owner+w=401wt.eu-S933954AbZLLDBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933954AbZLLDBf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 22:01:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761526AbZLLDB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 22:01:29 -0500
Received: from web53501.mail.re2.yahoo.com ([206.190.37.62]:27730 "HELO
	web53501.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761500AbZLLDB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 22:01:28 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Dec 2009 22:01:28 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type;
  b=wYoqskIMCX0uJdUZp3QWRhCpCqEmnOek5v7hZsV05X8EnhCBIjdI8/9cjsGzIUpXdaT04s7KNmwG0vYj4zI0iMpLBK4HLUN2QDHmc5KAub5dE023O+x3/Mt2/R456eXFyCT+6yKIUI+wENm5HYfMtNd+k0cmz853GnIi3GRE0gs=;
Message-ID: <994.13667.qm@web53501.mail.re2.yahoo.com>
X-YMail-OSG: S9LS4LoVM1lXdIckyG_QXruOt1HeexhjbV6g4Ka6q_Ua.irgi0nCvJljj_2RbsIIezKql8vx.B6rSpWD93ryyyx2Xcidl58M7Ksk_rlLg6q5ugRPQ6.JK_XL2HVxcyERpmS7BiAt21HXABJZJw67qihqAey4YEI84iA2LifhrKhobG7Y1SzVOGr0M755im2dsqUSdwU7ZbV4lDOUSPZWTRqBGIQUNKuQ3GTJ4jUSaPEXPg.ijG6RbkYMWjJYsrfDKYgEWmGktDEoUfa5SkKqLX6XKQNXaqL9le4cOWs6SZmolNnE__vaayojIX0PsdqerpQ_s9Cv9HnW6Cvq29LL3T2s2w--
X-Mailer: YahooMailRC/240.3 YahooMailWebService/0.8.100.260964
Date: Fri, 11 Dec 2009 18:54:54 -0800 (PST)
From: roger blofeld <blofeldus@yahoo.com>
Subject: [PATCH] adt7462: Fix pin 28 monitoring
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, lm-sensors@lm-sensors.org,
       lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0-27544763-1260586494=:13667"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0-27544763-1260586494=:13667
Content-Type: text/plain; charset=us-ascii

The ADT7462_PIN28_VOLT value is a 4-bit field, so the corresponding shift must be 4.

Signed-off-by: Roger Blofeld <blofeldus@yahoo.com>
---
My mailer will whitespace damage the inline copy of the patch.
The attached version should be OK.

diff --git a/drivers/hwmon/adt7462.c b/drivers/hwmon/adt7462.c
index 1852f27..262c133 100644
--- a/drivers/hwmon/adt7462.c
+++ b/drivers/hwmon/adt7462.c
@@ -97,7 +97,7 @@ I2C_CLIENT_INSMOD_1(adt7462);
 #define        ADT7462_PIN24_SHIFT        6
 #define        ADT7462_PIN26_VOLT_INPUT    0x08
 #define        ADT7462_PIN25_VOLT_INPUT    0x20
-#define        ADT7462_PIN28_SHIFT        6    /* cfg3 */
+#define        ADT7462_PIN28_SHIFT        4    /* cfg3 */
 #define        ADT7462_PIN28_VOLT        0x5
 
 #define ADT7462_REG_ALARM1            0xB8


      
--0-27544763-1260586494=:13667
Content-Type: application/octet-stream; name="adt7462-p28-shift.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="adt7462-p28-shift.patch"

VGhlIEFEVDc0NjJfUElOMjhfVk9MVCB2YWx1ZSBpcyBhIDQtYml0IGZpZWxk
LCBzbyB0aGUgY29ycmVzcG9uZGluZyBzaGlmdCBtdXN0IGJlIDQuCgpTaWdu
ZWQtb2ZmLWJ5OiBSb2dlciBCbG9mZWxkIDxibG9mZWxkdXNAeWFob28uY29t
PgotLS0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvaHdtb24vYWR0NzQ2Mi5jIGIv
ZHJpdmVycy9od21vbi9hZHQ3NDYyLmMKaW5kZXggMTg1MmYyNy4uMjYyYzEz
MyAxMDA2NDQKLS0tIGEvZHJpdmVycy9od21vbi9hZHQ3NDYyLmMKKysrIGIv
ZHJpdmVycy9od21vbi9hZHQ3NDYyLmMKQEAgLTk3LDcgKzk3LDcgQEAgSTJD
X0NMSUVOVF9JTlNNT0RfMShhZHQ3NDYyKTsKICNkZWZpbmUJCUFEVDc0NjJf
UElOMjRfU0hJRlQJCTYKICNkZWZpbmUJCUFEVDc0NjJfUElOMjZfVk9MVF9J
TlBVVAkweDA4CiAjZGVmaW5lCQlBRFQ3NDYyX1BJTjI1X1ZPTFRfSU5QVVQJ
MHgyMAotI2RlZmluZQkJQURUNzQ2Ml9QSU4yOF9TSElGVAkJNgkvKiBjZmcz
ICovCisjZGVmaW5lCQlBRFQ3NDYyX1BJTjI4X1NISUZUCQk0CS8qIGNmZzMg
Ki8KICNkZWZpbmUJCUFEVDc0NjJfUElOMjhfVk9MVAkJMHg1CiAKICNkZWZp
bmUgQURUNzQ2Ml9SRUdfQUxBUk0xCQkJMHhCOAo=

--0-27544763-1260586494=:13667--
