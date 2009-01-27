Return-Path: <linux-kernel-owner+w=401wt.eu-S1756048AbZA0Qx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048AbZA0Qx7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 11:53:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754872AbZA0Qxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 11:53:45 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40952 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756360AbZA0Qxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 11:53:45 -0500
Date: Tue, 27 Jan 2009 08:53:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ferenc Wagner <wferi@niif.hu>
Cc: linux-kernel@vger.kernel.org, arve@android.com
Subject: Re: 2.6.29-rc2 dies on startup
Message-Id: <20090127085312.507b447a.akpm@linux-foundation.org>
In-Reply-To: <87eiyok9vc.fsf@tac.ki.iif.hu>
References: <877i4rjw38.fsf@tac.ki.iif.hu>
	<20090125224625.96429d3d.akpm@linux-foundation.org>
	<87eiyok9vc.fsf@tac.ki.iif.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2009 17:10:47 +0100 Ferenc Wagner <wferi@niif.hu> wrote:

> Andrew Morton <akpm@linux-foundation.org> writes:
> 
> > On Mon, 19 Jan 2009 13:53:31 +0100 Ferenc Wagner <wferi@niif.hu> wrote:
> >
> >> I'm running 2.6.28 without problems.  I decided to give 2.6.29-rc2 a
> >> try.  It crashes very early during boot, see screenshot, config and lspci
> >> under http://apt.niif.hu/2.6.29-rc2/.  CPU is AMD Athlon(tm) XP 1800+,
> >> kernel command line: root=/dev/hda1 ro.  I fixed the pcf50663 compile
> >> error by hand, and have a small patch on /drivers/acpi/battery.c, but
> >> that module isn't loaded on this system.  I can hook up a serial
> >> console for further info if needed.
> >
> > What a ghastly backtrace.
> >
> > At a guess I'd say that drivers/staging/android/ram_console.c is calling
> > the reed-solomon code earlier than it's expecting.  But that might be
> > totally wrong.
> >
> > Please set CONFIG_STAGING=n and retest.
> 
> Indeed, with CONFIG_STAGING unset the kernel boots up fine!  Before
> testing I pulled again, set CONFIG_CLASSIC_RCU=y and
> CONFIG_FRAME_POINTER=y, but the resulting kernel still crashed (serial
> log attached).  Then I unset CONFIG_STAGING and that worked.

Thanks.

> Should I also test Arve's patch?

I'm sure he'd be pleased ;)
