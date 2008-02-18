Return-Path: <linux-kernel-owner+w=401wt.eu-S1759295AbYBRNlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759295AbYBRNlc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 08:41:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbYBRNlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 08:41:23 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38348 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549AbYBRNlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 08:41:22 -0500
Date: Mon, 18 Feb 2008 10:41:00 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       sam@ravnborg.org
Subject: Re: Reducing debuginfo size by removing unneeded includes
Message-ID: <20080218134100.GE4359@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
	linux-kernel@vger.kernel.org, sam@ravnborg.org
References: <20080207230304.GA4352@ghostprotocols.net> <p73ir0mxvby.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73ir0mxvby.fsf@bingen.suse.de>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Feb 18, 2008 at 02:12:01PM +0100, Andi Kleen escreveu:
> Arnaldo Carvalho de Melo <acme@redhat.com> writes:
> >
> > [acme@doppio net-2.6]$ l /tmp/sys_ia32.o.before /tmp/sys_ia32.o.after
> > -rw-rw-r-- 1 acme acme 185240 2008-02-06 19:19 /tmp/sys_ia32.o.after
> > -rw-rw-r-- 1 acme acme 248328 2008-02-06 19:00 /tmp/sys_ia32.o.before
> >
> > 	Almost 64KB only on this object file!
> 
> Just FYI, newer gcc does this in theory automatically when you specify 
> 
> -feliminate-unused-debug-types -feliminate-unused-debug-symbols
> 
> But in my tests on gcc 4.1 / gcc 4.2 it doesn't seem to make any difference
> currently :/ Not sure what is wrong. 
> 
> There is also -feliminate-dwarf2-dups, but it seems to even increase
> obj dir size. Also -feliminate-dwarf2-dups seems to generate a lot of 
> 
> WARNING: vmlinux.o (.gnu.linkonce.wi.mmzone.h.97561702): unexpected section name.
> The (.[number]+) following section name are ld generated and not expected.
> Did you forget to use "ax"/"aw" in a .S file?
> Note that for example <linux/init.h> contains
> section definitions for use in .S files.
> 
> etc. warnings But the kernel builds fine even with those warnings.
> 
> Still if you just want to shrink objdir size then figuring out
> what's wrong with these options and then specifying them would be 
> probably the best strategy than to try to do it all manually.
> 
> That said removing unused includes is of course a valuable
> clean up by itself, I'm just not sure it's the best way to get
> smaller object dirs.

I found just it to be another reason for cleaning up the includes hell,
but I agree completely that the correct solution is for gcc to do the
right thing and eliminate unused debug types.

Thanks for showing that there is support for that in latest gccs, I'll
try to use it when I get back to looking at this issue.

- Arnaldo
