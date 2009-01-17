Return-Path: <linux-kernel-owner+w=401wt.eu-S1763213AbZAQPoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763213AbZAQPoj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 10:44:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761576AbZAQPo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 10:44:28 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48719 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761555AbZAQPo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 10:44:27 -0500
Message-ID: <4971FCCE.3020005@redhat.com>
Date: Sat, 17 Jan 2009 09:44:14 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (Macintosh/20081209)
MIME-Version: 1.0
To: 7eggert@gmx.de
CC: Eric Sandeen <sandeen@sandeen.net>, Valdis.Kletnieks@vt.edu,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       t-sato@yk.jp.nec.com
Subject: Re: [PATCH] Allow SysRq emergency sync to thaw frozen filesystems
References: <bUrIs-Za-3@gated-at.bofh.it> <bUKL7-6vo-3@gated-at.bofh.it> <bUNSJ-2Vn-13@gated-at.bofh.it> <bUO2t-376-5@gated-at.bofh.it> <bUYXL-3Qb-25@gated-at.bofh.it> <bUZ7p-448-9@gated-at.bofh.it> <E1LOBlz-0001tI-Oo@be1.7eggert.dyndns.org>
In-Reply-To: <E1LOBlz-0001tI-Oo@be1.7eggert.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bodo Eggert wrote:
> Eric Sandeen <sandeen@sandeen.net> wrote:
>> Valdis.Kletnieks@vt.edu wrote:
>>> On Thu, 15 Jan 2009 21:59:10 CST, Eric Sandeen said:
> 
>>>> Oh, actually, I'd think not.  If the freeze was done properly by the
>>>> filesystem, all data was flushed, the fs was quiesced, and new IO was
>>>> blocked.  pdflush should never be visiting these...
>>> Yes, but a lot of 'if's - and usually you're reaching for sysrq-S precisely
>>> *because* you suspect that stuff wasn't happening properly on its own...
>> Actually, only one if - if the fs implemented freeze properly.
>>
>> Well, the use case I envision here is something like:
>>
>> # freeze /my/mount/point/to/fs/to/snapshot
>>
>> except oops, that wasn't mounted, and you just froze your root fs.
> 
> Maybe freeze should protect against that by requiring to specify the exact
> mountpount, unless you say freeze --subdir?

That's a good idea.  My "freeze" above was a hypothetical tool which
doesn't really exist yet, but should get that enhancement.  :)
(xfs_freeze does not do this checking today, it probably should)

-Eric
