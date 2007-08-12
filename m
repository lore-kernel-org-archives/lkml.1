Return-Path: <linux-kernel-owner+w=401wt.eu-S934578AbXHLNJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934578AbXHLNJX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 09:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934975AbXHLNI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 09:08:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:60874 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934964AbXHLNI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 09:08:57 -0400
To: "Dan Merillat" <dan.merillat@gmail.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       rusty@rustcorp.com.au, Petr Vandrovec <petr@vandrovec.name>
Subject: Re: reset during bootup - solved
References: <a56dfcf00708120244x3ae8f4w9183354cf5f33f93@mail.gmail.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 12 Aug 2007 16:03:08 +0200
In-Reply-To: <a56dfcf00708120244x3ae8f4w9183354cf5f33f93@mail.gmail.com>
Message-ID: <p73wsw0j1er.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Dan Merillat" <dan.merillat@gmail.com> writes:

> On 8/11/07, Dan Merillat <dan.merillat@gmail.com> wrote:
> > This one is going to be fun, since it's a hard reset back to bios, no
> > OOPS or anything shown.  It may be about the time RadeonFB kicks in,
> > but it's impossible to tell.  I'd guess 15-20 lines into dmesg.
> >
> > I'm in the process of bisecting, currently 94c18227..d23cf676.
> >
> > Any guesses of a specific patch to check?
> 
> Except it's not d23cf676, that was the version I was running while
> building HEAD, whoops.
> I'm used to monotonic version numbers, not SHA hashes.  I'll keep
> better track next time.
> 
> For completeness, the commit that caused boot to fail was:
> 
> commit ab144f5ec64c42218a555ec1dbde6b60cf2982d6
> Author: Andi Kleen <ak@suse.de>

BTW the patch was actually from Rusty, not me, just the From 
line got lost somewhere. I did a few changes though because
the initial version didn't work on x86-64 at all. Submitted
one worked for me.

> Date:   Fri Aug 10 22:31:03 2007 +0200
> 
>     i386: Make patching more robust, fix paravirt issue
> 
> Except I'm using x86_64?  So not sure why that one rev kills me.

The code is used on x86-64 too, but the script that generates
the prefixes doesn't know this (perhaps I should drop them) 

> ACPI? It dies right after the CPU is identified:
> CPU: AMD Athlon(tm) 64 Processor 3000+ stepping 00
> ACPI: Core revision 20070126

Ok that settles it.

However I must say I'm still dubious of Petr's patch. If there
is something wrong with alternative() then it must be fixed
in alternative() not the call sites. Otherwise it could hit
other patch sites too. There are other copies who
use a similar patching pattern.

Can people who see a failure please send me .config and 
arch/x86_64/lib/memcpy.o privately ? 

-Andi
