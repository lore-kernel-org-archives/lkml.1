Return-Path: <linux-kernel-owner+w=401wt.eu-S1758519AbZBKSot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758519AbZBKSot (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 13:44:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757939AbZBKSok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 13:44:40 -0500
Received: from smtp.opengridcomputing.com ([209.198.142.2]:34328 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756137AbZBKSoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 13:44:39 -0500
Message-ID: <49931C9D.2090604@opengridcomputing.com>
Date: Wed, 11 Feb 2009 12:44:45 -0600
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: randy.dunlap@oracle.com, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [ofa-general] [PATCH 2.6.30] RDMA/cxgb3: Remove modulo math.
References: <20090210184448.22891.31130.stgit@dell3.ogc.int>	<adamyctajv8.fsf@cisco.com> <4992F26A.4030800@opengridcomputing.com>	<adatz70972e.fsf@cisco.com> <499319CF.6050204@opengridcomputing.com> <adak57w95ym.fsf@cisco.com>
In-Reply-To: <adak57w95ym.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
>  > > Is it possible for the page to be bigger than 4GB?  If so then yes you
>  > > might be chopping off high-order bits or something.
>
>  > Yes it is possible.
>  > 
>  > A MR can be created with an iov_base of say 0xffffffff00000000.
>  > 
>  > Then any sge.addr entries would be the iob_base + any offset.
>
> But the code we're talking about is:
>
> 		/* to in the WQE == the offset into the page */
> 		wqe->recv.sgl[i].to = cpu_to_be64(((u32) wr->sg_list[i].addr) %
> 				(1UL << (12 + page_size[i])));
>
> so it seems the top address bits don't matter unless page_size[i] is at
> least 20 -- in which case using 1UL to shift overflows on 32 bits anyway...
>
>   

Yes yes...you're right.   This code is really just saving the offset in 
a page.

I'll send a new patch.

