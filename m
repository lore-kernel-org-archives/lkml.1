Return-Path: <linux-kernel-owner+w=401wt.eu-S1751560AbZIFEmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560AbZIFEmR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 00:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751164AbZIFEmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 00:42:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41628 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbZIFEmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 00:42:16 -0400
Message-ID: <4AA33D83.6000401@zytor.com>
Date: Sat, 05 Sep 2009 21:41:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Borislav Petkov <petkovbb@googlemail.com>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/cpu] x86, msr: change msr-reg.o to obj-y, and export
 its symbols
References: <20090904140834.GA15789@elte.hu> <tip-b19ae3999891cad21a3995c34d313dda5df014e2@git.kernel.org> <20090905095736.GA5005@liondog.tnic>
In-Reply-To: <20090905095736.GA5005@liondog.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2009 02:57 AM, Borislav Petkov wrote:
> On Fri, Sep 04, 2009 at 05:06:47PM +0000, tip-bot for H. Peter Anvin wrote:
>> x86, msr: change msr-reg.o to obj-y, and export its symbols
>>
>> Change msr-reg.o to obj-y (it will be included in virtually every
>> kernel since it is used by the initialization code for AMD processors)
> 
> Yeah, about that, I'm wondering whether a more fine grained
> Kconfig suboptions would be appropriate here. Currently,
> <arch/x86/kernel/cpu/{intel,amd}.c> are sprinkled with the
> 
> if (c->x86 == XX) { apply quirks }
> 
> thingies and we could put those into their own files which are
> built/linked only when enabled. Before that, you would have chosen
> the CPU vendor and the CPU family thus pulling only the related
> quirks/fixes. Distros will of course need to enable all of them. Then,
> all those different families quirks should be iterated over in a manner
> similar to the initcall mechanism.
> 
> Anyways, just an idea - it could be dumb overengineering but on a
> first glance it will organize/simplify the quirks code, reduce kernel
> image proper, get rid of Kconfig options like CONFIG_X86_F00F_BUG,
> vendor-specific cpuinfo_x86 members like fdiv_bug, f00f_bug, coma_bug,
> and [add another good reason here :)].
> 

Ultimately the right thing to do would be to have the linker do these
kinds of things.  This is easy enough when one deals with things that
have to be linked into the kernel binary, but the msr-reg issue is that
both the kernel proper and a module depend on the same thing... making
it a lib means the module doesn't get it.

All of this gets ugly, and I felt it wasn't enough code to worry about
in this case.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

