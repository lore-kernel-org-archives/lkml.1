Return-Path: <linux-kernel-owner+w=401wt.eu-S1758184AbYHHSIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758184AbYHHSIY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 14:08:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752489AbYHHSIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 14:08:11 -0400
Received: from smtp.opengridcomputing.com ([209.198.142.2]:49517 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750954AbYHHSIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 14:08:09 -0400
Message-ID: <489C8BEB.8060001@opengridcomputing.com>
Date: Fri, 08 Aug 2008 13:09:47 -0500
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Divy Le Ray <divy@chelsio.com>, Jeff Garzik <jgarzik@pobox.com>,
       davem@davemloft.net
CC: Roland Dreier <rdreier@cisco.com>, Karen Xie <kxie@chelsio.com>,
       netdev@vger.kernel.org, open-iscsi@googlegroups.com,
       michaelc@cs.wisc.edu, daisyc@us.ibm.com, wenxiong@us.ibm.com,
       bhua@us.ibm.com, Dimitrios Michailidis <dm@chelsio.com>,
       Casey Leedom <leedom@chelsio.com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 1/1] cxgb3i: cxgb3 iSCSI initiator
References: <200807300019.m6U0JkdY012558@localhost.localdomain> <aday73jxdfs.fsf@cisco.com> <200807311752.00911.divy@chelsio.com> <200808071145.03848.divy@chelsio.com>
In-Reply-To: <200808071145.03848.divy@chelsio.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Hi Jeff,
>
> Mike Christie will not merge this code until he has an explicit 
> acknowledgement from netdev.
>
> As you mentioned, the port stealing approach we've taken has its issues.
> We consequently analyzed your suggestion to use a different IP/MAC address for 
> iSCSI and it raises other tough issues (separate ARP and DHCP management, 
> unavailability of common networking tools).
> On these grounds, we believe our current approach is the most tolerable.
> Would the stack provide a TCP port allocation service, we'd be glad to use it 
> to solve the current concerns.
> The cxgb3i driver is up and running here, its merge is pending our decision.
>
> Cheers,
> Divy
>   
Hey Dave/Jeff,

I think we need some guidance here on how to proceed.   Is the approach 
currently being reviewed ACKable?  Or is it DOA? If its DOA, then what 
approach do you recommend?  I believe Jeff's opinion is a separate 
ipaddr.  But Dave, what do you think?  Lets get some agreement on a high 
level design here. 

Possible solutions seen to date include:

1) reserving a socket to allocate the port.  This has been NAK'd in the 
past and I assume is still a no go.

2) creating a 4-tuple allocation service so the host stack, the rdma 
stack, and the iscsi stack can share the same TCP 4-tuple space.  This 
also has been NAK'd in the past and I assume is still a no go.

3) the iscsi device allocates its own local ephemeral posts (port 
stealing) and use the host's ip address for the iscsi offload device.  
This is the current proposal and you can review the thread for the pros 
and cons.  IMO it is the least objectionable (and I think we really 
should be doing #2).

4) the iscsi device will manage its own ip address thus ensuring 4-tuple 
uniqueness.

Unless you all want to re-open considering #1 or #2, then we're left 
with 3 or 4.  Which one?

Steve.
