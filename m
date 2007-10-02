Return-Path: <linux-kernel-owner+w=401wt.eu-S1755523AbXJBWdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523AbXJBWdB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 18:33:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752413AbXJBWcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 18:32:54 -0400
Received: from mail.tmr.com ([64.65.253.246]:37274 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082AbXJBWcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 18:32:54 -0400
Message-ID: <4702C882.9090105@tmr.com>
Date: Tue, 02 Oct 2007 18:38:58 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: gogi-k@gogi.tv
CC: linux-kernel@vger.kernel.org
Subject: Re: One process with multiple user ids.
References: <200710021256.08469.gogi-k@gogi.tv>
In-Reply-To: <200710021256.08469.gogi-k@gogi.tv>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Giuliano Gagliardi wrote:
> Hello,
> 
> I have a server that has to switch to different user ids, but because it does 
> other complex things, I would rather not have it run as root. I only need the 
> server to be able to switch to certain pre-defined user ids.
> 
> I have seen that two possible solutions have already been suggested here on 
> the LKML, but it was some years ago, and nothing like it has been 
> implemented.
> 
> (1) Having supplementary user ids like there are supplementary group ids and 
> system calls getuids() and setuids() that work like getgroups() and 
> setgroups()
> 
> (2) Allowing processes to pass user and group ids via sockets.
> 
> Both (1) and (2) would solve my problem. Now my question is whether there are 
> any fundamental flaws with (1) or (2), or whether the right way to solve my 
> problem is another one.
> 
Changing to a limited set of IDs is interesting, I have never looked at 
what happens when a thread does setuid, and neither the man page or a 
very quick look at the code tells me. But the portable way is to do the 
things needed for init, then fork into three processes and give each a 
UID as needed. I would really evaluate the design which made this 
necessary, to see if some IPC could be used. Certainly that's more 
likely to be portable.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
