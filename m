Return-Path: <linux-kernel-owner+w=401wt.eu-S1756893AbZBKBEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893AbZBKBEO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 20:04:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752341AbZBKBD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 20:03:58 -0500
Received: from smtp.opengridcomputing.com ([209.198.142.2]:57782 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752103AbZBKBD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 20:03:57 -0500
Message-ID: <499223F8.1010204@opengridcomputing.com>
Date: Tue, 10 Feb 2009 19:03:52 -0600
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: randy.dunlap@oracle.com, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [ofa-general] [PATCH 2.6.30] RDMA/cxgb3: Remove modulo math.
References: <20090210184448.22891.31130.stgit@dell3.ogc.int> <adamyctajv8.fsf@cisco.com>
In-Reply-To: <adamyctajv8.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
> I'll roll this into the offending patch (that is in -next).
>
> But:
>
>  > -		wqe->recv.sgl[i].to = cpu_to_be64(((u32) wr->sg_list[i].addr) %
>  > -				(1UL << (12 + page_size[i])));
>  > +		wqe->recv.sgl[i].to = cpu_to_be64(((u64) wr->sg_list[i].addr) &
>  > +				((1UL << (12 + page_size[i]))-1));
>
> Is this required?  Strength reduction optimization should do this
> automatically (and the code has been there for quite a while, so
> obviously it isn't causing problems)
>
>  - R.
>   
Ok.
