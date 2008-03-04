Return-Path: <linux-kernel-owner+w=401wt.eu-S1764372AbYCDV7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764372AbYCDV7H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 16:59:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755882AbYCDV6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 16:58:54 -0500
Received: from xspect.dk ([212.97.129.87]:37451 "EHLO xspect.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754323AbYCDV6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 16:58:54 -0500
Date: Tue, 4 Mar 2008 22:58:52 +0100
From: "Klaus S. Madsen" <ksm@hjernemadsen.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pavel Machek <pavel@ucw.cz>,
       Suspend-devel list <suspend-devel@lists.sourceforge.net>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Gleixner <tglx@linutronix.de>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: Regression in 2.6.25-rc3: s2ram segfaults before suspending
Message-ID: <20080304215852.GA14318@hjernemadsen.org>
References: <47C739A6.5020608@zytor.com> <20080229070028.GK17932@hjernemadsen.org> <47C873AA.6040305@zytor.com> <20080229212654.GL27212@elte.hu> <20080301094525.GQ17932@hjernemadsen.org> <20080303121735.GE28369@elf.ucw.cz> <20080303151155.GT17932@hjernemadsen.org> <20080303174858.GB25496@elte.hu> <20080303205227.GU17932@hjernemadsen.org> <20080304123602.GC29777@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080304123602.GC29777@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2008 at 13:36:02 +0100, Ingo Molnar wrote:
> my guess would be that it's this commit that causes it:
> 
> | commit 6c3866558213ff706d8331053386915371ad63ec
> | Author: Jeremy Fitzhardinge <jeremy@goop.org>
> | Date:   Wed Jan 30 13:32:55 2008 +0100
> |
> |    x86: move all asm/pgtable constants into one place
All right. I just tried the following:

git checkout 82bc03fc158e28c90d7ed9919410776039cb4e14
make clean && make -j3 && sudo make install modules_install

And the resulting kernel works OK. However if I checkout commit
6c3866558213ff706d8331053386915371ad63ec, and compile it using the
previous commandline, s2ram fails so it seems you're right.

> > But I'm a bit puzzled by the fact that I'm aparently the only one how 
> > have encountered the problem? Maybe it's only a problem if one also 
> > uses PAE? (Thats just a wild guess to explain why I'm the only one 
> > seeing this).
> 
> PAE activates NX on 32-bit. So we probably had an NX regression that got 
> fixed by the side-effects of one of the unifications. Does it start 
> working if you disable NX via the noexec=off boot option?
If I boot with noexec=off, s2ram starts working again.

-- 
Kind regards
	Klaus S. Madsen
