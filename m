Return-Path: <linux-kernel-owner+w=401wt.eu-S1031598AbXFHSot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031598AbXFHSot (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 14:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031163AbXFHSo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 14:44:29 -0400
Received: from mail.gmx.net ([213.165.64.20]:33540 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1031078AbXFHSo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 14:44:27 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX180feZfB6c03cK7/bj8O38gUmR2sGFYUHjPPRV0JO
	2kV8OUg/b9gGGf
Date: Fri, 8 Jun 2007 20:44:22 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, ak@suse.de
Subject: [PATCH 0/2] i386: Fix two more NMI watchdog bugs
Message-ID: <20070608184422.GA2204@atjola.homenet>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andi Kleen <andi@firstfloor.org>,
	"Udo A. Steinberg" <us15@os.inf.tu-dresden.de>,
	Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>, ak@suse.de
References: <465C2225.2000100@googlemail.com> <20070603150246.5151dda6@laptop.hypervisor.org> <20070608060244.GA2369@atjola.homenet> <20070607234153.09c32b49.akpm@linux-foundation.org> <20070608105808.GA10190@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070608105808.GA10190@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On 2007.06.08 12:58:08 +0200, Ingo Molnar wrote:
> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > Half of this (the first hunk) has been in Andi's tree for a day or 
> > two.
> > 
> > I shall drop Andi's patch, queue this one up and shall send this off 
> > to Linus if nothing else happens in the next couple of days.
> 
> this patch does not fix the NMI watchdog bootup lockup i can reproduce, 
> it still occurs in -rc4 too. Andi, could you please react to my report? 
> See the "2.6.22-rc3 nmi watchdog hang" thread on lkml.

Ok, so after I figured out again how to enable the nmi watchdog, I found
a few more bugs. One is pretty clear, calling a function directly while
the wrapper should be used, causing a(nother) BUG() when the watchdog is
disabled using /proc/sys/...

The other is less clear (to me). It seems like the perfect candidate to
muck up the watchdog, but I can't get it to do that. On system boot up,
the MSRs are no longer reserved, so some other subsystem might mess with
them. The only suitable subsystem I found was oprofile though, and I
could neither get that to reproduce the hang here nor does oprofile show
up in your logs.

Anyway, both are bugs and should be fixed. Maybe we're even lucky and it
fixes your hang. *fingers crossed*

Björn
