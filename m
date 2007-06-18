Return-Path: <linux-kernel-owner+w=401wt.eu-S1763841AbXFROXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763841AbXFROXU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 10:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761046AbXFROXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 10:23:13 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:47156 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629AbXFROXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 10:23:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=OIP97/UsBmuakbG63aPUR8N8yt6u18WtMZoczJllMjv0nbWsCOkfd+r2hG3sHsfGmG8qYz/57tNeGXVUeNQHiiHsWFmzEtgWAlJFk4Fn3Ac8MvfPnJ7WLjS3LstnD0hJor6gawOn5eHndGF2YPRixEDaee6YrMSmTF67/xJF37s=
Date: Mon, 18 Jun 2007 22:24:32 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Denis Cheng <crquan@gmail.com>, trivial@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trivial: the memset operation on a automatic array variable should be optimized out by data initialization
Message-ID: <20070618142432.GA2083@localhost.localdomain>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <467658db.0f98600a.5a55.ffffdd79@mx.google.com> <Pine.LNX.4.64.0706180623280.11972@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706180623280.11972@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 06:25:17AM -0400, Robert P. J. Day wrote:
>On Mon, 18 Jun 2007, Denis Cheng wrote:
>
>> From: Denis Cheng <crquan@gmail.com>
>>
>> the explicit memset call could be optimized out by data initialization,
>> thus all the fill working can be done by the compiler implicitly.
>>
>> Signed-off-by: Denis Cheng <crquan@gmail.com>
>>
>> ---
>> Is there some comments on this?
>>
>> --- arch/x86_64/mm/init.c.orig	2007-06-07 10:08:04.000000000 +0800
>> +++ arch/x86_64/mm/init.c	2007-06-18 14:43:15.000000000 +0800
>> @@ -406,8 +406,7 @@ void __cpuinit zap_low_mappings(int cpu)
>>  #ifndef CONFIG_NUMA
>>  void __init paging_init(void)
>>  {
>> -	unsigned long max_zone_pfns[MAX_NR_ZONES];
>> -	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
>> +	unsigned long max_zone_pfns[MAX_NR_ZONES] = { 0, };
>
>the drawback i see to this is that it's *visually* misleading.  it
>*appears* that what the programmer is trying to do is just initialize
>the first element, not all of them -- regardless of the actual effect.
>

C standard can guarantee all of them are initialized, and this is _not_
hard to understand for a good C programmer.

Ack for Denis's change.

Regards!

