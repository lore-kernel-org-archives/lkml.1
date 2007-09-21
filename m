Return-Path: <linux-kernel-owner+w=401wt.eu-S1762708AbXIUTiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762708AbXIUTiz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 15:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761363AbXIUTir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 15:38:47 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:16831 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761302AbXIUTiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 15:38:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Vx6wSH9vXgOdKMFtVACKtY9JqVHtLQAZ9HBRqJfKR454+0FPpvaaW1oKw5aB7B0PG9pKZ/DW34KyFa4yK5m+NwSOpEI1JNaaUMHPMSps9ZLlj9RLwMGyCRHl3nNH4Ayj5k2S0MM7KOkLwvTAq6YOxCAVcXmbGnVpYDx801AJ7Ys=
Message-ID: <46F41DC0.9060407@gmail.com>
Date: Fri, 21 Sep 2007 21:38:40 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Matt Mackall <mpm@selenic.com>, Dave Airlie <airlied@gmail.com>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: X-freeze after clflush changes [Was: 2.6.23-rc6-mm1]
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <46F10B69.5070008@gmail.com> <46F10DCB.1090302@gmail.com> <46F13938.1070709@gmail.com> <20070919121017.0cbcbc30.akpm@linux-foundation.org> <20070919192453.GB18707@one.firstfloor.org> <21d7e9970709191842h3111390cl8f09745bed6bd8f9@mail.gmail.com> <20070920220604.GA17536@waste.org> <10207.1190394975@turing-police.cc.vt.edu>            <46F3FF9C.7040200@gmail.com> <4109.1190403228@turing-police.cc.vt.edu>
In-Reply-To: <4109.1190403228@turing-police.cc.vt.edu>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2007 09:33 PM, Valdis.Kletnieks@vt.edu wrote:
> On Fri, 21 Sep 2007 19:30:04 +0200, Jiri Slaby said:
>> On 09/21/2007 07:16 PM, Valdis.Kletnieks@vt.edu wrote:
> 
>>> Hmm.. maybe I'm chasing a different bug manifested by the same patch.  For me,
>>> it's been a solid lockup at X startup since -rc3-mm1, and this patch doesn't
>>> change matters.
>> This patch probably changes behaviour how the pages are queued on the list
>> somehow. Maybe it's insane to suggest everybody with similar problem to try
>> LIST_DEBUG, but just give it a try after having one of the patches applied ;).
>> (Or have you tried yet?)
> 
> OK, had a chance to test it, with Dave Airlie's AGP patch, and here's what it hit:
> 
> [  198.925000] list_del corruption. next->prev should be ffff81000118f178, but was ffffffff8067e050
> [  198.925000] ------------[ cut here ]------------
> [  198.925000] kernel BUG at lib/list_debug.c:72!
> [  198.925000] invalid opcode: 0000 [1] PREEMPT SMP 
> [  198.925000] last sysfs file: /devices/pci0000:00/0000:00:01.0/0000:01:00.0/i2c-adapter/i2c-1/i2c-1/dev
> [  198.925000] CPU 1 
> [  198.925000] Modules linked in:
> 
> (Yes, I wish I got a backtrace, but that's as long as it lived.  Apparently,
> the netconsole stuff actually writing this stuff out was over on CPU0 which then
> proceeded to croak).
> 
> Some odd SMP-related race? (x86_64 kernel on a Core2 Duo T7200, if it matters)

It is rather the other user who adds the page to some other list while being at
deferred_pages list. Could you try my debug patch
(http://lkml.org/lkml/2007/9/19/141)?

-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
