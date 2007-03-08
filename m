Return-Path: <linux-kernel-owner+w=401wt.eu-S1030668AbXCHVhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030668AbXCHVhj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 16:37:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030670AbXCHVhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 16:37:19 -0500
Received: from kepler.fjfi.cvut.cz ([147.32.6.11]:56021 "EHLO
	kepler.fjfi.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030668AbXCHVhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 16:37:12 -0500
Date: Thu, 8 Mar 2007 22:36:51 +0100 (CET)
From: Martin Drab <drab@kepler.fjfi.cvut.cz>
To: Carsten Otte <cotte.de@gmail.com>
cc: hugh@veritas.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Question about memory mapping mechanism
In-Reply-To: <5c77e7070703080617r63cbccfevd2c6d678f16c2b03@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0703082143370.25365@kepler.fjfi.cvut.cz>
References: <Pine.LNX.4.64.0703081345010.21317@kepler.fjfi.cvut.cz>
 <5c77e7070703080617r63cbccfevd2c6d678f16c2b03@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Mar 2007, Carsten Otte wrote:

> On 3/8/07, Martin Drab <drab@kepler.fjfi.cvut.cz> wrote:
> > 
> > The thing is that I'd like to prevent kernel to swap these pages out,
> > because then I may loose some data when they are not available in time
> > for the next round.
> 
> One think you could do is grab a reference to the pages upfront.

I'm not really sure what exactly do you mean by "grab a reference 
upfront"?

> When you stop pushing data out to the userspace, or at least when the 
> file is released, you need to drop that reference again.

Or do you mean reference like with the get_page()? Sure, I do a get_page() 
in the nopage() handler for each page before it is passed to the 
user-space. That's OK, there is no problem. Problem seems to be in the 
PG_reserved bit set when the pages are unmapped from the userspace, i.e. 
when the application calls munmap(2).

> You could even do a kmap_atomic(), which would give you a kernel space 
> mapping. That way, you avoid copy_to_user for that data.

If I understand kmap_atomic() right, then it is not really what I need in 
this case. The kmap() just returns a virtual address (logical address in 
this case, since the pages are not in high memory) for a page. The 
kmap_atomic() does the same but disables preemption first, so all 
processing with the page needs to be atomic, which in this case can not 
be guaranteed.

Or do I get it wrong? I'm not really a kernel's memory management guru, so 
maybe I just don't get it. ;-)

But thanks anyway.

Martin
