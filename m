Return-Path: <linux-kernel-owner+w=401wt.eu-S1755904AbXJBPog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904AbXJBPog (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 11:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751671AbXJBPo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 11:44:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33292 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514AbXJBPo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 11:44:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: [PATCH 2/2] ACPICA: hw: Don't carry spinlock over suspend
Date: Tue, 2 Oct 2007 17:59:05 +0200
User-Agent: KMail/1.9.5
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200710020807.41325.arvidjaar@mail.ru>
In-Reply-To: <200710020807.41325.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710021759.05583.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 2 October 2007 06:07, Andrey Borzenkov wrote:
> > On Sunday, 30 September 2007 20:39, Alexey Starikovskiy wrote:
> > > ACPI uses acpi_get_register() in order to get into suspend.
> > > This function is guarded by acpi_gbl_hardware_lock, which will be carried
> > > into resume phase.
> > > At resume interrupts are enabled and first ACPI interrupt deadlocks on
> > > this lock.
> >
> > Ouch.  That might have bitten quite some people, I guess.
> >
> > > Solution seems to be to not lock register read, as there are no
> > > concurrent activity at this point.
> > >
> > > Reference: http://bugzilla.kernel.org/show_bug.cgi?id=7499
> > >
> > > Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
> >
> > Do you think it's -stable material?
> 
> As someone who *has* been bitten by this bug - by all means.
> 
> I'd like to emphasize one more point - we were able to debug it only because 
> old kernel at least displayed debug messages. Current kernel deadlocks 
> absolutely dead (pun intended). No output to console, no indication what 
> happens. I consider this regression. If at all possible, we should make sure 
> that console output is available as early as possible.

Compile with DISABLE_CONSOLE_SUSPEND set and it should work.

There's a patch queued up for 2.6.24 that adds a command line switch for that.

Greetings,
Rafael
