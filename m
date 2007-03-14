Return-Path: <linux-kernel-owner+w=401wt.eu-S932468AbXCNSkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468AbXCNSkF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 14:40:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932500AbXCNSkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 14:40:05 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:59488 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932468AbXCNSkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 14:40:03 -0400
Date: Wed, 14 Mar 2007 19:40:05 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 - Take 2
Message-ID: <20070314184005.GF18731@stusta.de>
References: <20070314050819.536207642@goodmis.org> <p73slc8863r.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <p73slc8863r.fsf@bingen.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2007 at 11:36:08AM +0100, Andi Kleen wrote:
> Steven Rostedt <rostedt@goodmis.org> writes:
> > 
> > So I spent last night hacking up something to try to make a common ground
> > for all code that is shared between x86_64 and i386.  I called this
> > 
> >    arch/x86
> 
> NACK. I think the current ways work just fine. 

In my experience, the current situation is a pain in the ass.

There are at least 3 different ways how arch/x86_64/ uses arch/i386/ 
code [1], and at least 2 different ways how arch/i386/ uses arch/x86_64/

So whenever you touch one file in arch/i386/ or arch/x86_64/, there are 
5 different ways how this code could be used from the other architecture.

I'd even suggest the following:
- move all files under arch/x86_64/ that are also used under arch/i386/
  to arch/i386/ and then
- mv arch/x86_64 arch/i386/mach-x86_64

The associated Makefile and Kconfig changes shouldn't be a problem, and 
after this it will become much easier to see where code gets used.

> -Andi

cu
Adrian

[1] Steven forgot in his list the fifth one:

      obj-$(CONFIG_MTRR)              += ../../i386/kernel/cpu/mtrr/

    The problem with this variant is that different from the
    other 4 ways, grep'ing for a filename doesn't find it...

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

