Return-Path: <linux-kernel-owner+w=401wt.eu-S1756173Ab0AFV2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173Ab0AFV2O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 16:28:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755963Ab0AFV2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 16:28:14 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:52835 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100Ab0AFV2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 16:28:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type;
        b=NZ9ZavWsCF0GEsDdimr0xAogrY373skcCJfYncpPbwlwamXctWmrQiI2YFIyBN8q7n
         kNkWOSgv+Oc6QDLvUML2QHgTIKtOIB70bhaHn5Xl/ROznOBiBzRBoUocCZLf+HhYaFmP
         76rXxobEqixy0ncIj/CAISBY2JAMsB43obhb8=
Message-ID: <4B450065.4010108@gmail.com>
Date: Wed, 06 Jan 2010 16:28:05 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Linux Kernel Developers <linux-kernel@vger.kernel.org>
CC: Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Michael Chan <mchan@broadcom.com>
Subject: Re: [PATCH 1/2] net: tcp_header_len_th and tcp_option_len_th
References: <4B44FE3C.6060809@gmail.com>
In-Reply-To: <4B44FE3C.6060809@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------020303000900040805090502"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020303000900040805090502
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Redefine two TCP header functions to accept TCP header pointer.
When subtracting, return signed int to allow error checking.

These functions will be used in subsequent patches that implement
additional features.

Signed-off-by: William.Allen.Simpson@gmail.com
---
  include/linux/tcp.h |   12 ++++++++++++
  1 files changed, 12 insertions(+), 0 deletions(-)


--------------020303000900040805090502
Content-Type: text/plain; x-mac-type="54455854"; x-mac-creator="0";
 name="len_th+1v3.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="len_th+1v3.patch"

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 7fee8a4..d0133cf 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -223,6 +223,18 @@ static inline unsigned int tcp_optlen(const struct sk_buff *skb)
 	return (tcp_hdr(skb)->doff - 5) * 4;
 }
 
+/* Length of fixed header plus standard options. */
+static inline unsigned int tcp_header_len_th(const struct tcphdr *th)
+{
+	return th->doff * 4;
+}
+
+/* Length of standard options only.  This could be negative. */
+static inline int tcp_option_len_th(const struct tcphdr *th)
+{
+	return (int)(th->doff * 4) - sizeof(*th);
+}
+
 /* This defines a selective acknowledgement block. */
 struct tcp_sack_block_wire {
 	__be32	start_seq;
-- 
1.6.3.3


--------------020303000900040805090502--
