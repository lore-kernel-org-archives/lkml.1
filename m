Return-Path: <linux-kernel-owner+w=401wt.eu-S1759922AbZLJEEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759922AbZLJEEg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 23:04:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759911AbZLJEEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 23:04:30 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:45997 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759910AbZLJEEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 23:04:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=w7qvWxUtV7c5Hx55LunSzS7BMUnXPpFVbwUPfFVTZD9WDLFNQW0gFsb/jVWiAhGudO
         odkRPMxLSoaypWRn5EDXwg2yiQwl67J7/xrKEqoxpwhGxQGjWY9WIZgHJ76Ml2C9zDYc
         Lv86VQqvdiryJbzQjS5rbyJzhenJo8TC3m2Ok=
MIME-Version: 1.0
Date: Thu, 10 Dec 2009 12:04:35 +0800
Message-ID: <6304b52b0912092004t646569bdm2a6bbc9bb2440aba@mail.gmail.com>
Subject: [PATCH]about eicon: array subscript is above array bounds
From: Jerry Leo <jerryleo860202@gmail.com>
To: isdn@linux-pingi.de
Cc: linux-kernel@vger.kernel.org, isdn4linux@listserv.isdn4linux.de,
       i4ldeveloper@listserv.isdn4linux.de
Content-Type: multipart/mixed; boundary=00032555564ac39f8b047a57e750
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00032555564ac39f8b047a57e750
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Hi, Karsten Keil,

        When i compile eicon,there have some waning look like this:

           CC [M]  drivers/isdn/hardware/eicon/message.o
drivers/isdn/hardware/eicon/message.c: In function =91add_b23=92:
drivers/isdn/hardware/eicon/message.c:8426: warning: array subscript
is above array bounds
drivers/isdn/hardware/eicon/message.c:8427: warning: array subscript
is above array bounds
drivers/isdn/hardware/eicon/message.c:8434: warning: array subscript
is above array bounds
drivers/isdn/hardware/eicon/message.c:8435: warning: array subscript
is above array bounds
drivers/isdn/hardware/eicon/message.c:8436: warning: array subscript
is above array bounds
drivers/isdn/hardware/eicon/message.c:8447: warning: array subscript
is above array bounds

I think the array is short then be used,because the array's max length
is 20, then it will use long than this, the code is in
"drivers/isdn/hardware/eicon/divacapi.h" 1360L, 50994C  :


#define T30_MAX_STATION_ID_LENGTH       20
#define T30_MAX_SUBADDRESS_LENGTH       20
#define T30_MAX_PASSWORD_LENGTH         20

typedef struct t30_info_s T30_INFO;
struct t30_info_s {
  byte          code;
  byte          rate_div_2400;
  byte          resolution;
  byte          data_format;
  byte          pages_low;
  byte          pages_high;
  byte          operating_mode;
  byte          control_bits_low;
  byte          control_bits_high;
  byte          feature_bits_low;
  byte          feature_bits_high;
  byte          recording_properties;
  byte          universal_6;
  byte          universal_7;
  byte          station_id_len;
  byte          head_line_len;
  byte          station_id[T30_MAX_STATION_ID_LENGTH];
/* byte          head_line[];      */
/* byte          sub_sep_length;   */
/* byte          sub_sep_field[];  */
/* byte          pwd_length;       */
/* byte          pwd_field[];      */
/* byte          nsf_info_length;   */
/* byte          nsf_info_field[];  */
};

"drivers/isdn/hardware/eicon/message.c" 15071L, 487328C

        if (pos !=3D 0)
        {
          if (CAPI_MAX_DATE_TIME_LENGTH + 2 +
b3_config_parms[3].length > CAPI_MAX_HEAD_LINE_SPACE)
            pos =3D 0;
          else
          {
            ((T30_INFO *)&nlc[1])->station_id[20 + pos++] =3D ' ';
            ((T30_INFO *)&nlc[1])->station_id[20 + pos++] =3D ' ';
            len =3D (byte)b3_config_parms[2].length;
            if (len > 20)
              len =3D 20;
            if (CAPI_MAX_DATE_TIME_LENGTH + 2 + len + 2 +
b3_config_parms[3].length <=3D CAPI_MAX_HEAD_LINE_SPACE)
            {
              for (i =3D 0; i < len; i++)
                ((T30_INFO *)&nlc[1])->station_id[20 + pos++] =3D ((byte
  *)b3_config_parms[2].info)[1+i];
              ((T30_INFO *)&nlc[1])->station_id[20 + pos++] =3D ' ';
              ((T30_INFO *)&nlc[1])->station_id[20 + pos++] =3D ' ';
            }
          }
        }



can this patch commit?


diff -up linux-2.6/drivers/isdn/hardware/eicon/divacapi.h
linux-2.6/drivers/isdn/hardware/eicon/divacapi.h.orig
--- linux-2.6/drivers/isdn/hardware/eicon/divacapi.h	2009-12-10
12:02:46.000000000 +0800
+++ linux-2.6/drivers/isdn/hardware/eicon/divacapi.h.orig	2009-12-10
11:04:07.000000000 +0800
@@ -445,7 +445,7 @@ struct _DIVA_CAPI_ADAPTER {
 #define CAPI_MAX_HEAD_LINE_SPACE        89
 #define CAPI_MAX_DATE_TIME_LENGTH       18

-#define T30_MAX_STATION_ID_LENGTH       30
+#define T30_MAX_STATION_ID_LENGTH       20
 #define T30_MAX_SUBADDRESS_LENGTH       20
 #define T30_MAX_PASSWORD_LENGTH         20

--00032555564ac39f8b047a57e750
Content-Type: application/octet-stream; name=patch
Content-Disposition: attachment; filename=patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g31040e30

LS0tIGxpbnV4LTIuNi9kcml2ZXJzL2lzZG4vaGFyZHdhcmUvZWljb24vZGl2YWNhcGkuaC5vcmln
CTIwMDktMTItMTAgMTE6MDQ6MDcuMDAwMDAwMDAwICswODAwCisrKyBsaW51eC0yLjYvZHJpdmVy
cy9pc2RuL2hhcmR3YXJlL2VpY29uL2RpdmFjYXBpLmgJMjAwOS0xMi0xMCAxMTowNDozNi4wMDAw
MDAwMDAgKzA4MDAKQEAgLTQ0NSw3ICs0NDUsNyBAQCBzdHJ1Y3QgX0RJVkFfQ0FQSV9BREFQVEVS
IHsKICNkZWZpbmUgQ0FQSV9NQVhfSEVBRF9MSU5FX1NQQUNFICAgICAgICA4OQogI2RlZmluZSBD
QVBJX01BWF9EQVRFX1RJTUVfTEVOR1RIICAgICAgIDE4CiAKLSNkZWZpbmUgVDMwX01BWF9TVEFU
SU9OX0lEX0xFTkdUSCAgICAgICAyMAorI2RlZmluZSBUMzBfTUFYX1NUQVRJT05fSURfTEVOR1RI
ICAgICAgIDMwCiAjZGVmaW5lIFQzMF9NQVhfU1VCQUREUkVTU19MRU5HVEggICAgICAgMjAKICNk
ZWZpbmUgVDMwX01BWF9QQVNTV09SRF9MRU5HVEggICAgICAgICAyMAogCg==
--00032555564ac39f8b047a57e750--
