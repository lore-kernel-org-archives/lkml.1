Return-Path: <linux-kernel-owner+w=401wt.eu-S1753256AbXC2Heq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbXC2Heq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 03:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753300AbXC2Hep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 03:34:45 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:31363 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753296AbXC2Heh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 03:34:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=imrYvTarUbixZSF8mhzAnsr6Jf9IehAidUX8VZsVyqCjvTvwosnXjsZ/kxelAzwAuJqeFCc5m23K5aqwujXlnBNywYp6rFlbkg6YMph6/WM6NwyhHUoghvddXPRFOiOvX/fZpJCVGsak81+RCB4Af4ByPlubZwISCn+cYFmM8Ak=  ;
X-YMail-OSG: oH22eWcVM1lEnQFD26EIJqZWvTHG7Udk6aTd7Hw3q4ix5APUklcnNT9sGdeJ42c.iLxIekWo8bqphAjSRF4VZmarQwbFLLk8snLhoqhYiB9y8nbYq_6sj7rqndzgOmXgLkrxdWn0ta0EPC8-
Message-ID: <460B6C07.4070505@yahoo.com.au>
Date: Thu, 29 Mar 2007 17:34:31 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: davids@webmaster.com
CC: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: RSDL v0.31
References: <MDEHLPKNGKAHNMBLJOLKGEMCCJAC.davids@webmaster.com>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKGEMCCJAC.davids@webmaster.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Schwartz wrote:
> Bill Davidsen wrote:
> 
> 
>>I agree for giving a process more than a fair share, but I don't think
>>"latency" is the best term for what you describe later. If you think of
>>latency as the time between a process unblocking and the time when it
>>gets CPU, that is a more traditional interpretation. I'm not really sure
>>latency and CPU-starved are compatible.
> 
> 
> For CPU-starvation, I think 'nice' is always going to be the fix. If you
> want a process to get more than its 'fair share' of the CPU, you have to ask
> for that. I think the scheduler should be fair by default.
> 
> However, cleverness in the scheduler with latency can make things better
> without being unfair to anyone. It's perfectly fair for a task that has been
> blocked for awhile to pre-empt a CPU-limited task when it unblocks.
> 
> What I'm arguing is that if your task is CPU-limited and the scheduler is
> fair, that's your fault -- nice it. If your task is suffering from poor
> latency, and it's using less than its fair share of the CPU (because it is
> not CPU-limited), that is something the scheduler can be smarter about.

Agreed. That's what I've been saying for years (since early 2.6 when we had
all those scheduler troubles and I started nicksched).

> Honestly, I have always been against aggressive pre-emption. I think as CPUs
> get faster and timeslices get shorter, it makes less and less sense. In many

I think scheduler timeslices actually shouldn't really be getting shorter.
While I found it is quite easy to get good interactivity with a pretty
dumb scheduler and tiny timeslices (at least until load ramps up enough
that the "off-time" for your critical processes builds up too much), I
think we want to aim for large timeslices. CPU caches are still getting
bigger, and I don't think misses are getting cheaper (especially if you
consider multi core). Also, the energy cost of a memory access is much
higher even if hardware or software is able to hide the latency.

-- 
SUSE Labs, Novell Inc.
