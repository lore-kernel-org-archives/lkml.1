Return-Path: <linux-kernel-owner+w=401wt.eu-S1764116AbXLTWIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764116AbXLTWIo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 17:08:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761800AbXLTWI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 17:08:27 -0500
Received: from gw.goop.org ([64.81.55.164]:50056 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764071AbXLTWI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 17:08:26 -0500
Message-ID: <476AE7D6.9000600@goop.org>
Date: Thu, 20 Dec 2007 14:08:22 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH 0/5] x86: another attempt at x86 pagetable unification
References: <20071219223534.129042140@goop.org> <20071220094940.GA14227@elte.hu> <20071220112022.GA15832@elte.hu> <476AD9EA.7010108@goop.org> <20071220213906.GB11897@elte.hu>
In-Reply-To: <20071220213906.GB11897@elte.hu>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>>> found a couple of bugs.
>>>
>>> firstly, 64-bit wasnt so lucky, you broke 
>>> iounmap()/change_page_attr()
>>> :-)
>>>       
>> Crap.  Worked for me.  I'll look into it.
>>     
>
> well, there's an easy solution for unification patches: the resulting 
> object files must have _exactly the same_ content as without the 
> unification patches. (Modulo strings as WARN_ON()s referring to 
> include-file names.)
>
> If they differ then the unification did something wrong. With your 
> patchset and the config i sent, the difference is visible in the image 
> size already:
>
>    text     data   bss     dec              hex    filename
>    7763766  967330 5812328 14543424         ddea40 vmlinux.after
>    7763811  967330 5812328 14543469         ddea6d vmlinux.before
>
> also, reducing the size and scope of changes helps as well - because 
> that way it can be bisected down to specific changes. Mistakes 
> inevitably happen, especially if you do not enforce a rigid 
> byte-for-byte correctness along the way. You did 5 rather large patches, 
> and it's not testable because your unification steps were too coarse.
>   

But byte-for-byte identity isn't (necessarily) possible when actually
unifying. If the same function exists in different forms on 32- and
64-bit, then unifying requires I pick one of them (or perhaps a new
superset) to use in the unified form. That function may generate
different code compared to the one that it replaced...

But you're right, I can do the patches in a more piecemeal form. I'll
see if I can rework them.

J
