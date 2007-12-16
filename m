Return-Path: <linux-kernel-owner+w=401wt.eu-S1762932AbXLPEg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762932AbXLPEg6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 23:36:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756367AbXLPEgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 23:36:51 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49614 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754779AbXLPEgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 23:36:50 -0500
Date: Sat, 15 Dec 2007 20:35:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Krzysztof Oledzki <olel@ans.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Osterried <osterried@jesse.de>, protasnb@gmail.com,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bug 9182] Critical memory leak (dirty pages)
Message-Id: <20071215203539.d6f71e96.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0712152358240.14491@bizon.gios.gov.pl>
References: <20071215221935.306A5108068@picon.linux-foundation.org>
	<Pine.LNX.4.64.0712152358240.14491@bizon.gios.gov.pl>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Dec 2007 00:08:52 +0100 (CET) Krzysztof Oledzki <olel@ans.pl> wrote:

> 
> 
> On Sat, 15 Dec 2007, bugme-daemon@bugzilla.kernel.org wrote:
> 
> > http://bugzilla.kernel.org/show_bug.cgi?id=9182
> >
> >
> > ------- Comment #33 from protasnb@gmail.com  2007-12-15 14:19 -------
> > Krzysztof, I'd hate point you to a hard path (at least time consuming), but
> > you've done a lot of digging by now anyway. How about git bisecting between
> > 2.6.20-rc2 and rc1? Here is great info on bisecting:
> > http://www.kernel.org/doc/local/git-quick.html
> 
> As I'm smarter than git-bistect I can tell that 2.6.20-rc1-git8 is as bad 
> as 2.6.20-rc2 but 2.6.20-rc1-git8 with one patch reverted seems to be OK. 
> So it took me only 2 reboots. ;)
> 
> The guilty patch is the one I proposed just an hour ago:
>   http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Fstable%2Flinux-2.6.20.y.git;a=commitdiff_plain;h=fba2591bf4e418b6c3f9f8794c9dd8fe40ae7bd9
> 
> So:
>   - 2.6.20-rc1: OK
>   - 2.6.20-rc1-git8 with fba2591bf4e418b6c3f9f8794c9dd8fe40ae7bd9 reverted: OK
>   - 2.6.20-rc1-git8: very BAD
>   - 2.6.20-rc2: very BAD
>   - 2.6.20-rc4: very BAD
>   - >= 2.6.20: BAD (but not *very* BAD!)
> 

well..  We have code which has been used by *everyone* for a year and it's
misbehaving for you alone.  I wonder what you're doing that is
different/special.

Which filesystem, which mount options, what sort of workload?

Thanks.
