Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574Ab0CKLrA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 06:47:00 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:59378 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757508Ab0CKLq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 06:46:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type;
        b=uQ8XZfcdMurQsvZtDIcLywb+NRRxLp/7L8r72LXWcw7IX/sFeZx5O2Ovtg6hD7B4A9
         8RnmyjDlRpMayNYdq99SdI/zRBdfbF6iGnQIDJklEqQbZ8QoORLnlZ6H6N4E0OOZX7dE
         Zq+pR3to/WzBKbbNkNtpnx65MSJLrNGwpGlHU=
Message-ID: <4B98D6DD.2010309@gmail.com>
Date: Thu, 11 Mar 2010 06:41:17 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       David Miller <davem@davemloft.net>
Subject: [PATCH v3 1/7] net: tcp_header_len_th and tcp_option_len_th
References: <4B98D592.6040301@gmail.com>
In-Reply-To: <4B98D592.6040301@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------030603020305080906020502"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030603020305080906020502
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

--------------030603020305080906020502
Content-Type: text/plain; x-mac-type="54455854"; x-mac-creator="0";
 name="len_th+2a3+2.6.34-rc1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="len_th+2a3+2.6.34-rc1.patch"

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index a778ee0..48ddeb8 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -225,6 +225,18 @@ static inline unsigned int tcp_optlen(const struct sk_buff *skb)
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


--------------030603020305080906020502--
