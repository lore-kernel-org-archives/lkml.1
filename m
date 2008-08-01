Return-Path: <linux-kernel-owner+w=401wt.eu-S1755504AbYHAAwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504AbYHAAwn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 20:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbYHAAwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 20:52:30 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:4474 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbYHAAw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 20:52:29 -0400
From: Divy Le Ray <divy@chelsio.com>
Organization: Chelsio Communications
To: "Roland Dreier" <rdreier@cisco.com>
Subject: Re: [RFC][PATCH 1/1] cxgb3i: cxgb3 iSCSI initiator
Date: Thu, 31 Jul 2008 17:51:59 -0700
User-Agent: KMail/1.9.9
Cc: "Jeff Garzik" <jgarzik@pobox.com>, "Karen Xie" <kxie@chelsio.com>,
       netdev@vger.kernel.org, open-iscsi@googlegroups.com,
       davem@davemloft.net, michaelc@cs.wisc.edu,
       "Steve Wise" <swise@opengridcomputing.com>, daisyc@us.ibm.com,
       wenxiong@us.ibm.com, bhua@us.ibm.com,
       "Dimitrios Michailidis" <dm@chelsio.com>,
       "Casey Leedom" <leedom@chelsio.com>,
       "linux-scsi" <linux-scsi@vger.kernel.org>,
       "LKML" <linux-kernel@vger.kernel.org>
References: <200807300019.m6U0JkdY012558@localhost.localdomain> <4890C287.60508@pobox.com> <aday73jxdfs.fsf@cisco.com>
In-Reply-To: <aday73jxdfs.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807311752.00911.divy@chelsio.com>
X-OriginalArrivalTime: 01 Aug 2008 00:51:21.0359 (UTC) FILETIME=[B71591F0:01C8F370]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 July 2008 02:35:51 pm Roland Dreier wrote:
>  > * From a networking standpoint, our main concern becomes how this
>  > interacts with the networking stack.  In particular, I'm concerned
>  > based on reading the source that this driver uses "TCP port stealing"
>  > rather than using a totally separate MAC address (and IP).
>  >
>  > Stealing a TCP port on an IP/interface already assigned is a common
>  > solution in this space, but also a flawed one.  Precisely because the
>  > kernel and applications are unaware of this "special, magic TCP port"
>  > you open the potential for application problems that are very
>  > difficult for an admin to diagnose based on observed behavior.
>
> That's true, but using a separate MAC and IP opens up a bunch of other
> operational problems.  I don't think the right answer for iSCSI offload
> is clear yet.
>
>  - R.

Hi Jeff,

We've considered the approach of having a separate IP/MAC addresses to manage
iSCSI connections. In such a context, the stack would have to be unaware of
this iSCSI specific IP address. The iSCSI driver would then have to implement
at least its own ARP reply mechanism. DHCP too would have to be managed
separately. Most network setting/monitoring tools would also be unavailable.

The open-iscsi initiator is not a huge consumer of TCP connections, allocating
a TCP port from the stack would be reasonable in terms of resources in this
context. It is however unclear if it is an acceptable approach.

Our current implementation was designed to be the most tolerable one
within the constraints - real or expected - aforementioned.

Cheers,
Divy

