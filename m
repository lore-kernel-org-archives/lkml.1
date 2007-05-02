Return-Path: <linux-kernel-owner+w=401wt.eu-S2992578AbXEBAro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992578AbXEBAro (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 20:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992581AbXEBAro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 20:47:44 -0400
Received: from accolon.hansenpartnership.com ([64.109.89.108]:39327 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992578AbXEBArn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 20:47:43 -0400
Subject: Re: [PATCH] fix dynticks for voyager
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Matt Mackall <mpm@selenic.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4637DA9F.3030503@goop.org>
References: <1177951131.3674.37.camel@mulgrave.il.steeleye.com>
	 <20070501222432.GP11166@waste.org>  <4637DA9F.3030503@goop.org>
Content-Type: text/plain
Date: Tue, 01 May 2007 19:47:39 -0500
Message-Id: <1178066859.4320.90.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-01 at 17:26 -0700, Jeremy Fitzhardinge wrote:
> Matt Mackall wrote:
> > On Mon, Apr 30, 2007 at 11:38:51AM -0500, James Bottomley wrote:
> >   
> >> As usual voyager tripped over an explicit boot CPU is zero assumption in
> >> the dynticks code.  This is the fix I have queued in the voyager tree.
> >>     
> >
> > Can we flush out all these assumptions by adding a constant offset
> > somewhere? Or reversing the ordering?

It might be useful to voyager, but unless the offset were random, people
would simply hardwire it.

> My understanding is that the boot CPU is random depending on who wins
> the "I get to boot" bunfight.

Not quite.  On apic systems, the boot CPU can be an arbitrary physical
id but is conventionally logical id 0.  On voyager, the CPU id actually
maps to a fixed location, so there's no sense in having a logical id.
The booting CPU on voyager is simply the lowest numbered CPU that comes
up through the SUS boot.

James


