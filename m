Return-Path: <linux-kernel-owner+w=401wt.eu-S1751706AbXBEQpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706AbXBEQpT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 11:45:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751719AbXBEQpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 11:45:19 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:44692 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbXBEQpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 11:45:17 -0500
In-Reply-To: <20070202195932.15b9b4ed@localhost.localdomain>
References: <patchbomb.1170193181@tetsuo.zabbo.net> <df7bc026d50ec5bbdd8e.1170193183@tetsuo.zabbo.net> <20070201083611.GC18233@elte.hu> <Pine.LNX.4.64.0702011154110.3632@woody.linux-foundation.org> <20070202104900.GA13941@elte.hu> <Pine.LNX.4.64.0702020738500.15057@woody.linux-foundation.org> <20070202195932.15b9b4ed@localhost.localdomain>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <202BD42A-0600-4A8A-87E3-4A237BAE6B41@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>
Content-Transfer-Encoding: 7bit
From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
Date: Mon, 5 Feb 2007 11:44:28 -0500
To: Alan <alan@lxorguk.ukuu.org.uk>
X-Mailer: Apple Mail (2.752.3)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Other questions really relate to the scheduling - Zach do you intend
> schedule_fibrils() to be a call code would make or just from  
> schedule() ?

I'd much rather keep the current sleeping API in as much as is  
possible.  So, yeah, if we can get schedule() to notice and behave  
accordingly I'd prefer that.  In the current code it's keyed off  
finding a stack allocation hanging off of current->.  If the caller  
didn't care about guaranteeing non-blocking submission then we  
wouldn't need that.. we could use a thread_info flag bit, or  
something.  Avoiding that allocation in the cached case would be nice.

> Alan (who used to use Co-routines in real languages on 36bit
> computers with 9bit bytes before learning C)

Yes, don't despair, I'm not co-routine ignorant.  In fact, I'm almost  
positive it was you who introduced them to me at some point in the  
previous millennium ;).

- z

