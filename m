Return-Path: <linux-kernel-owner+w=401wt.eu-S1753646AbYFPK3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646AbYFPK3V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 06:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751578AbYFPK3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 06:29:14 -0400
Received: from stinky.trash.net ([213.144.137.162]:60084 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbYFPK3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 06:29:13 -0400
Message-ID: <48564074.9030301@trash.net>
Date: Mon, 16 Jun 2008 12:29:08 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080405)
MIME-Version: 1.0
To: odie@cs.aau.dk
CC: Suresh Siddha <suresh.b.siddha@intel.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Chuck Ebbert <cebbert@redhat.com>, x86@kernel.org
Subject: Re: 2.6.26-git: NULL pointer deref in __switch_to
References: <4852B19E.4010202@trash.net>	 <19f34abd0806131124w32133715o3ef8c27cb0a9f96e@mail.gmail.com>	 <20080613224711.GA15084@linux-os.sc.intel.com> <1213611339.2495.11.camel@odie.local>
In-Reply-To: <1213611339.2495.11.camel@odie.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simon Holm Th������������������������ wrote:
> fre, 13 06 2008 kl. 15:47 -0700, skrev Suresh Siddha: 
>> On Fri, Jun 13, 2008 at 11:24:01AM -0700, Vegard Nossum wrote:
>>> On Fri, Jun 13, 2008 at 7:42 PM, Patrick McHardy <kaber@trash.net> wrote:
>>>> I get this oops once a day, its apparently triggered by something
>>>> run by cron, but the process is a different one each time.
>>>>
>>>> Kernel is -git from yesterday shortly before the -rc6 release
>>>> (last commit is the usb-2.6 merge, the x86 patches are missing),
>>>> .config is attached.
>>>>
>>>> I'll retry with current -git, but the patches that have gone in
>>>> since I last updated don't look related.
>>>>
>>> Thanks for the report.
>>>
>>>> [62060.043009] BUG: unable to handle kernel NULL pointer dereference at
>>>> 000001ff
>>>> [62060.043009] IP: [<c0102a9b>] __switch_to+0x2f/0x118
>>>> [62060.043009] *pde = 00000000
>>>> [62060.043009] Oops: 0002 [#1] PREEMPT
>> Patrick, Do you see any other error messages before this BUG stmt? Can you
>> please provide the complete kernel log till the point of failure?
>>
> Suresh, I'm pretty sure this is the same problem that I reported two
> weeks ago [1]. I suggested that you tried running lguest and reproduced
> the problem locally, but I did not hear back from you. Now Patrick is
> reporting the same problem and is also indicating that the problem is
> correlated with his use of lguest, so I'd really like you to follow up
> on this.
>
>> I have a theory for your problem and have appended a patch to test it. Can
>> you please check if the appended patch fixes your problem.
>>
> At least for me, with this patch applied on top of -rc4 or -rc6+ the
> problem still triggered after running an lguest guest for less than 30
> seconds (the guest didn't even finish the boot of an image of Ubuntu
> with no X-server).


The patch also didn't fix the problem here, I got the same crash this
morning. Unfortunately netconsole didn't log it, but its essentially
the same as the one I posted.

