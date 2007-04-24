Return-Path: <linux-kernel-owner+w=401wt.eu-S1161411AbXDXHfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161411AbXDXHfZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 03:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161696AbXDXHfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 03:35:25 -0400
Received: from mail29.messagelabs.com ([216.82.249.147]:42704 "HELO
	mail29.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1161411AbXDXHfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 03:35:24 -0400
X-VirusChecked: Checked
X-Env-Sender: EU.ML.linux-kernel@digi.com
X-Msg-Ref: server-19.tower-29.messagelabs.com!1177400122!38876197!1
X-StarScan-Version: 5.5.10.7.1; banners=-,-,-
X-Originating-IP: [66.77.174.21]
Message-ID: <462DB3E1.4040504@digi.com>
Date: Tue, 24 Apr 2007 09:38:09 +0200
From: Markus Pietrek <eu.ml.linux-kernel@digi.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070104)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] i802.11: fixed memory leak on multicasts
Content-Type: multipart/mixed;
 boundary="------------070002080801080901020002"
X-OriginalArrivalTime: 24 Apr 2007 07:35:30.0432 (UTC) FILETIME=[2292B800:01C78643]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070002080801080901020002
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

socket buffers were not always freed when receiving multicasts

Bye,
-- 
Markus Pietrek
Lead Software Engineer
Phone: +49-7667-908-501, Fax: +49-7667-908-200
mailto:markus.pietrek@digi.com

FS Forth-Systeme GmbH
"A Digi International Company"
Kueferstr. 8, 79206 Breisach, Germany
Tax: 07008/12000 / VAT: DE142208834 / Reg. Amtsgericht Freiburg HRB 290212
Directors: Klaus Flesch, Subramanian Krishnan, Dieter Vesper
http://www.digi.com

--------------070002080801080901020002
Content-Type: text/plain;
 name="patch_memleak_80211.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch_memleak_80211.txt"

Index: net/ieee80211/ieee80211_rx.c
===================================================================
RCS file: /data/vcs/cvs/fsforth_products/LxNETES/linux/net/ieee80211/ieee80211_rx.c,v
retrieving revision 1.5
retrieving revision 1.6
diff -c -r1.5 -r1.6
*** net/ieee80211/ieee80211_rx.c	13 Apr 2007 12:39:38 -0000	1.5
--- net/ieee80211/ieee80211_rx.c	23 Apr 2007 15:51:28 -0000	1.6
***************
*** 860,868 ****
  		break;
  	}
  
! 	if (is_packet_for_us)
  		if (!ieee80211_rx(ieee, skb, stats))
  			dev_kfree_skb_irq(skb);
  	return;
  
  drop_free:
--- 860,871 ----
  		break;
  	}
  
! 	if (is_packet_for_us) {
  		if (!ieee80211_rx(ieee, skb, stats))
  			dev_kfree_skb_irq(skb);
+         } else
+                 dev_kfree_skb_irq(skb);
+         
  	return;
  
  drop_free:

--------------070002080801080901020002--
