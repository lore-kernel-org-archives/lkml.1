Return-Path: <linux-kernel-owner+w=401wt.eu-S1757662AbYHKVx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757662AbYHKVx1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 17:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753493AbYHKVxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 17:53:14 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38024
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753485AbYHKVxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 17:53:13 -0400
Date: Mon, 11 Aug 2008 14:53:13 -0700 (PDT)
Message-Id: <20080811.145313.178992274.davem@davemloft.net>
To: rdreier@cisco.com
Cc: rick.jones2@hp.com, jgarzik@pobox.com, swise@opengridcomputing.com,
       divy@chelsio.com, kxie@chelsio.com, netdev@vger.kernel.org,
       open-iscsi@googlegroups.com, michaelc@cs.wisc.edu, daisyc@us.ibm.com,
       wenxiong@us.ibm.com, bhua@us.ibm.com, dm@chelsio.com,
       leedom@chelsio.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/1] cxgb3i: cxgb3 iSCSI initiator
From: David Miller <davem@davemloft.net>
In-Reply-To: <adad4kfxm9v.fsf@cisco.com>
References: <48A08145.6060703@hp.com>
	<20080811.141254.165409473.davem@davemloft.net>
	<adad4kfxm9v.fsf@cisco.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 11 Aug 2008 14:41:16 -0700

>  > > Probably depends on whether or not the iSCSI offload solutions are doing 
>  > > zero-copy receive into the filecache?
>  > 
>  > That's a data placement issue, which also can be solved with
>  > stateless offloading.
> 
> How can you place iSCSI data properly with only stateless offloads?

By teaching the stateless offload how to parse the iSCSI headers
on the flow and place the data into pages at the correct offsets
such that you can place the pages hanging off of the SKB directly
into the page cache.
