Return-Path: <linux-kernel-owner+w=401wt.eu-S1764610AbXHOBjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764610AbXHOBjI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 21:39:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759432AbXHOBig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 21:38:36 -0400
Received: from gepetto.dc.ltu.se ([130.240.42.40]:37361 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758883AbXHOBif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 21:38:35 -0400
Message-ID: <46C2585F.60802@student.ltu.se>
Date: Wed, 15 Aug 2007 03:35:27 +0200
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Joe Perches <joe@perches.com>, Rene Herman <rene.herman@gmail.com>,
       git@vger.kernel.org, Junio C Hamano <gitster@pobox.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/2many] - FInd the maintainer(s) for a patch - scripts/get_maintainer.pl
References: <1186984174.10249.7.camel@localhost>  <200708131933.10125.m.kozlowski@tuxland.pl>  <1187026955.2688.4.camel@laptopd505.fenrus.org>  <1187037445.6628.98.camel@heimdal.trondhjem.org>  <1187054366.2757.0.camel@laptopd505.fenrus.org>  <46C10AA8.3090505@gmail.com> <20070814102033.604c8695@the-village.bc.nu>  <46C1CFFE.4000001@gmail.com> <1187110824.32555.76.camel@localhost>  <46C1EE6F.2080807@gmail.com> <1187116082.32555.122.camel@localhost> <alpine.LFD.0.999.0708141131140.30176@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0708141131140.30176@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Tue, 14 Aug 2007, Joe Perches wrote:
>
>   
>> On Tue, 2007-08-14 at 20:03 +0200, Rene Herman wrote:
>>     
>>> "git info --maintainer drivers/ide/ide-cd.c" or some such would say "Alan 
>>> Cox <alan@...>".
>>>       
>> Perhaps maintainer(s), approver(s), listener(s)?
>>
>> I think something like this should be a git-goal.
>> What do the git-wranglers think?
>>     
>
> The thing is, if you have git, you can basically already do this.
>
> Do a script like this:
>
> 	#!/bin/sh
> 	git log --since=6.months.ago -- "$@" |
> 		grep -i '^    [-a-z]*by:.*@' |
>   
sed -r "s/^.*by: \"?([^\"]+)\"?/\1/" |
> 		sort | uniq -c |
> 		sort -r -n | head
>
> and it gives you a rather good picture of who is involved with a 
> particular subdirectory or file.
>
>   
Like the script! Especially since it reveled --since=6.month.ago and 
uniq to me.
Just wondering, why order them in the acked, signed and tested? Other 
then removing those, the added 'sed' also fix the <name> vs 
"<name>"-"problem". + adding '-i' to uniq should help the result too, right?

Now a simple "diffstat -p1 -l <patch> | xargs <preferred script-name>" 
makes the day. Too bad, as Joe pointed out, it does not include relevant ML.

cheers
Richard Knutsson

