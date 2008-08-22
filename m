Return-Path: <linux-kernel-owner+w=401wt.eu-S1758213AbYHVUR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758213AbYHVUR3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 16:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754880AbYHVURV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 16:17:21 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:27831 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935AbYHVURU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 16:17:20 -0400
Message-ID: <48AF1ECC.7000205@hp.com>
Date: Fri, 22 Aug 2008 16:17:16 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
CC: =?ISO-8859-1?Q?Bj=F6rn_Steinbrink?= <B.Steinbrink@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, Petr Baudis <pasky@suse.cz>,
       linux-kernel@vger.kernel.org, git@vger.kernel.org
Subject: Re: Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected
References: <48A36838.3050309@hp.com> <20080819124602.9e8e69f7.akpm@linux-foundation.org> <48AEDD3D.4060507@hp.com> <20080822092549.ddcb7e79.akpm@linux-foundation.org> <20080822171651.GP10544@machine.or.cz> <20080822105136.a8432875.akpm@linux-foundation.org> <20080822193730.GA1598@atjola.homenet> <48AF17C4.4060606@hp.com>
In-Reply-To: <48AF17C4.4060606@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan D. Brunelle wrote:
> Björn Steinbrink wrote:
>> On 2008.08.22 10:51:36 -0700, Andrew Morton wrote:
>>> On Fri, 22 Aug 2008 19:16:51 +0200 Petr Baudis <pasky@suse.cz> wrote:
>>>> On Fri, Aug 22, 2008 at 09:25:49AM -0700, Andrew Morton wrote:
>>>>> One (probably wrong) approach is to run
>>>>>
>>>>> 	gitk 1c89ac55017f982355c7761e1c912c88c941483d
>>>>>
>>>>> then peer at the output, work out which real commits were in that
>>>>> merge.
>>>>>
>>>>> It looks like the merge ended with
>>>>> b1b135c8d619cb2c7045d6ee4e48375882518bb5 and started with
>>>>> 40c42076ebd362dc69210cccea101ac80b6d4bd4, so perhaps you can do
>>>>>
>>>>> 	git bisect bad b1b135c8d619cb2c7045d6ee4e48375882518bb5
>>>>> 	git bisect good 40c42076ebd362dc69210cccea101ac80b6d4bd4
>>>> ...I don't quite get this - according to the bisection log,
>>>>
>>>> 	# good: [b1b135c8d619cb2c7045d6ee4e48375882518bb5] fix spinlock recursion in hvc_console
>>>>
>>>> and now you want to mark it as bad?
>>> <what bisection log?>
>> Alan provided his bisection log as an attachment to the original bug
>> report.
>>
>>> I assume that Alan's bisection search ended up saying that the merge
>>> commit (1c89ac55017f982355c7761e1c912c88c941483d) was the first bad
>>> commit.
>> Yep, and that's totally correct as far as bisect is concerned. The
>> parents of that merge commit are:
>> 88fa08f67bee1a0c765237bdac106a32872f57d2
>> b1b135c8d619cb2c7045d6ee4e48375882518bb5
>>
>> And Alan marked both of them as good.
>>
>> So, unless Alan made a mistake during his bisection, each of the
>> branches is correct, but the merge did not lead to a correct result. So
>> while there were no textual conflicts, there were still incompatible
>> changes regarding the code semantics and compatibility was not restored
>> during the merge.
> 
> It's important to note that even if I did make a mistake during the
> bisection process (and I certainly wouldn't discount that), recent
> kernels still fail: but when I take out that commit from a recent
> kernel, it fails.

s/fails/succeeds/

> 
> I put in Andrew's suggested patch (to help find things), and now I
> repeatedly get the problems in the attached log.
> 
> Not being an x86 knowledgeable person, I'm a bit concerned about the RSP
> value?! (I enabled stack overflow checking, but that didn't stop things.)
> 
> Alan
> 

