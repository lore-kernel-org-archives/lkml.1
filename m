Return-Path: <linux-kernel-owner+w=401wt.eu-S1759506AbXH1ByR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759506AbXH1ByR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 21:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752302AbXH1ByE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 21:54:04 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:43392 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752175AbXH1ByB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 21:54:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=WwDaGP6Lu52ReNAzFY4xTLGGxtDDxP0DGnzZN4F46s0wK9Q/E2xGU+p+B/0SXxphvhMMgnM1kY4u6Hxa7xX/TCECOItgPfMy2cGjO7KMcbPFgdB029e940N3vc2pHj+UyC6lCHAeXqlswl3s5r22tV6r+UJlyZtTSNkVShVPFpw=  ;
X-YMail-OSG: KY9AnPYVM1kGhg9eX_9Rkj3QHEdhgaU9coDGyvUMPW2phBdLyU9YEyP.oFgriMqmlelJ2xAK9RzkpuN7zEeTICgmLixZ.gRnuCwt9UoWuevTfaNhSfkqFQVQtww_zA--
Message-ID: <46D38035.1010707@yahoo.com.au>
Date: Tue, 28 Aug 2007 11:53:57 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: "Patrick J. LoPresti" <lopresti@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: oom-killer with 27G free swap and overcommit_memory=2
References: <23986fd90708271103r8f0ef68j86f85a6039be2f54@mail.gmail.com>
In-Reply-To: <23986fd90708271103r8f0ef68j86f85a6039be2f54@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick J. LoPresti wrote:
> I am using Linux 2.6.16.46-0.12-smp (SUSE 10 SP1 stock kernel).
> I do intend to bother SUSE, but I am hoping some kind kernel savant
> can help me interpret these log messages and/or give me some
> suggestions for how to proceed.
> 
> My system is a SunFire x4100 (x86_64) with 16G of RAM and 32G of swap
> in a single partition.  I have an application which consumes a lot of
> memory, and after a few hours the oom-killer kills it.
> 
> This would not be surprising, except a) the machine still has 27G of
> free swap at the time; and b) it happens even when I set
> vm.overcommit_memory=2 (with overcommit_ratio=50).  It is
> time-consuming to reproduce, but consistent.
> 
> Below is the first batch of messages from the oom-killer.  In this
> case, overcommit_memory was set to 2, and the application
> received no failures from malloc() or new.
> 
> 9-10 more such batches appear in the log in rapid succession before
> I get the "Kill process XXXX ... Killed process XXXX" pair of messages.
> 
> Here are my questions.  I realize these log messages may be insufficient
> to answer them, and I am ready to provide more information upon
> request.  (Unfortunately I cannot provide the application itself.  But
> I can perform tests and provide logs.)
> 
> 1) Does this behavior definitely indicate a kernel bug?  If not, what
> could my application possibly be doing to cause it?
> 
> 2) Is there any sysctl setting that might "avoid" this problem?  Or a
> way to change my application to avoid it?
> 
> 3) Should I attempt to reproduce this problem on the stock kernel.org
> kernel?

Hi,

Yeah it doesn't seem like the right behaviour. Your app isn't allocating
mlocked memory, is it? What is the value of your /proc/sys/vm/swappiness
sysctl? (increasing it may help).

I'll take a look at the SLES kernel and see whether we can do better
there. Thanks.

Nick

-- 
SUSE Labs, Novell Inc.
