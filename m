Return-Path: <linux-kernel-owner+w=401wt.eu-S1760325AbYJMNDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760325AbYJMNDR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 09:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754481AbYJMNDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 09:03:05 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43718 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755377AbYJMNDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 09:03:05 -0400
To: Eric Lacombe <tuxiko@free.fr>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org
Subject: Re: [x86_64] Implementation differences compared to x86_32
From: Andi Kleen <andi@firstfloor.org>
References: <200810131426.20075.goretux@gmail.com>
Date: Mon, 13 Oct 2008 15:03:02 +0200
In-Reply-To: <200810131426.20075.goretux@gmail.com> (Eric Lacombe's message of "Mon, 13 Oct 2008 14:26:19 +0200")
Message-ID: <87vdvwr6k9.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Lacombe <tuxiko@free.fr> writes:
>
> - In x86_32, the physical memory is mapped on kernel land by way of 4 MB 
> pages.
> But for x86_64, I read that the physical memory was mapped by way of 4 KB 
> pages. Is it true ? and in this case, why this choice ?

It's normally not true (except in some special circumstances)

>
> - Is the LDT used in x86_64 ?
> I saw that the GDT_ENTRY_LDT is defined to 10 but when I read in the GDT at 
> 0x50 for the segment descriptor, there is nothing, the area is filled with 
> zeros.

The LDT is only allocated when the user space program needs it. That's
normally only older 32bit applications. Newer 32bit kernels also
use the same setup. Older 32bit kernels still had an iBCS entry
point in a default LDT, but that has been considered obsolete
for some time and removed.

>
> - Where can I find some documentation about the specifities of x86_64 compared 
> to x86_32, particularly about memory management ?
> Perhaps you can (or someone on the list) depict those specificities ?

An somewhat outdated but still reasonable introduction is my old
paper http://halobates.de/x86-64.pdf

-Andi
-- 
ak@linux.intel.com
