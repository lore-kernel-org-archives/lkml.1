Return-Path: <linux-kernel-owner+w=401wt.eu-S1753314AbZLKM22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbZLKM22 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 07:28:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751399AbZLKM2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 07:28:24 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:38374 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952AbZLKM2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 07:28:23 -0500
Subject: [PATCH v2 0/4] Defer skb allocation for both mergeable buffers and
 big packets in virtio_net
From: Shirley Ma <mashirle@us.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Avi Kivity <avi@redhat.com>,
       netdev@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Anthony Liguori <anthony@codemonkey.ws>
In-Reply-To: <20091208122134.GA17286@redhat.com>
References: <1258697359.7416.14.camel@localhost.localdomain>
	 <200911231123.18898.rusty@rustcorp.com.au>
	 <20091208122134.GA17286@redhat.com>
Content-Type: text/plain
Date: Fri, 11 Dec 2009 04:28:26 -0800
Message-Id: <1260534506.30371.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch-set for deferring skb allocation based on Rusty and
Michael's inputs.

Guest virtio_net receives packets from its pre-allocated vring 
buffers, then it delivers these packets to upper layer protocols
as skb buffs. So it's not necessary to pre-allocate skb for each
mergable buffer, then frees it when it's useless. 

This patch has deferred skb allocation when receiving packets for
both big packets and mergeable buffers. It reduces skb pre-allocations 
and skb_frees.

A destroy function has been created to push virtio free buffs to vring
for unused pages, and used page private to maintain page list.

This patch has tested and measured against 2.6.32-rc7 git. It is built
again 2.6.32 kernel. Tests have been done for small packets, big packets
and mergeable buffers.

The single netperf TCP_STREAM performance improved for host to guest. 
It also reduces UDP packets drop rate.

Thanks
Shirley

