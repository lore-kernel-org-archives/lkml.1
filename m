Return-Path: <linux-kernel-owner+w=401wt.eu-S1760884AbXK1LGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760884AbXK1LGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 06:06:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758292AbXK1LGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 06:06:48 -0500
Received: from s131.mittwaldmedien.de ([62.216.178.31]:15263 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758614AbXK1LGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 06:06:47 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: apw@shadowen.org, rdunlap@xenotime.net, jschopp@austin.ibm.com
Subject: bug in checkpath.pl
Date: Wed, 28 Nov 2007 12:07:38 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711281207.38252.hs4233@mail.mn-solutions.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have a case where scripts/checkpatch.pl returns a false error. 
First, here is the code:


static int lbs_scan_add_rates_tlv(u8 *tlv)
{
	int i;
	struct mrvlietypes_ratesparamset *rate_tlv =
		(struct mrvlietypes_ratesparamset *) tlv;

	rate_tlv->header.type = cpu_to_le16(TLV_TYPE_RATES);
	tlv += sizeof(rate_tlv->header);
	for (i = 0; i < MAX_RATES; i++) {
		*tlv = lbs_bg_rates[i];
		if (*tlv == 0)
			break;
		if (*tlv == 0x02 || *tlv == 0x04 ||
		    *tlv == 0x0b || *tlv == 0x16)
			*tlv |= 0x80;
		tlv++;
	}
	rate_tlv->header.len = i;
	return sizeof(rate_tlv->header) + i;
}


And here the error from checkpatch.pl:

ERROR: need consistent spacing around '*' (ctx:WxV)
#553: FILE: drivers/net/wireless/libertas/scan.c:438:
+                       *tlv |= 0x80;



This error seems wrong, tlv is a pointer to some u8 value
(a.k.a. unsigned char), and it is very well allowed to
operate on it via *variablename |= 0x80;
