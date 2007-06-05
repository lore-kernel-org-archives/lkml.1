Return-Path: <linux-kernel-owner+w=401wt.eu-S1765428AbXFEQeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765428AbXFEQeY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 12:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764834AbXFEQeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 12:34:16 -0400
Received: from sicnat2.emn.fr ([193.54.76.193]:49192 "EHLO ron.emn.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764804AbXFEQeP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 12:34:15 -0400
From: Yoann Padioleau <padator@wanadoo.fr>
To: Oliver Neukum <oneukum@suse.de>
Cc: Yoann Padioleau <padator@wanadoo.fr>, kernel-janitors@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [KJ] Re: [PATCH] bugfix GFP_KERNEL -> GFP_ATOMIC in spin_locked region
References: <87odjvu1on.fsf@wanadoo.fr>
	<20070604210018.0eaa20a0.akpm@linux-foundation.org>
	<87k5uimzkh.fsf@wanadoo.fr> <200706051333.12219.oneukum@suse.de>
Date: Tue, 05 Jun 2007 18:31:42 +0200
In-Reply-To: <200706051333.12219.oneukum@suse.de> (Oliver Neukum's message of
	"Tue, 5 Jun 2007 13:33:11 +0200")
Message-ID: <87ejkqe51t.fsf@wanadoo.fr>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum <oneukum@suse.de> writes:

> Am Dienstag, 5. Juni 2007 13:05 schrieb Yoann Padioleau:
>> Ok. Do you have a preference on the format ?  a <file>:<line> format  ?
>> 
>> Is there a place that gathered all those implicit programming rules 
>> (that copy_from_user must not be called inside a spinlock, etc) so that
>> I can translate them in a script for our tool.
>
> How much C does your tool understand? 

The tool understands almost all the C language but the analysis we do
for the moment are intra-procedural so when we look for 
 spin_lock();
 ...
 copy_from_user();

it can detect cases and code paths only when the two function calls
are in the same function. It could be extended but it would require to
do a full analysis of the kernel source. Maybe if some functions of
the library have an attribute in their prototype in the .h such as

 __might_sleep copy_from_user(); 

it could help.

> You might basically
> test for code paths that go to "might_sleep()"

Ok, thanks. If you know other implicit programming rules,
I would be glad to know them, or if you know places
where thus rules are written.


BTW at one point I think the Linux community were using advanced
static analysis tools such as the one made by Dawson Engler (now
Coverity). The communitty have stopped using such tools ? Isn't the
role of sparse to detect bugs such as the dangerous copy_from_user()
inside spinlocked region ?


>
> 	Regards
> 		Oliver
>
> _______________________________________________
> Kernel-janitors mailing list
> Kernel-janitors@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/kernel-janitors

