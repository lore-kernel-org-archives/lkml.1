Return-Path: <linux-kernel-owner+w=401wt.eu-S933770AbXJQVwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933770AbXJQVwt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 17:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762134AbXJQVwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 17:52:30 -0400
Received: from ims.2wire.com ([206.171.6.87]:27618 "EHLO ims.2wire.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761710AbXJQVw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 17:52:28 -0400
X-Greylist: delayed 974 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Oct 2007 17:52:27 EDT
User-Agent: Microsoft-Entourage/11.3.6.070618
Date: Wed, 17 Oct 2007 14:36:10 -0700
Subject: [PATCH] pfkey: sending an SADB_GET responds with an SADB_GET
From: Charles Hardin <chardin@2wire.com>
To: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Message-ID: <C33BCE5A.25D04%chardin@2wire.com>
Thread-Topic: [PATCH] pfkey: sending an SADB_GET responds with an SADB_GET
Thread-Index: AcgRBbua+mJ2pnz4EdyZZQAWy4Zuww==
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
X-OriginalArrivalTime: 17 Oct 2007 21:36:13.0051 (UTC) FILETIME=[BD6B8CB0:01C81105]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel needs to respond to an SADB_GET with the same message type to conform
to the RFC 2367 Section 3.1.5

diff --git a/net/key/af_key.c b/net/key/af_key.c
index 7969f8a..fb4fee1 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -1552,7 +1552,7 @@ static int pfkey_get(struct sock *sk, struct sk_buff
*skb,
 
        out_hdr = (struct sadb_msg *) out_skb->data;
        out_hdr->sadb_msg_version = hdr->sadb_msg_version;
-       out_hdr->sadb_msg_type = SADB_DUMP;
+       out_hdr->sadb_msg_type = SADB_GET;
        out_hdr->sadb_msg_satype = pfkey_proto2satype(proto);
        out_hdr->sadb_msg_errno = 0;
        out_hdr->sadb_msg_reserved = 0;

