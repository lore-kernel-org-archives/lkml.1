Return-Path: <linux-kernel-owner+w=401wt.eu-S1752918AbZGJLyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918AbZGJLyA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 07:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751592AbZGJLxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 07:53:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54977 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874AbZGJLxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 07:53:51 -0400
Date: Fri, 10 Jul 2009 13:52:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Garrett <mjg59@srcf.ucam.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Yinghai Lu <yinghai@kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexey Fisher <bug-track@fisher-privat.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Richard A. Holden III" <aciddeath@gmail.com>
Subject: Re: Intel BIOS - Corrupted low memory at ffff880000004200
Message-ID: <20090710115238.GA8812@elte.hu>
References: <4A5210A2.2080301@fisher-privat.net> <4A52254F.8080103@fisher-privat.net> <20090708113949.GA8960@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090708113949.GA8960@srcf.ucam.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Mon, Jul 06, 2009 at 06:24:47PM +0200, Alexey Fisher wrote:
> > Hallo Ingo, Richard.
> >
> > I'm getting "Corrupted low memory" trace with my Intel DG45ID 
> > board after resume. This board has different dmi-bios-vendor... 
> > so probably it will be nice to have it in your patch.
> 
> I'm beginning to think that we should be doing this on all 
> hardware, perhaps with a kernel option to disable it for embedded 
> devices that really need that 64K. The low-memory corruption issue 
> seems to be very widespread.

The problem is that the BIOS corrupted memory that it also marked as 
'usable' in its E820 map it gave to the kernel. If that memory is 
not usable, it should not have been marked as such. Also, some of 
the reports showed corruption beyond this range so the workaround is 
not universal.

So i'd really like to know what is happening there, instead of just 
zapping support for 64K of RAM on the majority of Linux systems.

We might end up doing the same thing in the end (i.e. disable that 
64k of RAM) - but it should be an informed decision, not a wild stab 
in the dark.

	Ingo
