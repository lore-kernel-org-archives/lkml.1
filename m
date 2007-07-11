Return-Path: <linux-kernel-owner+w=401wt.eu-S1763095AbXGKAbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763095AbXGKAbo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 20:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbXGKAbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 20:31:37 -0400
Received: from quark.didntduck.org ([69.55.226.66]:38308 "EHLO
	quark.didntduck.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbXGKAbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 20:31:36 -0400
Message-ID: <46942496.2050205@didntduck.org>
Date: Tue, 10 Jul 2007 20:30:14 -0400
From: Brian Gerst <bgerst@didntduck.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Segher Boessenkool <segher@kernel.crashing.org>,
       Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [x86 setup 13/33] Header file to produce 16-bit code with gcc
References: <11840359321823-git-send-email-hpa@zytor.com> <11840373002601-git-send-email-hpa@zytor.com> <108510B6-B9BE-49D4-BDCA-E25CA20CB29B@kernel.crashing.org> <200707101721.58937.ak@suse.de> <D6BECE27-25FA-4914-B293-4070392258D2@kernel.crashing.org> <4693EF48.1080209@zytor.com> <20070710214315.GD3492@stusta.de>
In-Reply-To: <20070710214315.GD3492@stusta.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Tue, Jul 10, 2007 at 01:42:48PM -0700, H. Peter Anvin wrote:
>> Segher Boessenkool wrote:
>>> Well at least with -fno-toplevel-reorder it is guaranteed
>>> to work (not the same thing as "is working", heh, but fairly
>>> close).
>>>
>>> It seems to me GCC should grow an option to insert .code16gcc
>>> by itself (-m16 perhaps?)  Or GAS could get a flag to include
>>> a file as a prelude before the main thing.  Neither will help
>>> Linux right now of course.
>> -m16 is the right thing, and it also provides a proper hook for 
>> eventually having a real 16-bit backend (there are at least two 
>> projects for doing that.)
>>
>> For now, I have:
> 
> Can't you use the global CFLAGS and append your specific ones?
> 
>> CFLAGS          := $(LINUXINCLUDE) -g -Os -D_SETUP -D__KERNEL__ \
> 
> -g ???
> 
>>                    $(cflags-$(ARCH)) \
>>                    -Wall -Wstrict-prototypes \
>>                    -march=i386 -mregparm=3 \
> 
> Why -march=i386 ?

To prevent gcc from using instructions (particularly cmovxx) that not
all processors will understand.

--
				Brian Gerst
