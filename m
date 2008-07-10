Return-Path: <linux-kernel-owner+w=401wt.eu-S1758224AbYGJODi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224AbYGJODi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 10:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755090AbYGJODa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 10:03:30 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:36377 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbYGJOD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 10:03:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=GQgDG5G2rBdCqIUzmGdJU9OKpCrtPwoItIdVr7h5aamdiDY3E87LtnhBQLFr/juHMi
         tlkTtemGAfz9wmXrs7tQw0TXYgIqooqWAdOip+aSbMBgoIHQp7VGvdWQtzauKYRIrdxW
         FoSix5XoyCo9pTriKngo64T6CtMnmBYHDL1h0=
Message-ID: <b647ffbd0807100703q442a9825hb857c321452027e7@mail.gmail.com>
Date: Thu, 10 Jul 2008 16:03:25 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: v2.6.26-rc9: kernel BUG at kernel/sched.c:5858!
Cc: Yanmin <yanmin_zhang@linux.intel.com>,
       "Rusty Russell" <rusty@rustcorp.com.au>, "Ingo Molnar" <mingo@elte.hu>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Gautham R Shenoy" <ego@in.ibm.com>,
       "Heiko Carstens" <heiko.carstens@de.ibm.com>, miaox@cn.fujitsu.com,
       "Lai Jiangshan" <laijs@cn.fujitsu.com>, "Avi Kivity" <avi@qumranet.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <19f34abd0807100604p70c2fec6geca65b2ba772dea@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080710115954.GA3639@damson.getinternet.no>
	 <19f34abd0807100512y7fff3716r3ff37305e863f26@mail.gmail.com>
	 <b647ffbd0807100550l44fae9fate511dafbf87564a4@mail.gmail.com>
	 <19f34abd0807100604p70c2fec6geca65b2ba772dea@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/10 Vegard Nossum <vegard.nossum@gmail.com>:
> On Thu, Jul 10, 2008 at 2:50 PM, Dmitry Adamushko
> <dmitry.adamushko@gmail.com> wrote:
>> 2008/7/10 Vegard Nossum <vegard.nossum@gmail.com>:
>>> On Thu, Jul 10, 2008 at 1:59 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
>>>> Hi,
>>>>
>>>> Looks like CPU hotplug still has some problems. Just got this on
>>>> latest mainline, and I couldn't find the exact same report on LKML
>>>> or kerneloops, maybe it can be helpful for debugging the existing
>>>> problem(s)?
>>>>
>
> [...]
>
>> Does a patch from Miao Xie available via the link below makes this
>> problem disappear? Both bugs are likely to have the same cause.
>>
>> http://lkml.org/lkml/2008/7/7/75
>
> Yep, it does, nice, thanks!
>
> Will these two patches (yours and Miao Xie's) be queued for 2.6.26 already?

Miao Xie's patch addresses a problem by fixing its consequence. In
general, an 'offline' cpu must not be visible for any kind of
load-balancing at this point. So I'd rather like to understand and
address the root cause of this mis-behavior.

Regarding new crashes. Do you get them

(1) after a few cpu offline / onlines ?
(2) on a freshly booted system?
(3) (1) or (2) but only with Miao Xie's patch (should not be (2) then)
(4) something else?

TIA,


-- 
Best regards,
Dmitry Adamushko
