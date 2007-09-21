Return-Path: <linux-kernel-owner+w=401wt.eu-S1759916AbXIUPbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759916AbXIUPbm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 11:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754817AbXIUPbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 11:31:34 -0400
Received: from 209-198-142-2-host.prismnet.net ([209.198.142.2]:46039 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752986AbXIUPbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 11:31:33 -0400
X-Greylist: delayed 1248 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Sep 2007 11:31:33 EDT
Message-ID: <46F3DEF6.3010404@opengridcomputing.com>
Date: Fri, 21 Sep 2007 10:10:46 -0500
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
CC: rdreier@cisco.com, sean.hefty@intel.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [PATCH v2] iw_cxgb3: Support "iwarp-only" interfaces to avoid
 4-tuple conflicts.
References: <20070913191617.30937.95960.stgit@dell3.ogc.int> <20070914130941.GG18517@2ka.mipt.ru> <46EC00BE.3020801@opengridcomputing.com> <20070916142241.GA26848@2ka.mipt.ru> <46EE9C50.7070406@opengridcomputing.com> <20070919105612.GA31158@2ka.mipt.ru>
In-Reply-To: <20070919105612.GA31158@2ka.mipt.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Evgeniy Polyakov wrote:
> Hi Steve.
> 
> On Mon, Sep 17, 2007 at 10:25:04AM -0500, Steve Wise (swise@opengridcomputing.com) wrote:
>>> Does creating the whole new netdevice is a too big overhead, or is it
>>> considered bad idea?
>> I think its too big overhead, and pretty invasive on the low level cxgb3 
>> driver.  I think having a device in the 'ifconfig -a' after iw_cxgb3 is 
>> loaded and devices discovered would be a good thing for the admin.  This 
>> is the angle Roland suggested.  I'm just not sure how to implement it.
>>
>> But if someone could explain how I might create this full netdevice as a 
>> pseudo device on top of the real one, maybe I could implement it.
>>
>> Note that non TCP traffic still needs to utilize this interface for ND 
>> to work properly with the RDMA core.
> 
> Just a though - what about allowing secondary addresses with the same
> address as main one? I.e. change bit of the core code to allow creating
> aliases with the same address as main device, so that you would be able
> to create ':iw' alias during rdma device initialization?
> 

The problem is that on rdma route/address resolution the rdma core CM 
uses the routing table to look up which local device to use.  So what we 
need is separate ip subnets for rdma vs non rdma tcp.

Also, to avoid the original issue of 4-tuple conflicts, the rdma device 
_must_ listen on specific local "rdma-only" ip addresses and thus they 
must be not the same address as that used for native host tcp traffic.

Steve.
