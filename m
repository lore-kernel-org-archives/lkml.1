Return-Path: <linux-kernel-owner+w=401wt.eu-S939169AbZDJSIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939169AbZDJSIX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 14:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765771AbZDJSII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 14:08:08 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49333 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764623AbZDJSIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 14:08:06 -0400
Date: Fri, 10 Apr 2009 20:11:09 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: acpi/sleep.c saved_magic fix overflow
Message-ID: <20090410181109.GC25317@elf.ucw.cz>
References: <1239385015.3169.15.camel@ht.satnam> <20090410175545.GB16843@elf.ucw.cz> <1239386729.9282.3.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239386729.9282.3.camel@localhost.localdomain>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-04-10 23:35:29, Jaswinder Singh Rajput wrote:
> On Fri, 2009-04-10 at 19:55 +0200, Pavel Machek wrote:
> > On Fri 2009-04-10 23:06:55, Jaswinder Singh Rajput wrote:
> > > Impact: fix overflow
> > 
> > > Constant 0x123456789abcdef0 is so big for a long.
> > > So using saved_magic 0x12345678 for both 32 and 64 bit.
> > 
> > Have you tested the patch? I have feeling that this is tested from
> > assembly... Plus it is only set to long constant on 64-bit, so I don't
> > think you are fixing anything. And if your code is correct the
> > variable is write only...
> > 
> 
> I have tested this:
> 1.  CHECK   arch/x86/kernel/acpi/sleep.c
> arch/x86/kernel/acpi/sleep.c:107:16: warning: constant 0x123456789abcdef0 is so big it is long
> 
> 2. On 64 bit machine box:
> 	long l1;
> 
> 	l1 = 0x123456789abcdef0;
> 	printf("0x%16x : ", l1);
> 
> Output: 0x        9abcdef0

I don't have 64-bit box handy, but please make sure that
suspend/resume works before and after your change.

If the variable is _not_ tested from assembly, just remove
saved_magic...

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
