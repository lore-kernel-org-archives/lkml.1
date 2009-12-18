Return-Path: <linux-kernel-owner+w=401wt.eu-S1754396AbZLRP2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396AbZLRP2e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 10:28:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751171AbZLRP2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 10:28:33 -0500
Received: from mx2.compro.net ([12.186.155.4]:64464 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771AbZLRP2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 10:28:32 -0500
X-IronPort-AV: E=Sophos;i="4.47,418,1257138000"; 
   d="scan'208";a="4795343"
Message-ID: <4B2B9F9F.7040802@compro.net>
Date: Fri, 18 Dec 2009 10:28:31 -0500
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Mark Hounschell <dmarkh@cfl.rr.com>, Alain Knaff <alain@knaff.lu>,
       linux-kernel@vger.kernel.org, fdutils@fdutils.linux.lu
Subject: Re: [Fdutils] DMA cache consistency bug introduced in 2.6.28 (Was:
 Re: Cannot format floppies under kernel 2.6.*?)
References: <4AFB3962.2020106@ntlworld.com> <4B27EF18.7050101@knaff.lu> <4B28FDEB.3030800@compro.net> <4B290029.90602@knaff.lu> <4B2901DB.8040403@compro.net> <4B29052B.9070406@knaff.lu> <4B292D84.5040306@compro.net> <4B29624F.2080109@knaff.lu> <4B2A3805.8040707@compro.net> <4B2A3E3E.8060405@knaff.lu> <4B2A4975.8020809@compro.net> <4B2A49F4.6070402@compro.net> <4B2A4B86.8060307@knaff.lu> <4B2A4C78.10107@compro.net> <4B2A4CF7.6040000@knaff.lu> <4B2A4EC9.2030902@compro.net> <4B2A4FA5.5000701@knaff.lu> <4B2A5192.6090602@compro.net> <4B2A530D.3080606@knaff! .lu> <4B2A6394.3080705@knaff.lu> <alpine.LFD.2.00.0912170916420.15740@localhost.locald! omain> <4B2A98BB.5080406@knaff.lu> <alpine.LFD.2.00.0912171256560.15740@localhost.localdomain> <4B2AAC87.5000703@knaff.lu> <alpine.LFD.2.00.0912171440420.15740@localhost.localdomain> <4B2ABDC8.6090104@knaff.lu> <4B2B4485.6000305@cfl.rr.com> <4B2B5F86.1090403@cfl.rr.com> <alpine.LFD.2.00.0912180716400.3712@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0912180716400.3712@localhost.localdomain>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2009 10:22 AM, Linus Torvalds wrote:
> 
> 
> On Fri, 18 Dec 2009, Mark Hounschell wrote:
>>
>> This one doesn't build:
>>
>> CC [M]  fs/ext3/super.o
>> fs/ext3/super.c: In function ‘ext3_quota_on’:
>> fs/ext3/super.c:2839: error: ‘nd’ undeclared (first use in this function)
>> fs/ext3/super.c:2839: error: (Each undeclared identifier is reported only once
>> fs/ext3/super.c:2839: error: for each function it appears in.)
>> make[2]: *** [fs/ext3/super.o] Error 1
>> make[1]: *** [fs/ext3] Error 2
>> make: *** [fs] Error 2
>>
>> I haven't yet determined that I can but, if I were to make a modification to the
>> tree now to fix this would that screw up the bisect process?
> 
> You can safely fix unrelated problems without screwing up the bisection. 
> And in this case you can be pretty sure that this is unrelated, so it's 
> all ok.
> 
> The fix for that silly problem is
> 
> -                       path_put(&nd.path);
> +                       path_put(&path);
> 
> (it's due to a silent merge failure - it merged cleanly, but semantics had 
> changed in a branch and impacted code that was newly introduced in another 
> branch).

Yep, thanks. I'm past that now. But haven't done a bisect [good|bad] on the
results of that one yet. Did you see Alain's email response to my bisect
progress report to him?

I'm still at a loss as to how to proceed?

Mark
