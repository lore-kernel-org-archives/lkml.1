Return-Path: <linux-kernel-owner+w=401wt.eu-S1756876AbYHNILH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876AbYHNILH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 04:11:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752471AbYHNIKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 04:10:52 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:47015 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbYHNIKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 04:10:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=knRjwWYpM7EIUxiTSKXnZargIA9jncNgw3TC6IsyoAu4rdYkDggW2W5NNdIdR3NFvQ
         hjAzGyE8AZzXTco55vkuwLMI/PGAJSWigPpIKcCxlTL8fVkUu/ZixC+QChThK8PAWg9x
         J/Lu17TaW3NhPkm7hz8ds1bs2VvyN0+WPYNeQ=
Subject: Re: Timer unstability on when using C2 and deeper sleep states
	(Dell Latitude XT)
From: Milan Plzik <milan.plzik@gmail.com>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
In-Reply-To: <48A3BED6.3070207@shaw.ca>
References: <fa.BPxGhvxOK2Rcn4TTNlAMe2XzVYk@ifi.uio.no>
	 <fa.s5pgfnYl3W8cOu+PDLbvAcv4X9c@ifi.uio.no>
	 <fa.2qnH5HZa4bnjN4HRRidEAUj5jxk@ifi.uio.no>
	 <fa.b1y/njcuV4QYZ2xTsVkHQ55Ni7Y@ifi.uio.no>  <48A3BED6.3070207@shaw.ca>
Content-Type: text/plain
Date: Thu, 14 Aug 2008 10:10:42 +0200
Message-Id: <1218701442.4285.15.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On St, 2008-08-13 at 23:12 -0600, Robert Hancock wrote:
> Milan Plzik wrote:
> > On St, 2008-08-13 at 22:17 +0200, Andi Kleen wrote:
> >> Milan Plzik <milan.plzik@gmail.com> writes:
> >>
> >>>   I apologize for replying on my own mail (and also for top-posting, but
> >>> this information is global update, not exactly fitting any of topics
> >>> mentioned below).
> >>>
> >>>   After playing for a longer while I found out that the system ends
> >>> sometimes in state where, in order to do anything useful, I need to
> >>> press keys on keyboard. 
> >> This usually means it is using the wrong timer in a deeper idle state.
> >> Some idle states cannot be woken up by e.g. the APIC timer and then
> >> you get that effect: you only make progress when you wake up the 
> >> CPU in some other way like pressing a key. Then on wake up the
> >> timers get processed.
> >>
> >> This is usually a bug in the kernel timer selection. It should be chosing
> >> a timer that always wakes up from the deepest idle state used.
> > 
> >   Last days I also considered this option; I tried all possible timers (hpet, tsc, acpi_pm), but their behavior is the same. 'jiffies' timer works correctly, but that one doesn't seem to put CPU to deeper sleeps, so we can't deduce any information from that. 
> > 
> >   I've seen some workaround in drivers/acpi/processor_idle.c, which seems to check the ARCH_APICTIMER_STOPS_ON_C3 macro, but it's enabled at compilation time, so the code is used by kernel... .
> 
> That changes the clock interpolation source, but it doesn't change the 
> timer interrupt source though, which is quite possibly what you're 
> losing. Have you tried nolapictimer kernel option (or nolapic, which is 
> the bigger hammer)?

  I tried both on 2.6.26 kernel; nolapic_timer resulted in a bit (from
my view) more sane results in powertop, but the freezes remained. With
nolapic system seemed to run fine, but it also disabled SMP support.
Maybe the issue is also SMP-related...

  Thank you,
	Milan

  

