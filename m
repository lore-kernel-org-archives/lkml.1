Return-Path: <linux-kernel-owner+w=401wt.eu-S1762175AbXIMWAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762175AbXIMWAt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 18:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754779AbXIMWAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 18:00:41 -0400
Received: from gw.goop.org ([64.81.55.164]:41353 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754690AbXIMWAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 18:00:41 -0400
Message-ID: <46E9B30E.1080402@goop.org>
Date: Thu, 13 Sep 2007 15:00:46 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Chris Friesen <cfriesen@nortel.com>
CC: linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@osdl.org>,
       James Bottomley <James.Bottomley@steeleye.com>, bapper@piratehaven.org,
       aaw@google.com
Subject: Re: RFC: bug in load_elf_binary?
References: <46E5B6FA.7000902@nortel.com> <46E83191.5070208@nortel.com>
In-Reply-To: <46E83191.5070208@nortel.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen wrote:
> The elf spec says that PT_LOAD segments must be ordered by vaddr.  We
> want to have a segment at a relatively low fixed vaddr.  The exact
> address is not important, except that it's lower than the standard elf
> headers and so it must be the first segment in the elf file.

So you want a zero mapping at a particular address?  So the vaddr and
the memsz are set, but offset and filesz are zero?

> In the kernel elf loader, the p_vaddr and p_offset of the first
> segment are used to determine the load_addr for use with the rest of
> the segments.  In the case of this elf file, the first segment does
> not actually have a valid p_offset.

Well, you could make the p_offset the same as the first segment with a
non-zero filesz.  That should satisfy the elf loader, though it might
still confuse things.

Why can't you create this mapping at runtime?

    J
