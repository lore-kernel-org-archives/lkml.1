Return-Path: <linux-kernel-owner+w=401wt.eu-S1758611AbYBNCiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758611AbYBNCiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 21:38:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbYBNCiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 21:38:04 -0500
Received: from mga11.intel.com ([192.55.52.93]:53283 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752585AbYBNCiD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 21:38:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,349,1199692800"; 
   d="scan'208";a="518237261"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH][I/OAT]: Remove duplicate assignation in dma_skb_copy_datagram_iovec
Date: Wed, 13 Feb 2008 18:29:06 -0800
Message-ID: <BAE9DCEF64577A439B3A37F36F9B691C04040F39@orsmsx418.amr.corp.intel.com>
In-Reply-To: <47B35B88.5070300@inria.fr>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH][I/OAT]: Remove duplicate assignation in dma_skb_copy_datagram_iovec
Thread-Index: AchuhD5LZsmQaYFtSuSyqwtF/RKZLAALNwJw
References: <47B35B88.5070300@inria.fr>
From: "Nelson, Shannon" <shannon.nelson@intel.com>
To: "Brice Goglin" <Brice.Goglin@inria.fr>,
       "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "Leech, Christopher" <christopher.leech@intel.com>,
       "LKML" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 14 Feb 2008 02:29:07.0163 (UTC) FILETIME=[5F907AB0:01C86EB1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Brice Goglin [mailto:Brice.Goglin@inria.fr] 
>Sent: Wednesday, February 13, 2008 1:05 PM
>To: Nelson, Shannon; Williams, Dan J
>Cc: Leech, Christopher; LKML
>Subject: [PATCH][I/OAT]: Remove duplicate assignation in 
>dma_skb_copy_datagram_iovec
>
>[I/OAT]: Remove duplicate assignation in dma_skb_copy_datagram_iovec
>
>No need to compute copy twice in the frags loop in
>dma_skb_copy_datagram_iovec().
>
>Signed-off-by: Brice Goglin <Brice.Goglin@inria.fr>
>---
> user_dma.c |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/net/core/user_dma.c b/net/core/user_dma.c
>index 0ad1cd5..c77aff9 100644
>--- a/net/core/user_dma.c
>+++ b/net/core/user_dma.c
>@@ -75,7 +75,7 @@ int dma_skb_copy_datagram_iovec(struct 
>dma_chan *chan,
> 
> 		end = start + skb_shinfo(skb)->frags[i].size;
> 		copy = end - offset;
>-		if ((copy = end - offset) > 0) {
>+		if (copy > 0) {
> 			skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
> 			struct page *page = frag->page;
> 

Acked-by: Shannon Nelson <shannon.nelson@intel.com>
