Return-Path: <linux-kernel-owner+w=401wt.eu-S1753353AbYIPHmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbYIPHmW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 03:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752402AbYIPHmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 03:42:10 -0400
Received: from mail.mellanox.co.il ([194.90.237.43]:48778 "EHLO mellanox.co.il"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752373AbYIPHmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 03:42:09 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Sep 2008 03:42:09 EDT
Date: Tue, 16 Sep 2008 10:36:32 +0300
From: Eli Cohen <eli@dev.mellanox.co.il>
To: netdev@vger.kernel.org, themann@de.ibm.com, linux-kernel@vger.kernel.org
Subject: LRO num of frags limit
Message-ID: <20080916073632.GA25226@mtls03>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-OriginalArrivalTime: 16 Sep 2008 07:35:24.0240 (UTC) FILETIME=[C7F82500:01C917CE]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-5.500.1027-16160.005
X-TM-AS-Result: No--8.956600-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

looking at the LRO code, at __lro_proc_segment(), it seems that the
network driver can configure lro_mgr->max_aggr to any value it wants
while the number of fragments aggregated must not exceed MAX_SKB_FRAGS
(since we only use a single SKB to aggregate fragments, allocated by
lro_gen_skb()). Moreover, even if the driver does limit
lro_mgr->max_aggr to MAX_SKB_FRAGS, it might still cause overflow
since subsequent aggregations are done at lro_add_frags() which is
called before checking whether we overflow.
If the above observation is correct, I can send a patch.

Thanks,
Eli
