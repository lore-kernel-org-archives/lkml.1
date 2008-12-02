Return-Path: <linux-kernel-owner+w=401wt.eu-S1755408AbYLBTYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbYLBTYY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 14:24:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbYLBTYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 14:24:13 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36680 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751886AbYLBTYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 14:24:13 -0500
Date: Tue, 2 Dec 2008 11:23:42 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: =?ISO-8859-15?Q?Alejandro_Riveira_Fern=E1ndez?= 
	<ariveira@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Baryshkov <dbaryshkov@gmail.com>,
       Alistair John Strachan <alistair@devzero.co.uk>,
       "Michael B. Trausch" <mike@trausch.us>
Subject: Re: Linux 2.6.28-rc7
In-Reply-To: <20081202194907.4eaffc0a@varda>
Message-ID: <alpine.LFD.2.00.0812021120110.3256@nehalem.linux-foundation.org>
References: <alpine.LFD.2.00.0812012004370.3256@nehalem.linux-foundation.org> <20081202131442.42e7df48@varda> <alpine.LFD.2.00.0812020748310.3256@nehalem.linux-foundation.org> <20081202165637.09984819@varda> <alpine.LFD.2.00.0812020804590.3256@nehalem.linux-foundation.org>
 <20081202194907.4eaffc0a@varda>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 2 Dec 2008, Alejandro Riveira Fernández wrote:
> 
>  Here you go 
> 
>  [alex@varda:kernel/linux-2.6]$ git bisect bad                                   
> 31168481c32c8a485e1003af9433124dede57f8d is first bad commit

Excellent. One last step - can you verify that just reverting this commit 
makes your problems go away?

IOW, just do

	git bisect reset

to get out of bisect mode, and then do

	git revert 31168481c32c8a485e1003af9433124dede57f8d

and check that the end result is all good?

That's just to double-check that the revert is sufficient, but also 
because "git bisect" is very sensitive to false information (ie if it 
happens that a bug sometimes is not entirely repeatable, then a single 
wrong "git bisect bad/good" will result in the pinpointed commit being 
possibly totally the wrong one).

And Al - can you double-check that commit?

		Linus
