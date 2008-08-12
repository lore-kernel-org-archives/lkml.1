Return-Path: <linux-kernel-owner+w=401wt.eu-S1754890AbYHLV6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890AbYHLV6s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 17:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754580AbYHLV62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 17:58:28 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:17516 "EHLO
	stargate.asicdesigners.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754235AbYHLV60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 17:58:26 -0400
From: Divy Le Ray <divy@chelsio.com>
Organization: Chelsio Communications
To: "David Miller" <davem@davemloft.net>
Subject: Re: [RFC][PATCH 1/1] cxgb3i: cxgb3 iSCSI initiator
Date: Tue, 12 Aug 2008 14:57:09 -0700
User-Agent: KMail/1.9.9
Cc: rdreier@cisco.com, rick.jones2@hp.com, jgarzik@pobox.com,
       "Steve Wise" <swise@opengridcomputing.com>,
       "Karen Xie" <kxie@chelsio.com>, netdev@vger.kernel.org,
       open-iscsi@googlegroups.com, michaelc@cs.wisc.edu, daisyc@us.ibm.com,
       wenxiong@us.ibm.com, bhua@us.ibm.com,
       "Dimitrios Michailidis" <dm@chelsio.com>,
       "Casey Leedom" <leedom@chelsio.com>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <48A08145.6060703@hp.com> <adad4kfxm9v.fsf@cisco.com> <20080811.145313.178992274.davem@davemloft.net>
In-Reply-To: <20080811.145313.178992274.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808121457.11356.divy@chelsio.com>
X-OriginalArrivalTime: 12 Aug 2008 21:56:54.0906 (UTC) FILETIME=[558C95A0:01C8FCC6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 August 2008 02:53:13 pm David Miller wrote:
> From: Roland Dreier <rdreier@cisco.com>
> Date: Mon, 11 Aug 2008 14:41:16 -0700
>
> >  > > Probably depends on whether or not the iSCSI offload solutions are
> >  > > doing zero-copy receive into the filecache?
> >  >
> >  > That's a data placement issue, which also can be solved with
> >  > stateless offloading.
> >
> > How can you place iSCSI data properly with only stateless offloads?
>
> By teaching the stateless offload how to parse the iSCSI headers
> on the flow and place the data into pages at the correct offsets
> such that you can place the pages hanging off of the SKB directly
> into the page cache.

Hi Dave,

iSCSI PDUs might spawn over multiple TCP segments, it is unclear to me how to 
do placement without keeping some state of the transactions.

In any case, such a stateless solution is not yet designed, whereas 
accelerated iSCSI is available now, from us and other companies.
The accelerated iSCSI streams benefit from the performance TOE provides, 
outlined in the following third party papers:
http://www.chelsio.com/assetlibrary/pdf/redhat-chelsio-toe-final_v2.pdf
http://www.chelsio.com/assetlibrary/pdf/RMDS6BNTChelsioRHEL5.pdf

iSCSI is primarily targeted to the data center, where the SW stack's traffic 
shaping features might be redundant with specialized equipment. It should 
however be possible to integrate security features on a per offoaded 
connection basis, and TOEs - at least ours :) - are capable of rate control 
and traffic shaping.

While CPU and - to a far lesser extent - memory performance improves, so does 
ethernet's. 40G, 100G are not too far ahead. It is not obvious at all that 
TOE is a point of time solution, especially for heavy load traffic as in a 
storage environment. It is quite the opposite actually.

There is room for co-existence of the SW managed traffic and accelerated 
traffic. As our submission shows, enabling accelerated iSCSI is not intrusive 
code wise to the stack. The port stealing issue is solved if we can grab a 
port from the stack.

Cheers,
Divy
