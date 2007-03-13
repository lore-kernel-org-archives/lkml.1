Return-Path: <linux-kernel-owner+w=401wt.eu-S1753174AbXCMHWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174AbXCMHWq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 03:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753171AbXCMHWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 03:22:46 -0400
Received: from smtp103.plus.mail.mud.yahoo.com ([68.142.206.236]:40464 "HELO
	smtp103.plus.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753174AbXCMHWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 03:22:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=S6O4O0wJg6WQgZV7bzeOCcEsLR1fVKvaznyMjWTYWAqKXtE1HFmCAgbtZ2U76OzqM8bMxCeQGGieL/Ytd0OUljOBZKdO0Bs7TmXeFfAnNBsZTDnA0jFZeYq5uoWBhN5s+c+0JCn5kL7vrd5TB3EjqWP1wgbm6ZqPnXjYCPZk5VU=  ;
X-YMail-OSG: apz2rWsVM1liCx.nSiwCEDRVPsXhB8dV0.3TgVipIDegvMPOKRoBmWjQHdC15z_lXDK31V4QBMeaaGjDLoUIg92Ch2ETmxBMtGpLH0GCVZT90XcUjA6dl5Ukr7.YMNq4TAaeVsBKKt2cMT4-
Message-ID: <45F6512E.8000802@yahoo.com.au>
Date: Tue, 13 Mar 2007 18:22:22 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: davids@webmaster.com
CC: Matt Mackall <mpm@selenic.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, ck@vds.kolivas.org
Subject: Re: RSDL-mm 0.28
References: <MDEHLPKNGKAHNMBLJOLKAEBACDAC.davids@webmaster.com>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKAEBACDAC.davids@webmaster.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Schwartz wrote:
>>>There's a substantial performance hit for not yield, so we probably
>>>want to investigate alternate semantics for it. It seems reasonable
>>>for apps to say "let me not hog the CPU" without completely expiring
>>>them. Imagine you're in the front of the line (aka queue) and you
>>>spend a moment fumbling for your wallet. The polite thing to do is to
>>>let the next guy in front. But with the current sched_yield, you go
>>>all the way to the back of the line.
> 
> 
>>Well... are you advocating we change sched_yield semantics to a
>>gentler form? This is a cinch to implement but I know how Ingo feels
>>about this. It will only encourage more lax coding using sched_yield
>>instead of proper blocking (see huge arguments with the ldap people on
>>this one who insist it's impossible not to use yield).
> 
> 
> The basic point of sched_yield is to allow every other process at the same
> static priority level a chance to use the CPU before you get it back. It is
> generally an error to use sched_yield to be nice. It's nice to get your work
> done when the scheduler gives you the CPU, that's why it gave it to you.
> 
> It is proper to use sched_yield as an optimization when it more efficient to
> allow another process/thread to run than you, for example, when you
> encounter a task you cannot do efficiently at that time because another
> thread holds a lock.
> 
> It's also useful prior to doing something that can most efficiently be done
> without interruption. So a thread that returns from 'sched_yield' should
> ideally be given a full timeslice if possible. This may not be sensible if
> the 'sched_yield' didn't actuall yield, but then again, if nothing else
> wants to run, why not give the only task that does a full slice?
> 
> In no case is much of anything guaranteed, of course. (What can you do if
> there's no other process to yield to?)
> 
> Note that processes that call sched_yield should be rewarded for doing so
> just as process that block on I/O are, assuming they do in fact wind up
> giving up the CPU when they would otherwise have had it.
> 
> DS
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
