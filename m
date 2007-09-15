Return-Path: <linux-kernel-owner+w=401wt.eu-S1755026AbXIOOHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026AbXIOOHZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 10:07:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751236AbXIOOHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 10:07:08 -0400
Received: from smtp.opengridcomputing.com ([71.42.183.126]:38745 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751053AbXIOOHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 10:07:07 -0400
Message-ID: <46EBE70A.6040901@opengridcomputing.com>
Date: Sat, 15 Sep 2007 09:07:06 -0500
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Sean Hefty <mshefty@ichips.intel.com>
CC: rdreier@cisco.com, sean.hefty@intel.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [ofa-general] [PATCH v2] iw_cxgb3: Support "iwarp-only" interfaces
 to avoid 4-tuple conflicts.
References: <20070913191617.30937.95960.stgit@dell3.ogc.int> <46E99586.90905@ichips.intel.com>
In-Reply-To: <46E99586.90905@ichips.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Sean Hefty wrote:
>> The iWARP driver must translate all listens on address 0.0.0.0 to the
>> set of rdma-only ip addresses for the device in question.  This prevents
>> incoming connect requests to the TCP ipaddresses from going up the
>> rdma stack.
> 
> I've only given this a high level review at this point, and while the 
> patch looks okay on first pass, is there a way to move some of this 
> functionality to either the rdma_cm or iw_cm?  I don't like the idea of 
> every iwarp driver having to implement address/listen list maintenance. 
>  I may have some ideas after re-examining it.

I think the translating of listen requests from 0.0.0.0->specific 
addresses could be moved to the iwcm...

> 
>> Implementation Details:
> 
> There are a couple of areas that I made a note to look at in more detail 
> (because I didn't understand everything that was happening), but I did 
> have one minor nit - most uses of list_del_init can just be list_del.
> 

Ok.

