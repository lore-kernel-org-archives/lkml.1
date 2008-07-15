Return-Path: <linux-kernel-owner+w=401wt.eu-S1763107AbYGOTnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763107AbYGOTnt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 15:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755402AbYGOTnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 15:43:40 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:45484 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346AbYGOTnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 15:43:39 -0400
X-IronPort-AV: E=Sophos;i="4.30,368,1212364800"; 
   d="scan'208";a="127083994"
From: Roland Dreier <rdreier@cisco.com>
To: "Or Gerlitz" <or.gerlitz@gmail.com>
Cc: linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [ofa-general] ***SPAM*** InfiniBand/RDMA merge plans for 2.6.27
References: <ada8ww5jbaf.fsf@cisco.com> <487B820E.4020002@mellanox.co.il>
	<adahcarezdy.fsf@cisco.com>
	<15ddcffd0807151220m37204055rf6890037b445bd34@mail.gmail.com>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 15 Jul 2008 12:36:32 -0700
In-Reply-To: <15ddcffd0807151220m37204055rf6890037b445bd34@mail.gmail.com> (Or
	Gerlitz's message of "Tue, 15 Jul 2008 22:20:56 +0300")
Message-ID: <ada7ibndjnj.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 15 Jul 2008 19:36:32.0726 (UTC) FILETIME=[15F8E760:01C8E6B2]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > So just to make sure, firmware 2.5 does not support IB BMME and if I want to
 > test with this patch I need to get a special firmware drop from Mellanox?

Right: in the test

+	if ((dev->dev->caps.bmme_flags & MLX4_BMME_FLAG_LOCAL_INV) &&
+	    (dev->dev->caps.bmme_flags & MLX4_BMME_FLAG_REMOTE_INV) &&
+	    (dev->dev->caps.bmme_flags & MLX4_BMME_FLAG_FAST_REG_WR))
+		props->device_cap_flags |= IB_DEVICE_MEM_MGT_EXTENSIONS;

you will see that not all the bmme_flags required are set by FW 2.5.
