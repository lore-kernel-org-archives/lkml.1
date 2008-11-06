Return-Path: <linux-kernel-owner+w=401wt.eu-S1754012AbYKFVRI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbYKFVRI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 16:17:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751353AbYKFVQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 16:16:55 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42035 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbYKFVQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 16:16:54 -0500
Date: Thu, 6 Nov 2008 22:16:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ian Campbell <Ian.Campbell@citrix.com>,
       "Christopher S. Aker" <caker@theshore.net>,
       xen devel <xen-devel@lists.xensource.com>,
       Jan Beulich <jbeulich@novell.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] 2.6.27 - SMP enabled, but only 1 CPU
Message-ID: <20081106211639.GA24579@elte.hu>
References: <48F3BC99.5040409@theshore.net> <490F5F50.7020704@theshore.net> <4910AD00.7040605@theshore.net> <4911BC52.7040905@theshore.net> <1225994697.12607.837.camel@zakaz.uk.xensource.com> <49134257.4000404@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49134257.4000404@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Ian Campbell wrote:
>> On Wed, 2008-11-05 at 10:31 -0500, Christopher S. Aker wrote:
>>   
>>> 2.6.28-rc3      - Brought up 1 CPUs, eventually dies with:  
>>> http://p.linode.com/1408
>>>     
>>
>> I've been seeing this too. I bisected it down to:
>>
>>         ab00fee30cddf975200b3c97aef25bea144a0d89 is first bad commit
>>         commit ab00fee30cddf975200b3c97aef25bea144a0d89
>>         Author: Jan Beulich <jbeulich@novell.com>
>>         Date:   Thu Oct 30 10:37:21 2008 +0000
>>                     i386/PAE: fix pud_page()
>>                         Impact: cleanup
>>                         To the unsuspecting user it is quite annoying 
>> that this broken and
>>             inconsistent with x86-64 definition still exists.
>>                         Signed-off-by: Jan Beulich 
>> <jbeulich@novell.com>
>>             Signed-off-by: Ingo Molnar <mingo@elte.hu>
>>                 :040000 040000 3b49a9d3792e9f02dd799ad4deb69922d2a085d0 
>> f0136498ef53b36172dca595f11a784f43bebcea M	arch
>>
>> It's late so figuring out how it broke can wait for tomorrow.
>>
>> The interesting bit from the link given is below.
>>   
>
> Ah, OK.
>
> Ingo, Jan:
>
> Did this patch actually fix anything, or was it just a cleanup?  It  
> seems to have broken 32-bit Xen in some way, so if its just a cleanup it  
> would be best to drop it until we've worked out what's going on.

no, it was pure cleanup. The impact line shows this:

>>                         Impact: cleanup

a "cleanup" impact line is only added if the change is not intended to 
have any side-effects whatsoever.

We can drop it but it would be really nice to figure out what's going 
on. In a very quick late-night look i cannot see anything particularly 
weird about it, but based on the type of changes it does there are 
three leading candidates: lost high 32 bits, zero extend problem, or 
incorrect types.

	Ingo
