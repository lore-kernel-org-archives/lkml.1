Return-Path: <linux-kernel-owner+w=401wt.eu-S932086AbXIMX0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086AbXIMX0V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 19:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754016AbXIMX0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 19:26:06 -0400
Received: from zcars04f.nortel.com ([47.129.242.57]:49693 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765611AbXIMX0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 19:26:04 -0400
Message-ID: <46E9C6E4.5080102@nortel.com>
Date: Thu, 13 Sep 2007 17:25:24 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@osdl.org>,
       James Bottomley <James.Bottomley@steeleye.com>, bapper@piratehaven.org,
       aaw@google.com
Subject: Re: RFC: bug in load_elf_binary?
References: <46E5B6FA.7000902@nortel.com> <46E83191.5070208@nortel.com> <46E9B30E.1080402@goop.org>
In-Reply-To: <46E9B30E.1080402@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Sep 2007 23:25:28.0152 (UTC) FILETIME=[5E851580:01C7F65D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Chris Friesen wrote:
> 
>>The elf spec says that PT_LOAD segments must be ordered by vaddr.  We
>>want to have a segment at a relatively low fixed vaddr.  The exact
>>address is not important, except that it's lower than the standard elf
>>headers and so it must be the first segment in the elf file.
> 
> 
> So you want a zero mapping at a particular address?  So the vaddr and
> the memsz are set, but offset and filesz are zero?

I believe that's correct.  It's basically the equivalent of BSS, but 
used for an emulated OS (the app in question is an emulator).

> Well, you could make the p_offset the same as the first segment with a
> non-zero filesz.  That should satisfy the elf loader, though it might
> still confuse things.

Interesting idea.  Worth a try.

However, this doesn't address the kernel side of things.  Am I correct 
in thinking that the kernel is making an invalid assumption that it can 
find the load_addr based on the first segment?

> Why can't you create this mapping at runtime?

Our emulated OS wants to put stuff at fixed addresses in this range, so 
we're trying to keep the loader from allocating stuff there before our 
program gets a chance to start up.

Chris
