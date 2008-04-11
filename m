Return-Path: <linux-kernel-owner+w=401wt.eu-S1760793AbYDKLd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760793AbYDKLd2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 07:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759786AbYDKLdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 07:33:09 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35509 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760497AbYDKLdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 07:33:08 -0400
Date: Fri, 11 Apr 2008 13:37:46 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pavel Machek <pavel@ucw.cz>, Jiri Kosina <jkosina@suse.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Andi Kleen <andi@firstfloor.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: BUG: using smp_processor_id() during suspend with 2.6.25-rc8
Message-ID: <20080411113746.GV10019@one.firstfloor.org>
References: <c4e36d110804070625n17eb44e1nbb5558f500f13438@mail.gmail.com> <Pine.LNX.4.64.0804080008420.3896@jikos.suse.cz> <20080407222352.GG16647@one.firstfloor.org> <200804080029.31102.rjw@sisk.pl> <Pine.LNX.4.64.0804080030500.3896@jikos.suse.cz> <20080410094554.GA10321@ucw.cz> <Pine.LNX.4.64.0804110122470.3896@jikos.suse.cz> <20080411104902.GA8734@elf.ucw.cz> <20080411105108.GA1844@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080411105108.GA1844@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> thanks Pavel, i picked this up into sched-devel.git - it makes sense 
> independently of whether it solves the warning.

This means the CPU preempt sanity checking is effectively disabled
on UP kernels. Even though more and more people should run multi-core
now there is still a sizeable user base left on single core.

Don't think this is a good idea. We need even the UP testers.

If he wants this for suspend or machine check/oops (always useful there
to disable such warnings) then there should
be separate checks for this. Perhaps system_state could be enhanced for this?

-Andi

