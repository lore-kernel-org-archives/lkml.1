Return-Path: <linux-kernel-owner+w=401wt.eu-S1752888Ab0AZDsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888Ab0AZDsh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 22:48:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751868Ab0AZDsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 22:48:36 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:33902 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817Ab0AZDsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 22:48:35 -0500
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAEb0XUurR7H+/2dsb2JhbADCe5ZuhDkE
X-IronPort-AV: E=Sophos;i="4.49,344,1262563200"; 
   d="scan'208";a="472833631"
From: Roland Dreier <rdreier@cisco.com>
To: Alex Chiang <achiang@hp.com>
Cc: linux-rdma@vger.kernel.org, justin.chen@hp.com,
       linux-kernel@vger.kernel.org
Subject: Re: infiniband limit of 32 cards per system?
References: <20100125235013.GD2828@grease.ALLEYCAT>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 25 Jan 2010 19:48:28 -0800
In-Reply-To: <20100125235013.GD2828@grease.ALLEYCAT> (Alex Chiang's message of
	"Mon, 25 Jan 2010 16:50:13 -0700")
Message-ID: <adaiqapplv7.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 26 Jan 2010 03:48:31.0843 (UTC) FILETIME=[6DA6F330:01CA9E3A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > My colleague points out the following enum in uverbs_main.c:
 > 
 > 	enum {
 > 		IB_UVERBS_MAJOR       = 231,
 > 		IB_UVERBS_BASE_MINOR  = 192,
 > 		IB_UVERBS_MAX_DEVICES = 32
 > 	};
 > 
 > Experimentally, we've determined that on a system where we
 > plugged in 40 IB cards, OFED only reports 32 cards are present.

wow, 40 HCAs in one system !

 > If that enum is indeed the limiting factor, would someone mind
 > explaining (or pointing me at TFM ;) why it's limited to 32
 > devices?

That dates back to when device #s had 8 bits for major and 8 bits for
minor.  We got one major assigned for IB, and had to split up the 256
minors that gave us among userspace verbs, management access, etc.  And
32 seemed like a pretty reasonable limit for most uses.

Nowadays I guess we should look into expanding that to dynamic device
numbers on overflow, assuming you do have a realistic situation where
someone would want to use that many adapters per system.

 - R.
