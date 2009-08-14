Return-Path: <linux-kernel-owner+w=401wt.eu-S1756248AbZHNGFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248AbZHNGFH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 02:05:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756147AbZHNGFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 02:05:06 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48838 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756076AbZHNGFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 02:05:05 -0400
Date: Fri, 14 Aug 2009 16:04:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Karsten Keil <isdn@linux-pingi.de>
Cc: isdn4linux@listserv.isdn4linux.de, Armin Schindler <mac@melware.de>,
       "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] ISDN: use offetof in eicon/message.c
Message-Id: <20090814160458.eb43b410.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eliminate these compiler warnings:

drivers/isdn/hardware/eicon/message.c: In function 'connect_b3_req':
drivers/isdn/hardware/eicon/message.c:2695: warning: cast from pointer to integer of different size
drivers/isdn/hardware/eicon/message.c:2757: warning: cast from pointer to integer of different size
drivers/isdn/hardware/eicon/message.c:2791: warning: cast from pointer to integer of different size
drivers/isdn/hardware/eicon/message.c: In function 'connect_b3_res':
drivers/isdn/hardware/eicon/message.c:2895: warning: cast from pointer to integer of different size
drivers/isdn/hardware/eicon/message.c: In function 'manufacturer_res':
drivers/isdn/hardware/eicon/message.c:3805: warning: cast from pointer to integer of different size
drivers/isdn/hardware/eicon/message.c: In function 'nl_ind':
drivers/isdn/hardware/eicon/message.c:6847: warning: cast from pointer to integer of different size
drivers/isdn/hardware/eicon/message.c: In function 'add_b23':
drivers/isdn/hardware/eicon/message.c:8476: warning: cast from pointer to integer of different size
drivers/isdn/hardware/eicon/message.c:8528: warning: cast from pointer to integer of different size

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/isdn/hardware/eicon/message.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

I have finally got sick of these in linux-next :-)
The resulting object files (from and x86_64 allmodconfig) are identical
except for the places that line numbers are being used.

This patch is relative to the current net-next-2.6 tree.

diff --git a/drivers/isdn/hardware/eicon/message.c b/drivers/isdn/hardware/eicon/message.c
index 27d5dd6..89af308 100644
--- a/drivers/isdn/hardware/eicon/message.c
+++ b/drivers/isdn/hardware/eicon/message.c
@@ -24,6 +24,7 @@
  */
 
 
+#include <linux/stddef.h>	/* for offsetof */
 
 
 
@@ -2692,7 +2693,7 @@ static byte connect_b3_req(dword Id, word Number, DIVA_CAPI_ADAPTER *a,
           if (!(fax_control_bits & T30_CONTROL_BIT_MORE_DOCUMENTS)
            || (fax_feature_bits & T30_FEATURE_BIT_MORE_DOCUMENTS))
           {
-            len = (byte)(&(((T30_INFO *) 0)->universal_6));
+            len = (byte)offsetof(T30_INFO, universal_6);
             fax_info_change = false;
             if (ncpi->length >= 4)
             {
@@ -2754,7 +2755,7 @@ static byte connect_b3_req(dword Id, word Number, DIVA_CAPI_ADAPTER *a,
                     for (i = 0; i < w; i++)
                       ((T30_INFO   *)(plci->fax_connect_info_buffer))->station_id[i] = fax_parms[4].info[1+i];
                     ((T30_INFO   *)(plci->fax_connect_info_buffer))->head_line_len = 0;
-                    len = (byte)(((T30_INFO *) 0)->station_id + 20);
+                    len = (byte)(offsetof(T30_INFO, station_id[0]) + 20);
                     w = fax_parms[5].length;
                     if (w > 20)
                       w = 20;
@@ -2788,7 +2789,7 @@ static byte connect_b3_req(dword Id, word Number, DIVA_CAPI_ADAPTER *a,
                 }
                 else
                 {
-                  len = (byte)(&(((T30_INFO *) 0)->universal_6));
+                  len = (byte)offsetof(T30_INFO, universal_6);
                 }
                 fax_info_change = true;
 
@@ -2892,7 +2893,7 @@ static byte connect_b3_res(dword Id, word Number, DIVA_CAPI_ADAPTER *a,
     && (plci->nsf_control_bits & T30_NSF_CONTROL_BIT_ENABLE_NSF)
     && (plci->nsf_control_bits & T30_NSF_CONTROL_BIT_NEGOTIATE_RESP))
    {
-            len = ((byte)(((T30_INFO *) 0)->station_id + 20));
+            len = ((byte)(offsetof(T30_INFO, station_id[0]) + 20));
             if (plci->fax_connect_info_length < len)
             {
               ((T30_INFO *)(plci->fax_connect_info_buffer))->station_id_len = 0;
@@ -3802,7 +3803,7 @@ static byte manufacturer_res(dword Id, word Number, DIVA_CAPI_ADAPTER *a,
       break;
     }
     ncpi = &m_parms[1];
-    len = ((byte)(((T30_INFO *) 0)->station_id + 20));
+    len = ((byte)(offsetof(T30_INFO, station_id[0]) + 20));
     if (plci->fax_connect_info_length < len)
     {
       ((T30_INFO *)(plci->fax_connect_info_buffer))->station_id_len = 0;
@@ -6844,7 +6845,7 @@ static void nl_ind(PLCI *plci)
         if ((plci->requested_options_conn | plci->requested_options | a->requested_options_table[plci->appl->Id-1])
           & ((1L << PRIVATE_FAX_SUB_SEP_PWD) | (1L << PRIVATE_FAX_NONSTANDARD)))
         {
-          i = ((word)(((T30_INFO *) 0)->station_id + 20)) + ((T30_INFO   *)plci->NL.RBuffer->P)->head_line_len;
+          i = ((word)(offsetof(T30_INFO, station_id[0]) + 20)) + ((T30_INFO   *)plci->NL.RBuffer->P)->head_line_len;
           while (i < plci->NL.RBuffer->length)
             plci->ncpi_buffer[++len] = plci->NL.RBuffer->P[i++];
         }
@@ -8473,7 +8474,7 @@ static word add_b23(PLCI *plci, API_PARSE *bp)
             fax_control_bits |= T30_CONTROL_BIT_ACCEPT_SEL_POLLING;
           }
             len = nlc[0];
-          pos = ((byte)(((T30_INFO *) 0)->station_id + 20));
+          pos = ((byte)(offsetof(T30_INFO, station_id[0]) + 20));
    if (pos < plci->fax_connect_info_length)
    {
      for (i = 1 + plci->fax_connect_info_buffer[pos]; i != 0; i--)
@@ -8525,7 +8526,7 @@ static word add_b23(PLCI *plci, API_PARSE *bp)
       }
 
       PUT_WORD(&(((T30_INFO *)&nlc[1])->control_bits_low), fax_control_bits);
-      len = ((byte)(((T30_INFO *) 0)->station_id + 20));
+      len = ((byte)(offsetof(T30_INFO, station_id[0]) + 20));
       for (i = 0; i < len; i++)
         plci->fax_connect_info_buffer[i] = nlc[1+i];
       ((T30_INFO   *) plci->fax_connect_info_buffer)->head_line_len = 0;
-- 
1.6.3.3


-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
