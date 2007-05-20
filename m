Return-Path: <linux-kernel-owner+w=401wt.eu-S1762465AbXETGyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762465AbXETGyS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 02:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759474AbXETGyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 02:54:06 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38757 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759243AbXETGyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 02:54:04 -0400
Date: Sat, 19 May 2007 23:47:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mattia Dongili <malattia@linux.it>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, Zhang Rui <rui.zhang@intel.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Len Brown <lenb@kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: [2.6.22-rc1-mm1] vaio laptop (SZ72B) immediately resumes after
 STR
Message-Id: <20070519234723.5200a8b4.akpm@linux-foundation.org>
In-Reply-To: <20070520061408.GA3325@inferi.kami.home>
References: <20070518071523.GA3195@inferi.kami.home>
	<20070518002240.bc08e811.akpm@linux-foundation.org>
	<20070519064829.GA15518@inferi.kami.home>
	<20070519000413.75badb6f.akpm@linux-foundation.org>
	<20070520061408.GA3325@inferi.kami.home>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 May 2007 15:14:08 +0900 Mattia Dongili <malattia@linux.it> wrote:

> On Sat, May 19, 2007 at 12:04:13AM -0700, Andrew Morton wrote:
> > On Sat, 19 May 2007 15:48:29 +0900 Mattia Dongili <malattia@linux.it> wrote:
> > 
> > > On Fri, May 18, 2007 at 12:22:40AM -0700, Andrew Morton wrote:
> > > > On Fri, 18 May 2007 16:15:24 +0900 Mattia Dongili <malattia@linux.it> wrote:
> > > > 
> > > > > Hello,
> > > > > 
> > > > > After finally catching fw-{ohci,core} to be problematic during resume,
> > > > > I'm now experiencing an immediate resume after suspending.
> > > > > 
> > > > > 2.6.21-rc7-mm* didn't even suspend, my last known suspend-and-resuming
> > > > > kernel was 2.6.21-rc5-mm3 (I know one other vaio SZ user could STR with
> > > > > 2.6.21-rc6-mm* after the cpuidle fixes).
> > > > > 
> > > > > my .config is: http://oioio.altervista.org/linux/config-2.6.22-rc1-mm1-1
> > > > > and a str cycle with PM_DEBUG=y:
> > > > > http://oioio.altervista.org/linux/dmesg-SRT-immediately-resumes.txt
> > > ...
> > > > > Any idea where to start from? (bisecting is ok, but it'll take some
> > > > > time...)
> > > > 
> > > > Bisecting isn't that bad ;) I'd pick git-acpi.patch as the starting point.
> > > 
> > > ok, git-acpi.patch is not the bad boy :)
> 
> but very very close:
> acpi-driver-model-flags-and-platform_enable_wake.patch
> 

Thanks very much for working that out - it saves lots of people heaps of
pain.  I dropped the patch.
