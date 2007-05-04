Return-Path: <linux-kernel-owner+w=401wt.eu-S1754649AbXEDPJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbXEDPJH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 11:09:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755415AbXEDPJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 11:09:07 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:58690 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649AbXEDPJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 11:09:06 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "[PATCH] paravirt: Add startup infrastructure for paravirtualization"
References: <m1mz0ku7je.fsf@ebiederm.dsl.xmission.com>
	<1178280770.23670.61.camel@localhost.localdomain>
	<m1y7k4smmo.fsf@ebiederm.dsl.xmission.com>
	<1178289450.23670.100.camel@localhost.localdomain>
Date: Fri, 04 May 2007 09:07:48 -0600
In-Reply-To: <1178289450.23670.100.camel@localhost.localdomain> (Rusty
	Russell's message of "Sat, 05 May 2007 00:37:30 +1000")
Message-ID: <m1lkg4sk3f.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> writes:

> On Fri, 2007-05-04 at 08:13 -0600, Eric W. Biederman wrote:
>> We don't have any working code, there are no in tree users.
>
> Hi Eric,
>
> 	Lack of in-tree code is definitely not due to me.  The code which uses
> it has been sitting in -mm for three months.  Suddenly ripping this out
> and breaking all that work without replacing it is rude.

My memory is very fuzzy now, but I know it at least came up early on
that everyone should be using %esi to point to real mode data and
that didn't happen.  None of the usual bootloader folks (myself
or HPA) appear to have been on the CC when this code was merged into
the kernel.  Ignoring review comments, skipping the people who know
the code and the bootloader requirements and putting in code that is
so brittle no one can change it is another kind of rude.

I'm wondering how much of the paravirt code is getting in through
reviewer exhaustion?

The interface for bootloaders is as hard to change as the user space
syscall interface.  I'm doing my best to nip this horror in the bud
now that I have looked into it enough to see what is going on.

The interface to bootloaders is quite different from the internal
kernel interfaces that we have all of the users captive so can change
it just by updating all of the users.  Except when we are first adding
the interface anyway.

The only reason this is even changeable is that we don't have any
users, and the code is dead weight.

So since I didn't get the opportunity to NAK the code.  I sent
a patch to revert once I understood it.

>> Therefore the code should go.
>
> Then put the patch is -mm, behind lguest.  Or better, help me refine my
> patches and I'll happily do it for you.

Before lguest.  Thank you very much.  This code should never ever
have been in a stable kernel.  It is a very ill conceived interface.

I have no problems helping you refine your patches, and am working
in that direction now.

I just think it is irresponsible to let something as potentially
problematic as this piece of code is to sit.

And frankly I don't think lguest should be merged until we are as
close to certain as human beings can get that have the ABI reviewed
and sorted out.  ABIs unfortunately are very very hard to change.

Eric
