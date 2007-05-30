Return-Path: <linux-kernel-owner+w=401wt.eu-S1753080AbXE3EKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080AbXE3EKn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 00:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751611AbXE3EKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 00:10:35 -0400
Received: from main.gmane.org ([80.91.229.2]:53229 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538AbXE3EKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 00:10:34 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Oleg Verych <olecom@flower.upol.cz>
Subject: Re: Jiffies wraparound is not treated in the schedstats
Date: Wed, 30 May 2007 04:03:16 +0000 (UTC)
Organization: Palacky University in Olomouc, experimental physics department.
Message-ID: <slrnf5puif.2k2.olecom@flower.upol.cz>
References: <3f250c710611081005v5fcf3236qfb10b47bab1ada5f@mail.gmail.com> <4552CAD9.1080603@in.ibm.com>
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: flower.upol.cz
User-Agent: slrn/0.9.8.1pl1 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2006-11-09, Balbir Singh <balbir@in.ibm.com> wrote:
> Path: news.gmane.org!not-for-mail
> From: Balbir Singh <balbir@in.ibm.com>
> Newsgroups: gmane.linux.kernel
> Subject: Re: Jiffies wraparound is not treated in the schedstats
> Date: Thu, 09 Nov 2006 11:59:45 +0530
> Organization: IBM
> Lines: 61
> Approved: news@gmane.org
> Message-ID: <4552CAD9.1080603@in.ibm.com>
> References: <3f250c710611081005v5fcf3236qfb10b47bab1ada5f@mail.gmail.com>
> Reply-To: balbir@in.ibm.com
> NNTP-Posting-Host: main.gmane.org
> Mime-Version: 1.0
> Content-Type: text/plain; charset=ISO-8859-1
> Content-Transfer-Encoding: 7bit
> X-Trace: sea.gmane.org 1163053871 25652 80.91.229.2 (9 Nov 2006 06:31:11 GMT)
> X-Complaints-To: usenet@sea.gmane.org
> NNTP-Posting-Date: Thu, 9 Nov 2006 06:31:11 +0000 (UTC)
> Cc: linux-kernel <linux-kernel@vger.kernel.org>
> Original-X-From: linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754746AbWKIGad@vger.kernel.org Thu Nov 09 07:31:09 2006
> Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754746AbWKIGad@vger.kernel.org>
> Envelope-to: glk-linux-kernel-3@gmane.org
> Original-Received: from vger.kernel.org ([209.132.176.167]) by ciao.gmane.org with esmtp (Exim 4.43) id 1Gi3RH-0005lG-4D for glk-linux-kernel-3@gmane.org; Thu, 09 Nov 2006 07:31:03 +0100
> Original-Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand id S1754746AbWKIGad (ORCPT <rfc822;glk-linux-kernel-3@m.gmane.org>); Thu, 9 Nov 2006 01:30:33 -0500
> Original-Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754747AbWKIGad (ORCPT <rfc822;linux-kernel-outgoing>); Thu, 9 Nov 2006 01:30:33 -0500
> Original-Received: from ausmtp05.au.ibm.com ([202.81.18.154]:27366 "EHLO ausmtp05.au.ibm.com") by vger.kernel.org with ESMTP id S1754746AbWKIGac (ORCPT <rfc822;linux-kernel@vger.kernel.org>); Thu, 9 Nov 2006 01:30:32 -0500
> Original-Received: from sd0208e0.au.ibm.com (d23rh904.au.ibm.com [202.81.18.202]) by ausmtp05.au.ibm.com (8.13.8/8.13.6) with ESMTP id kA9IWR8m2142218 for <linux-kernel@vger.kernel.org>; Thu, 9 Nov 2006 17:32:29 -0100
> Original-Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.250.242]) by sd0208e0.au.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kA96XQUu233974 for <linux-kernel@vger.kernel.org>; Thu, 9 Nov 2006 17:33:46 +1100
> Original-Received: from d23av01.au.ibm.com (loopback [127.0.0.1]) by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kA96TxcF020262 for <linux-kernel@vger.kernel.org>; Thu, 9 Nov 2006 17:29:59 +1100
> Original-Received: from [9.124.96.199] ([9.124.96.199]) by d23av01.au.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id kA96Tuua020086; Thu, 9 Nov 2006 17:29:58 +1100
> User-Agent: Thunderbird 1.5.0.7 (X11/20060922)
> Original-To: Mauricio Lin <mauriciolin@gmail.com>
> In-Reply-To: <3f250c710611081005v5fcf3236qfb10b47bab1ada5f@mail.gmail.com>
> Original-Sender: linux-kernel-owner@vger.kernel.org
> Precedence: bulk
> X-Mailing-List: linux-kernel@vger.kernel.org
> Xref: news.gmane.org gmane.linux.kernel:465046
> Archived-At: <http://permalink.gmane.org/gmane.linux.kernel/465046>
>
> Mauricio Lin wrote:
>> Hi Balbir,
>> 
>> Do you know why in the sched_info_arrive() and sched_info_depart()
>> functions the calculation of delta_jiffies does not use the time_after
>> or time_before macro to prevent  the miscalculation when jiffies
>> overflow?
>> 
>> For instance the delta_jiffies variable is simply calculated as:
>> 
>> delta_jiffies = now - t->sched_info.last_queued;
>> 
>> Do not you think the more logical way should be
>> 
>> if (time_after(now, t->sched_info.last_queued))
>>    delta_jiffies = now - t->sched_info.last_queued;
>> else
>>    delta_jiffies = (MAX_JIFFIES - t->sched_info.last_queued) + now
>> 
>
> What's MAX_JIFFIES? Is it MAX_ULONG? jiffies is unsigned long
> so you'll have to be careful with unsigned long arithmetic.
>
> Consider that now is 5 and t->sched_info.last_queued is 10.
>
> On my system
>
> perl -e '{printf("%lu\n", -5 + (1<<32) - 1);}'
> 4294967291

So, according to this
> perl -e '{printf("%lu\n", -5 );}'
> 4294967291
you have 32bit perl (and OS).

I have same result in
"This is perl, v5.8.4 built for i386-linux-thread-multi"

(knoppix 3.2.3 in qemu on intel's amd64).

That means we are on the same question i asked before about integer
overflow. In this case "(1<<32) = 1",  

>> I have included more variables to measure some issues of schedule in
>> the kernel (following schedstat idea) and I noticed that jiffies
>> wraparound has led to wrong values, since the user space tool when
>> collecting the values is producing negative values.
>> 
>
> hmm.. jiffies wrapped around in sched_info_depart()? I've never seen
> that happen. Could you post the additions and user space tool to look at?
> What additional features are you planning to measure in the scheduler?
>
>> Any comments?
>> 
>> Can I provide a patch for that?
>> 
>
> Please feel free to provide patches, this is open source!!
>
>> BR,
>> 
>> Mauricio Lin.
>
>
> -- 
>
> 	Balbir Singh,
> 	Linux Technology Center,
> 	IBM Software Labs

