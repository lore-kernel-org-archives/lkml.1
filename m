Return-Path: <linux-kernel-owner+w=401wt.eu-S2992989AbXDDQdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992989AbXDDQdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 12:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992992AbXDDQdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 12:33:38 -0400
Received: from smtp105.sbc.mail.mud.yahoo.com ([68.142.198.204]:37088 "HELO
	smtp105.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S2992989AbXDDQdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 12:33:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=YFxlzx9AmiildxHj6Iv2UEuloz56bEhdvJhjNWGP1+rttxS0z2So38mMMADsYzDtojhc3kPFD9tkAVBJOCd+KfsZZEzxqJM8+Io7ylRHoTeTt71Y/1DrZ07S7Dd2S2qjrx8Qvx2D98q+4UDB8I/WicrNdcrB6KQEwReHJ4SSL7Y=  ;
X-YMail-OSG: OBiEEFAVM1kRb3dlzS94dBBX7e3_t6_ls1y.i5TM1UKrBflxCcYyUeWPH4o3QmRkelg6D2G3Ow--
From: David Brownell <david-b@pacbell.net>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] [PATCH v2] Add suspend/resume for HPET
Date: Wed, 4 Apr 2007 08:06:05 -0700
User-Agent: KMail/1.7.1
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, Thomas Gleixner <tglx@linutronix.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>
References: <Pine.LNX.4.44L0.0704021557270.29713-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0704021557270.29713-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704040806.06367.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 April 2007 1:04 pm, Alan Stern wrote:
> On Mon, 2 Apr 2007, David Brownell wrote:

> > This is the kind of thing that the pm_parent relationship was (AFAICT)
> > originally supposed to handle.  Of course, it doesn't/can't, given the
> > current implementation ... that relationship is never used.
> 
> Just so.  In fact, there almost certainly are other dependencies that 
> nobody is aware of, simply because they have never had a chance to bite.

In any given system, yes there are bugs lurking.  But I was more concerned
with a provably wrong assumption made by the current framework.  Such things
cause cascading fragility.

As Thomas mentioned, HPET isn't the only place where a "linear" model fails.


> Such things can be rather difficult to pin down when they occur.  I would
> be happy enough to leave matters as they are, with a strict LIFO approach.

I wouldn't.  Much better to have a solid handle on the interdependencies
than to need to cope, long term, with a framework that doesn't allow that.

Remember also that a LIFO model assumes that there's only one sequence by
which the hardware powers up/down ... i.e. that there's no runtime PM going
on, whereby large chunks are regularly powered down/up based on usage.
Better runtime PM becomes more important as system complexity rises.

- Dave
