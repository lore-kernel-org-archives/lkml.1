Return-Path: <linux-kernel-owner+w=401wt.eu-S936433AbZDJGk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936433AbZDJGk1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 02:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758974AbZDJGkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 02:40:10 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:58340 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139AbZDJGkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 02:40:08 -0400
Message-ID: <49DEE9C2.1040500@in.ibm.com>
Date: Fri, 10 Apr 2009 12:10:02 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linuxppc-dev@ozlabs.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [CFQ/OOPS]  rb_erase with April 9 next tree
References: <20090409163305.8c7a0371.sfr@canb.auug.org.au> <49DE1969.1000709@in.ibm.com> <20090409172918.GE5178@kernel.dk> <20090409174420.GG5178@kernel.dk>
In-Reply-To: <20090409174420.GG5178@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
>
> Can you see if this fixes it for you?
>
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index e01b103..64de5c0 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -1654,6 +1654,7 @@ retry:
>  		}
>
>  		RB_CLEAR_NODE(&cfqq->rb_node);
> +		RB_CLEAR_NODE(&cfqq->p_node);
>  		INIT_LIST_HEAD(&cfqq->fifo);
>
>  		atomic_set(&cfqq->ref, 0);
>   
Yes. The above patch fixed this oops. Thanks

Regards
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

