Return-Path: <linux-kernel-owner+w=401wt.eu-S937639AbXG1HiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937639AbXG1HiT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 03:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762625AbXG1HiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 03:38:06 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:42255 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbXG1HiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 03:38:05 -0400
Message-ID: <46AAF1CF.6060908@gmail.com>
Date: Sat, 28 Jul 2007 09:35:43 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070716)
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Bj=F6rn_Steinbrink?= <B.Steinbrink@gmx.de>,
       Rene Herman <rene.herman@gmail.com>,
       Daniel Hazelton <dhazelton@enter.net>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Frank Kingswood <frank@kingswood-consulting.co.uk>,
       Andi Kleen <andi@firstfloor.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Ray Lee <ray-lk@madrabbit.org>, Jesper Juhl <jesper.juhl@gmail.com>,
       ck list <ck@vds.kolivas.org>, Paul Jackson <pj@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: RFT: updatedb "morning after" problem [was: Re: -mm merge	plans
 for 2.6.23]
References: <9a8748490707231608h453eefffx68b9c391897aba70@mail.gmail.com> <20070727030040.0ea97ff7.akpm@linux-foundation.org> <1185531918.8799.17.camel@Homer.simpson.net> <200707271345.55187.dhazelton@enter.net> <46AA3680.4010508@gmail.com> <20070727231545.GA14457@atjola.homenet>
In-Reply-To: <20070727231545.GA14457@atjola.homenet>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2007 01:15 AM, Björn Steinbrink wrote:

> On 2007.07.27 20:16:32 +0200, Rene Herman wrote:

>> Here's swap-prefetch's author saying the same:
>>
>> http://lkml.org/lkml/2007/2/9/112
>>
>> | It can't help the updatedb scenario. Updatedb leaves the ram full and
>> | swap prefetch wants to cost as little as possible so it will never
>> | move anything out of ram in preference for the pages it wants to swap
>> | back in.
>>
>> Now please finally either understand this, or tell us how we're wrong.
> 
> Con might have been wrong there for boxes with really little memory.

Note -- with "the updatedb scenario" both he in the above and I are talking 
about the "VFS caches filling memory cause the problem" not updatedb in 
particular.

> My desktop box has not even 300k inodes in use (IIRC someone posted a df 
> -i output showing 1 million inodes in use). Still, the memory footprint 
> of the "sort" process grows up to about 50MB. Assuming that the average 
> filename length stays, that would mean 150MB for the 1 million inode 
> case, just for the "sort" process.

Even if it's not 150MB, 50MB is already a lot on a 128 or even a 256MB box. 
So, yes, we're now at the expected scenario of some hog pushing out things 
and freeing it upon exit again and it's something swap-prefetch definitely 
has potential to help with.

Said early in the thread it's hard to imagine how it would not help in any 
such situation so that the discussion may as far as I'm concerned at that 
point concentrate on whether swap-prefetch hurts anything in others.

Some people I believe are not convinced it helps very significantly due to 
at that point _everything_ having been thrown out but a copy of openoffice 
with a large spreadsheet open should come back to life much quicker it would 
seem.

> Any faults in that reasoning?

No. If the machine goes idle after some memory hog _itself_ pushes things 
out and then exits, swap-prefetch helps, at the veryvery least potentially.

By the way -- I'm unable to make my slocate grow substantial here but I'll 
try what GNU locate does. If it's really as bad as I hear then regardless of 
anything else it should really be either fixed or dumped...

Rene.

