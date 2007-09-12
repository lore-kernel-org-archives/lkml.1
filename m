Return-Path: <linux-kernel-owner+w=401wt.eu-S970270AbXILSmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970270AbXILSmk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 14:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754641AbXILSmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 14:42:31 -0400
Received: from mail.fieldses.org ([66.93.2.214]:41772 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281AbXILSma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 14:42:30 -0400
Date: Wed, 12 Sep 2007 14:42:22 -0400
To: Neil Brown <neilb@suse.de>
Cc: Wolfgang Walter <wolfgang.walter@studentenwerk.mhn.de>,
       trond.myklebust@fys.uio.no, netdev@vger.kernel.org,
       nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [patch] sunrpc: make closing of old temporary sockets work
	(was: problems with lockd in 2.6.22.6)
Message-ID: <20070912184222.GG4274@fieldses.org>
References: <200709121407.11151.wolfgang.walter@studentenwerk.mhn.de> <18151.62510.891210.485277@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18151.62510.891210.485277@notabene.brown>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2007 at 04:14:06PM +0200, Neil Brown wrote:
> So it is in 2.6.21 and later and should probably go to .stable for .21
> and .22.
> 
> Bruce:  for you :-)

OK, thanks!  But, (as is alas often the case) I'm still confused:

>  		if (!test_and_set_bit(SK_OLD, &svsk->sk_flags))
>  			continue;
> -		if (atomic_read(&svsk->sk_inuse) || test_bit(SK_BUSY, &svsk->sk_flags))
> +		if (atomic_read(&svsk->sk_inuse) > 1
> +		    || test_bit(SK_BUSY, &svsk->sk_flags))
>  			continue;
>  		atomic_inc(&svsk->sk_inuse);
>  		list_move(le, &to_be_aged);

What is it that ensures svsk->sk_inuse isn't incremented or SK_BUSY set
after that test?  Not all the code that does either of those is under
the same serv->sv_lock lock that this code is.

--b.
