Return-Path: <linux-kernel-owner+w=401wt.eu-S1753605AbYGCL6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605AbYGCL6t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 07:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753781AbYGCL4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 07:56:38 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:63237 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730AbYGCL4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 07:56:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=d3TmRr0spKUCpfJy50Uq8w9VPiWJ0v6SFJlGLB/T/yXao7SDIm3c8tZkIjRIgIs9iI
         KUyMFautzDC4EcBliC7wyoGiPD70QxxgSVcvUpNuCeYl+G03wxu3rnB/WjhSDdNuiKo5
         xGCeODBH0c9yb5B2/mp63XgdYlqJ1mf3JAJ+U=
Subject: [PATCH] drivers/net/wireless/iwlwifi/iwl-3945.c Fix type issue on
	64bit
From: "Darren Jenkins\\" <darrenrjenkins@gmail.com>
To: linville@tuxdriver.com
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       ipw2100-admin@linux.intel.com, yi.zhu@intel.com
Content-Type: text/plain; charset=UTF-8
Date: Thu, 03 Jul 2008 09:41:38 +1000
Message-Id: <1215042098.8635.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> What about the format line in the IWL_DEBUG_RX that uses rate?

I had figured that as rate was only positive it would work as is.
However you are dead right, there is no point in a patch removing one
example of bad programming only to introduce another.

Here is the updated patch:


Coverity CID: 2265 NEGATIVE_RETURNS

"rate" is of an unsigned type, and the code requires a signed type.
The following patch makes it so.

﻿﻿Signed-off-by: Darren Jenkins <darrenrjenkins@gmailcom>

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 62a3d8f..d97c025 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -449,7 +449,7 @@ static void iwl3945_dbg_report_frame(struct iwl3945_priv *priv,
 
 	if (print_summary) {
 		char *title;
-		u32 rate;
+		int rate;
 
 		if (hundred)
 			title = "100Frames";
@@ -487,7 +487,7 @@ static void iwl3945_dbg_report_frame(struct iwl3945_priv *priv,
 		 *    but you can hack it to show more, if you'd like to. */
 		if (dataframe)
 			IWL_DEBUG_RX("%s: mhd=0x%04x, dst=0x%02x, "
-				     "len=%u, rssi=%d, chnl=%d, rate=%u, \n",
+				     "len=%u, rssi=%d, chnl=%d, rate=%d, \n",
 				     title, fc, header->addr1[5],
 				     length, rssi, channel, rate);
 		else {


