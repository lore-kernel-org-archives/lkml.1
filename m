Return-Path: <linux-kernel-owner+w=401wt.eu-S933535AbYBMQ4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933535AbYBMQ4A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 11:56:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762727AbYBMQzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 11:55:50 -0500
Received: from mga02.intel.com ([134.134.136.20]:13530 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757882AbYBMQzt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 11:55:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,347,1199692800"; 
   d="scan'208";a="257752426"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] ipw2200: le*_add_cpu conversion
Date: Wed, 13 Feb 2008 08:54:48 -0800
Message-ID: <D936D925018D154694D8A362EEB0892003A7F5B9@orsmsx416.amr.corp.intel.com>
In-Reply-To: <1202857582-15450-8-git-send-email-marcin.slusarz@gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] ipw2200: le*_add_cpu conversion
Thread-Index: Achtzjb7g9dljZeQT4i0s3VW95D79gAkq+cg
References: <1202857582-15450-1-git-send-email-marcin.slusarz@gmail.com> <1202857582-15450-8-git-send-email-marcin.slusarz@gmail.com>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: <marcin.slusarz@gmail.com>, "LKML" <linux-kernel@vger.kernel.org>
Cc: "Zhu, Yi" <yi.zhu@intel.com>, "John W. Linville" <linville@tuxdriver.com>,
       <linux-wireless@vger.kernel.org>
X-OriginalArrivalTime: 13 Feb 2008 16:54:49.0421 (UTC) FILETIME=[25264FD0:01C86E61]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 12, 2008 3:06 PM,
linux-wireless-owner@vger.kernel.org  wrote:

> From: Marcin Slusarz <marcin.slusarz@gmail.com>
> 
> replace all:
> little_endian_variable =
> cpu_to_leX(leX_to_cpu(little_endian_variable) +
> 					expression_in_cpu_byteorder);
> with:
> 	leX_add_cpu(&little_endian_variable,
> expression_in_cpu_byteorder);
> generated with semantic patch
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Zhu Yi <yi.zhu@intel.com>
> Cc: John W. Linville <linville@tuxdriver.com>
> Cc: linux-wireless@vger.kernel.org
> ---
> drivers/net/wireless/ipw2200.c |    4 +---
> 1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/ipw2200.c
> b/drivers/net/wireless/ipw2200.c
> index 3e6ad7b..5d9854e 100644
> --- a/drivers/net/wireless/ipw2200.c
> +++ b/drivers/net/wireless/ipw2200.c
> @@ -10326,9 +10326,7 @@ static int ipw_tx_skb(struct ipw_priv
> *priv, struct ieee80211_txb *txb,
> 					 remaining_bytes,
> 					 PCI_DMA_TODEVICE));
> 
> -			tfd->u.data.num_chunks =
> -
> cpu_to_le32(le32_to_cpu(tfd->u.data.num_chunks) +
> -					1);
> +			le32_add_cpu(&tfd->u.data.num_chunks, 1);
> 		}
> 	}
> 
> --
> 1.5.3.7

Thanks!

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette

