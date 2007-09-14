Return-Path: <linux-kernel-owner+w=401wt.eu-S1756567AbXINSVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567AbXINSVd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 14:21:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753069AbXINSVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 14:21:25 -0400
Received: from gw.goop.org ([64.81.55.164]:48527 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752278AbXINSVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 14:21:25 -0400
Message-ID: <46EAD121.5080804@goop.org>
Date: Fri, 14 Sep 2007 11:21:21 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Chris Friesen <cfriesen@nortel.com>
CC: linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@osdl.org>,
       James Bottomley <James.Bottomley@steeleye.com>, bapper@piratehaven.org,
       aaw@google.com
Subject: Re: RFC: bug in load_elf_binary?
References: <46E5B6FA.7000902@nortel.com> <46E83191.5070208@nortel.com> <46E9B30E.1080402@goop.org> <46E9C6E4.5080102@nortel.com>
In-Reply-To: <46E9C6E4.5080102@nortel.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen wrote:
> I believe that's correct.  It's basically the equivalent of BSS, but
> used for an emulated OS (the app in question is an emulator).

Right.

>> Well, you could make the p_offset the same as the first segment with a
>> non-zero filesz.  That should satisfy the elf loader, though it might
>> still confuse things.
>
> Interesting idea.  Worth a try.
>
> However, this doesn't address the kernel side of things.  Am I correct
> in thinking that the kernel is making an invalid assumption that it
> can find the load_addr based on the first segment?

God, that code is such a tangle.  I'm not sure why it particularly cares
about the offset, though perhaps its making sure that (offset %
pagesize) == (vaddr % pagesize), which only matters for filesz>0.

It's not too surprising it falls over with more unconventional ELF files.

>> Why can't you create this mapping at runtime?
>
> Our emulated OS wants to put stuff at fixed addresses in this range,
> so we're trying to keep the loader from allocating stuff there before
> our program gets a chance to start up.

Hm, you might want to have a look at how valgrind gets itself started.

    J
