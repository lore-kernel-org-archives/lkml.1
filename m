Return-Path: <linux-kernel-owner+w=401wt.eu-S1760972AbYJITXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760972AbYJITXd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 15:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757993AbYJITXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 15:23:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57049 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758965AbYJITXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 15:23:19 -0400
Date: Thu, 9 Oct 2008 12:22:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: splice vs O_APPEND
In-Reply-To: <E1KnyOw-00044y-K4@pomaz-ex.szeredi.hu>
Message-ID: <alpine.LFD.2.00.0810091218300.3210@nehalem.linux-foundation.org>
References: <E1Knx26-0003ds-Ch@pomaz-ex.szeredi.hu> <alpine.LFD.2.00.0810090830170.3210@nehalem.linux-foundation.org> <E1Knxzm-0003y2-Jy@pomaz-ex.szeredi.hu> <alpine.LFD.2.00.0810090908200.3210@nehalem.linux-foundation.org>
 <E1KnyOw-00044y-K4@pomaz-ex.szeredi.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 9 Oct 2008, Miklos Szeredi wrote:
> 
> We know that nobody is currently relying on O_APPEND semantics with
> splice, so this should be OK.

Having now realized that apparently you can't rely on O_APPEND for 
anything but plain write _anyway_ (ie pwrite shouldn't honor it), I'm 
going to drop this thing as "let's think about it more".

Maybe the right thing to do is to just say that O_APPEND (and IS_APPEND) 
is really not as reliable as people might expect, and just say that the 
only thing it affects is a plain write() system call. 

Of course, I think POSIX is crazy, and we probably _should_ always honor 
O_APPEND, and returning -EINVAL is the right thing for both pwrite and 
splice, but this is all a murkier issue than it looked like originally, 
and any possible "security" implications are dubious in that you cannot 
really depend on O_APPEND/IS_APPEND anyway.

		Linus
