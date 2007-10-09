Return-Path: <linux-kernel-owner+w=401wt.eu-S1755321AbXJIOPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbXJIOPl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 10:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751854AbXJIOPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 10:15:34 -0400
Received: from 209-198-142-2-host.prismnet.net ([209.198.142.2]:57592 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752122AbXJIOPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 10:15:33 -0400
Message-ID: <470B8D04.30401@opengridcomputing.com>
Date: Tue, 09 Oct 2007 09:15:32 -0500
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: Re: [ofa-general] Updated InfiniBand/RDMA merge plans for 2.6.24
References: <adaodfdkv59.fsf@cisco.com>	<47090708.6060604@opengridcomputing.com> <adair5hjh64.fsf@cisco.com>
In-Reply-To: <adair5hjh64.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Roland Dreier wrote:
>  > No mention about the iwarp port space issue?
> 
> I don't think we're at a stage where I'm prepared to merge something--
> we all agree the latest patch has serious drawbacks, and it commits us
> to a suboptimal interface that is userspace-visible.
> 

Fair enough.

>  > I'm at a loss as to how to proceed.
> 
> Could we try to do some cleanups to the net core to make the alias
> stuff less painful?  eg is there any sane way to make it possible for
> a device that creates 'eth0' to also create an 'iw0' alias without an
> assigning an address?
> 

Well, "alias" interfaces really don't exist.  ethX:iw is really just 
adding a address record (struct in_ifaddr) to ethX.  So in the current 
core design, adding an alias without an address is really adding the 
alias with address 0.0.0.0.  And I think the core net code assumes if an 
in_ifaddr struct exists for a device, then its IP address is indeed valid.

So I think the changes wouldn't be small to enhance the design to add a 
concept of an alias interface.

I'll look into this more though.

Steve.

