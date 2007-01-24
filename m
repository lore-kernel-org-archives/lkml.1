Return-Path: <linux-kernel-owner+w=401wt.eu-S1751465AbXAXTxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751465AbXAXTxf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 14:53:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751649AbXAXTxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 14:53:35 -0500
Received: from hera.kernel.org ([140.211.167.34]:55947 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465AbXAXTxe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 14:53:34 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Lionel Landwerlin <landwer@free.fr>
Subject: Re: 2.6.19.2 sky2/acpi crashes
Date: Wed, 24 Jan 2007 14:51:52 -0500
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <1169542768.5537.11.camel@cocoduo> <200701232136.54731.lenb@kernel.org> <1169641425.8145.5.camel@cocoduo>
In-Reply-To: <1169641425.8145.5.camel@cocoduo>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200701241451.52238.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 January 2007 07:23, Lionel Landwerlin wrote:
> Le mardi 23 janvier 2007 à 21:36 -0500, Len Brown a écrit :
> > > > > Apple Macbook 2GHz (x86, not amd64)
> > 
> > > > > > > Please try to remove processor module.
> > > > > >
> > > > > > Ok, that's done. Same problem.
> > > > >
> > > > > any difference with "idle=poll"?
> > > > > if yes, how about "idle=halt"?
> > > >
> > > > idle=poll seems to fix the problem (cpu fan is running almost at full
> > > > speed). Maybe I should run a longer test... For now it consists to run
> > > > about 15 torrents and watching HDTV through ethernet device.
> > > >
> > > > idle=halt does not :
> > > 
> > > It sounds like issues relative to Processor C state.
> > > Please enter a bug in ACPI category on bugzilla.kernel.org
> > 
> > Actually, the test above with the processor module removed proved
> > that it isn't ACPI C-states -- as they will not be available.
> > You should be able to observe that /proc/acpi/processor/*/power
> > does not indicate any C-state use when processor is unloaded.
> > 
> > My guess was that some deep C-state with long exit latency
> > was interfering with the device.  booting w/o the processor
> > module should have left you running the native mwait idle.
> > booting with idle=halt should have left you running the HLT idle.
> > booting with idle=poll is a busy spin loop that never enters
> > any hardware power saving state.
> > 
> > I'm quite puzzled that idle=halt was not sufficient to solve the issue,
> > because that should be the lowest exit latency idle loop.
> > So maybe I'm wrong about the cause -- though I can't then
> > explain why idle=poll helps...
> > 
> > All of the idle selection options cause the kernel to print
> > a line with the word "idle" in it.  Perhaps you could search
> > your dmesg for "idle" to verify that it is running what we
> > think it is?
> 
> Here I join the complete log for idle=halt

it is indeed doing what you asked it to
Jan 24 01:11:21 cocoduo kernel: [   30.741018] using halt in idle threads.

> I'm running idle=poll for more 1 hour now with heavy ethernet load, no
> crash. It usualy happens in 10~15mn with idle=halt and 4~5mn with no
> idle option.

I think my guess is wrong.  If idle=halt doesn't help, then the failure
doesn't have anything to do with the idle loop and power saving idle states.

I can't explain why idle=poll helps.

-Len
