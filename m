Return-Path: <linux-kernel-owner+w=401wt.eu-S1761173AbYD0QpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761173AbYD0QpK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 12:45:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753648AbYD0Qo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 12:44:59 -0400
Received: from smtp.opengridcomputing.com ([209.198.142.2]:48006 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752530AbYD0Qo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 12:44:58 -0400
Message-ID: <4814AD7B.2060006@opengridcomputing.com>
Date: Sun, 27 Apr 2008 11:44:43 -0500
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: netdev@vger.kernel.org, divy@chelsio.com, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Subject: Re: [ofa-general] [PATCH 2.6.26 3/3] RDMA/cxgb3: Support peer-2-peer
 connection setup.
References: <20080427155456.31018.22282.stgit@dell3.ogc.int>	<20080427160010.31018.67436.stgit@dell3.ogc.int> <adatzhn2r5z.fsf@cisco.com>
In-Reply-To: <adatzhn2r5z.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Roland Dreier wrote:
> What are the interoperability implications of this?
> 
> Looking closer I see that iw_nes has the send_first module parameter.
> How does this interact with that?
> 

It doesn't...yet.  But we wanted to enable these applications for 
chelsio now and get the low level fw and driver changes done first and 
tested.

> I guess it's fine to apply this, but do we have a plan for how we want
> to handle this issue in the long-term?
> 

Yes!  If you'll recall, we had a thread on the ofa general list 
discussing how to enhance the MPA negotiation so peers can indicate 
whether they want/need the RTR and what type of RTR (0B read, 0B write, 
or 0B send) should be sent.  This will be done by standardizing a few 
bits of the private data in order to negotiate all this.  The rdma-cma 
API will be extended so applications will have to request this 
peer-2-peer model since it adds overhead to the connection setup.

I plan to do this work for 2.6.27/ofed-1.4.  I think it was listed in 
Felix's talk at Sonoma.  This work (design, API, and code changes 
affecting core and placing requirements on iwarp providers) will be 
posted as RFC changes to get everyones feedback as soon as I get 
something going.

Does that sound ok?


Steve.
