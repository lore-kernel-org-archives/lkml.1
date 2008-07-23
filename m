Return-Path: <linux-kernel-owner+w=401wt.eu-S1754559AbYGWQNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbYGWQNX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 12:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753057AbYGWQMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 12:12:54 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:44123 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752409AbYGWQMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 12:12:53 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=qf0UDHZUjjLnO6yUJxiDIBSrTDETP8PTq/+T15jr5echFKndebVfPbtq22iLJV5fC7KDx5/9vFxoYe9CTjhWKCpPMuZ+Em/0x1TGxaCuNV+0McGzgEtp6boYdnGJ7+0qxj0jfQFjmwdjR2xrZ/W2xiR6XxhzhTaMRWfRLCbbfr8=  ;
X-YMail-OSG: Dhh9zlkVM1kS7MCtatusFllDRMWTAEcqjtNHvzSoHT_Z992.uaphRGnd2o_WPxbONYkuPfh8Dp_WgfIZ_bpKxiurOFvVXnMJm7TnmTpQ8g--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Clemens Ladisch <clemens@ladisch.de>
Subject: Re: [patch 2.6.26] /dev/hpet - fixes and cleanup
Date: Wed, 23 Jul 2008 09:12:49 -0700
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>, bob.picco@hp.com,
       venkatesh.pallipadi@intel.com, Vojtech Pavlik <vojtech@suse.cz>,
       the arch/x86 maintainers <x86@kernel.org>
References: <200807221508.56672.david-b@pacbell.net> <4886E164.2070304@ladisch.de>
In-Reply-To: <4886E164.2070304@ladisch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807230912.49850.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 July 2008, Clemens Ladisch wrote:
> David Brownell wrote:
> >   * Tighten and correct the userspace interface code
> >       ...
> >       + only open comparators that have an interrupt, and can thus
> >         perform "real work"
> 
> This prevents userspace applications from doing mmap() on /dev/hpet
> even if there is no interrupt.

OK, I removed that ... HPET_IE_ON will already fail.

I didn't find any software using /dev/hpet, except for
the example in Documentation/hpet.txt ... presumably I
was looking in the wrong place.  I'd surely have retched
at anything mmapping hardware registers though.  ;)


> This seems to be the only part of the userspace interface that is
> used in practice.  Because of the availability of POSIX timers, it might
> make sense to deprecate the HPET ioctl interface.

I'll leave that part up to someone else.  If POSIX timers
are a sufficient userspace interface, great ... then that
mmap son't really be needed either!  In fact, would the
/dev/hpet support even be needed?  It's not very portable...

 
> > And re that kernel interface:  IMO, worth having a relatively
> > generic interface for hardware timers instead of inventing a new
> > interface for each new bit of hardware.
> 
> AFAIK it was intended to be similar to the RTC callback interface, but
> that was before the generic high-precision timer stuff was introduced.

People seem to want access to the hardware backed timers too, and
not necessarily coupled to a task like the RTC stuff assumes.  Folk
who want to drive that issue will need to sort out requirements...
the requests I've heard seem to focus on talking to kernel code.

But since HPET "timers" are really weak compared to what most embedded
platforms offer, I'm quite sure any API designed to its capabilities
would be underfeatured!  Example, there are no external inputs (like
clocks or event pulses) or outputs (PWM or whatever) with HPET, and
likewise no flexibility about inputs (which internal clock, or maybe
external clocks).

- Dave
