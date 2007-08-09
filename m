Return-Path: <linux-kernel-owner+w=401wt.eu-S935303AbXHIIHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935303AbXHIIHh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 04:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755781AbXHIIHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 04:07:19 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:14250 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758360AbXHIIHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 04:07:15 -0400
Message-ID: <46BACBD8.7050308@sw.ru>
Date: Thu, 09 Aug 2007 12:10:00 +0400
From: Kirill Korotaev <dev@sw.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060417
X-Accept-Language: en-us, en, ru
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       linux-arch@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: Re: [Devel] Re: [PATCH] Add ability to print calltraces tighter on
 i386
References: <46B9D08F.8080402@openvz.org> <p73zm12qc8a.fsf@bingen.suse.de>	<46B9DCAE.4010009@openvz.org> <200708081720.09034.ak@suse.de>
In-Reply-To: <200708081720.09034.ak@suse.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>>Not everyone likes frame buffer
> 
> 
> You don't need the frame buffer; cards typically have text mode
> fonts upto 80x50. The node numbers vary, but you can find out yours
> with vga=ask
> 
> 
>>but even with it any OOPs in  
>>network code which happens in softirq, io scheduler and nearby 
>>code that is called after passing through all the VFS hooks 
>>and many other examples produce long oopses.
>>
>>Oops-es with only the calltrace of ~50 lines do happen :)
> 
> 
> Normally most of it bogus. I had hoped to address this with the dwarf2
> unwinder, which tends to filter them out nicely,
> but Linus unfortunately has developed an quite irrational aversion against it and 
> it's not in.

Most - but not *all*.
Actually I quite agree with Linus - unwinder is just a pain,
which is the more unreliable then a plain call trace.
Plain call trace has one advantage - it prints more then needed
but it always print the required and clear info.
unwinder goes totally mad when something serious happens like stack
overflows/corruption or other bad thing. 2 my cents.

> But the problem is with bogus entries in there you have no guarantee
> that the first of your call trace is any useful -- it might be all bogus.
> So i don't really think your option makes much sense.

no. bogus entries don't make call trace irrelevant.
And it is very easy to find relevant call trace entries in std output -
call trace should always be correct from the top and from the bottom,
all other entries are checked by eip following the calls.

> Another way would be to not dump addresses and use multiple entries
> per line again. I guess that would make more sense as an option.

Thanks,
Kirill
