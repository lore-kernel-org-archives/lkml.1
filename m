Return-Path: <linux-kernel-owner+w=401wt.eu-S933695AbXGQScU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933695AbXGQScU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 14:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754551AbXGQScL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 14:32:11 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:52820 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753214AbXGQScK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 14:32:10 -0400
Date: Tue, 17 Jul 2007 14:32:08 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: david@lang.hm, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Al Boldi <a1426z@gawab.com>
Subject: Re: Hibernation considerations
In-Reply-To: <200707171640.39955.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0707171416120.3728-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007, Rafael J. Wysocki wrote:

> I'm afraid of one thing, though.
> 
> If we create a framework without ACPI (well, ACPI needs to be enabled in the
> kernel anyway for other reasons, like the ability to suspend to RAM) and then
> it turns out that we have to add some ACPI hooks to it, that might be difficult
> to do cleanly.
> 
> Thus, it seems reasonable to think of the ACPI handling in advance.

Absolutely.  This needs to be done in such a way that it will work:

	On platforms without ACPI;

	On platforms with ACPI where we do a non-ACPI type of shutdown
	to whatever extent it is possible (or perhaps an ACPI-aware
	shutdown rather than change to S4);

	On platforms with ACPI where we do an ACPI-aware transition
	to S4.

Rafael, for those of us who aren't thoroughly familiar with all the ins
and outs of the ACPI spec, could you please summarize a list of the
ACPI calls needed in the second and third cases above?  Indicate which
ones need to be done from within the original kernel and which should
be done from within a kexec'd hibernation kernel.


I'm still not entirely clear on how "suspend-to-both" ought to be
handled.  Presumably it will start off as a normal hibernation.  But
instead of shutting down, wouldn't the kexec'd kernel return to the
original kernel?  After all, the original kernel knows about all the
devices and can put them into a low-power state, while the kexec'd
kernel might not have sufficient information.

But what about the freezer?  The original reason for using kexec was to
avoid the need for the freezer.  With no freezer, while the original
kernel is busy powering down its devices, user tasks will be free to
carry out I/O -- which will make the memory snapshot inconsistent with
the on-disk data structures.

Alan Stern

