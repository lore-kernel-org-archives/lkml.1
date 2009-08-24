Return-Path: <linux-kernel-owner+w=401wt.eu-S1752075AbZHXJgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075AbZHXJgP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 05:36:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751516AbZHXJgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 05:36:14 -0400
Received: from mail.windriver.com ([147.11.1.11]:60654 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbZHXJgN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 05:36:13 -0400
Subject: Re: [PATCH] sctp: fix the check for path failure detection
From: Luo Chunbo <chunbo.luo@windriver.com>
To: Wei Yongjun <yjwei@cn.fujitsu.com>
Cc: Vlad Yasevich <vladislav.yasevich@hp.com>, davem@davemloft.net,
       netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <4A924734.6000702@cn.fujitsu.com>
References: <1250838275-7444-1-git-send-email-chunbo.luo@windriver.com>
	 <4A8F15F5.3020901@hp.com> <1251080117.6513.11.camel@pek-cluo-desktop>
	 <4A924734.6000702@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Date: Mon, 24 Aug 2009 17:35:20 +0800
Message-Id: <1251106520.6513.51.camel@pek-cluo-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
X-OriginalArrivalTime: 24 Aug 2009 09:36:01.0781 (UTC) FILETIME=[4B27C250:01CA249E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-24 at 15:54 +0800, Wei Yongjun wrote:
> Luo Chunbo 写道:
> > On Fri, 2009-08-21 at 17:47 -0400, Vlad Yasevich wrote:
> >   
> >> Chunbo Luo wrote:
> >>     
> >>> The transport is marked DOWN immediately after sending the max+1 HB,
> >>> which is equal to not sending the max+1 HB at all. We should wait
> >>> a next period and make sure the last HB is not acknowledged.
> >>>
> >>>       
> >> I don't think this code does what you want either...
> >>
> >> Let's say path_max_rxt = 2.  What we'll get is:
> >> 	timeout:
> >> 		err++ (1)
> >> 		if (err > 2) false
> >> 		send HB
> >> 		reset timer
> >> 	timeout:
> >> 		err++ (2)
> >> 		if (err > 2) false
> >> 		send HB
> >> 		reset timer
> >> 	timeout:
> >> 		err++ (3)
> >> 		if (err > 2)
> >> 			set transport DOWN
> >> 		send HB
> >> 		reset timer.
> >>
> >> We only had 2 unacknowledged HB when we should have had 3.
> >>     
> >
> > The error count is increment after the HB was sent, and the error count
> > check is before sending HB.
> >
> > Let's say path_max_rxt =2 . What we really get is:
> >
> > timeout:
> > 	if( err > 2) false
> > 	send HB
> > 	err++ (1)
> > 	reset timer
> > timeout:
> > 	if( err > 2) false
> > 	send HB
> > 	err++ (2)
> > 	reset timer
> > timeout:
> > 	if( err > 2) false
> > 	send HB
> > 	err++ (3)
> > 	reset timer
> > timeout:
> > 	if( err > 2)
> > 		set transport DOWN
> > 	send HB
> > 	reset timer
> >
> > Here We had 3 unacknowledged HBs
> 
> 
> But with Vlad's advice, you just need to do little change to the kernel
> codes, may be two lines's patch, and it can do the same thing.


OK, I'll send a new patch later.


> 
> 
> 
