Return-Path: <linux-kernel-owner+w=401wt.eu-S1757347AbZBKScu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347AbZBKScu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 13:32:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754785AbZBKScm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 13:32:42 -0500
Received: from smtp.opengridcomputing.com ([209.198.142.2]:49717 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751833AbZBKScl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 13:32:41 -0500
Message-ID: <499319CF.6050204@opengridcomputing.com>
Date: Wed, 11 Feb 2009 12:32:47 -0600
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: randy.dunlap@oracle.com, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [ofa-general] [PATCH 2.6.30] RDMA/cxgb3: Remove modulo math.
References: <20090210184448.22891.31130.stgit@dell3.ogc.int>	<adamyctajv8.fsf@cisco.com> <4992F26A.4030800@opengridcomputing.com> <adatz70972e.fsf@cisco.com>
In-Reply-To: <adatz70972e.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
>  > Note that wr->sg_list[i].addr was being cast to a u32.  That was wrong.
>
> Is it possible for the page to be bigger than 4GB?  If so then yes you
> might be chopping off high-order bits or something.
>   
Yes it is possible.

A MR can be created with an iov_base of say 0xffffffff00000000.

Then any sge.addr entries would be the iob_base + any offset.

> Anyway please send me this change as a separate patch with a changelog
> explaining that you're avoiding the div etc.... I don't want to roll it
> in with the other unrelated fix (which changes code that was never
> upstream anyway).
>   

will do. 

So you are handling the offset patch that will make it u64 and remove 
the mod usage, correct?

I will post a new patch with just this send change.

Steve.
