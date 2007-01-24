Return-Path: <linux-kernel-owner+w=401wt.eu-S965625AbXAXCiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965625AbXAXCiR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 21:38:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965626AbXAXCiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 21:38:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:51692 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965625AbXAXCiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 21:38:16 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: "Luming Yu" <luming.yu@gmail.com>
Subject: Re: 2.6.19.2 sky2/acpi crashes
Date: Tue, 23 Jan 2007 21:36:54 -0500
User-Agent: KMail/1.9.5
Cc: "Lionel Landwerlin" <landwer@free.fr>, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com
References: <1169542768.5537.11.camel@cocoduo> <1169599541.5235.4.camel@cocoduo> <3877989d0701231739l1399afaci61aed9f26e3cd14@mail.gmail.com>
In-Reply-To: <3877989d0701231739l1399afaci61aed9f26e3cd14@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701232136.54731.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > > Apple Macbook 2GHz (x86, not amd64)

> > > > > Please try to remove processor module.
> > > >
> > > > Ok, that's done. Same problem.
> > >
> > > any difference with "idle=poll"?
> > > if yes, how about "idle=halt"?
> >
> > idle=poll seems to fix the problem (cpu fan is running almost at full
> > speed). Maybe I should run a longer test... For now it consists to run
> > about 15 torrents and watching HDTV through ethernet device.
> >
> > idle=halt does not :
> 
> It sounds like issues relative to Processor C state.
> Please enter a bug in ACPI category on bugzilla.kernel.org

Actually, the test above with the processor module removed proved
that it isn't ACPI C-states -- as they will not be available.
You should be able to observe that /proc/acpi/processor/*/power
does not indicate any C-state use when processor is unloaded.

My guess was that some deep C-state with long exit latency
was interfering with the device.  booting w/o the processor
module should have left you running the native mwait idle.
booting with idle=halt should have left you running the HLT idle.
booting with idle=poll is a busy spin loop that never enters
any hardware power saving state.

I'm quite puzzled that idle=halt was not sufficient to solve the issue,
because that should be the lowest exit latency idle loop.
So maybe I'm wrong about the cause -- though I can't then
explain why idle=poll helps...

All of the idle selection options cause the kernel to print
a line with the word "idle" in it.  Perhaps you could search
your dmesg for "idle" to verify that it is running what we
think it is?

-Len


