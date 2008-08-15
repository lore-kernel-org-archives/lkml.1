Return-Path: <linux-kernel-owner+w=401wt.eu-S1761002AbYHORrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761002AbYHORrZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 13:47:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760823AbYHORrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 13:47:15 -0400
Received: from outbound-mail-02.bluehost.com ([69.89.21.12]:52433 "HELO
	outbound-mail-02.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754449AbYHORrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 13:47:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=awwnMR6aL17y72efeSpEYB2eNEH2MH1exAU+db3DlTzuvH5qMeXMREapb1H0ZkCcBakTs6JFC41fSOS2bf2Sjgqb9f+TsbzYdIN0/5yIc7jPCJJhvCllLEPUTU4ZL2Oj;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH/RFC] pci: dynids.use_driver_data considered harmful
Date: Fri, 15 Aug 2008 10:46:59 -0700
User-Agent: KMail/1.9.9
Cc: Greg KH <greg@kroah.com>, Milton Miller <miltonm@bga.com>,
       Michael Ellerman <michael@ellerman.id.au>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org
References: <for-27-patch1-0@bga.com> <20080814221214.GG30057@kroah.com> <20080815175014.2e005377@hyperion.delvare>
In-Reply-To: <20080815175014.2e005377@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808151046.59590.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > It's pretty "trivial" to look to see if the field is set in the pci_id
> > structure, that should be all that is needed, right?
>
> Well... If you consider that all drivers using the driver_data field
> should have the dynids.use_driver_data flag set unconditionally and
> without looking at the code, then in fact you agree with Milton and
> myself that this flag should be dropped. The whole point of the flag,
> if my guess is correct, was to hint the developer that he/she should
> double check his/her code before setting the flag. If you set it for
> all these drivers, then all it does is preventing users from passing a
> driver_data value to drivers which do _not_ use the driver_data... but
> doing that has zero effect at the moment, so that wouldn't actually be
> any different from dropping dynids.use_driver_data altogether.
>
> So I have to reiterate my support to Milton's idea of dropping
> the dynids.use_driver_data flag. It does more harm than good.

Yeah it doesn't seem to be very heavily used at this point. :)

I see around 400 uses of id->driver_data right now, and only 2 of 
use_driver_data.  If we remove the use_driver_data field, drivers (except for 
the 2 using the field) will start to see whatever values userspace passes to 
them rather than 0, and at least in some of the few cases I looked at that 
could cause breakage due to out of bounds references.

So I think your point about dynamic IDs in general is a good one; this flag 
really does look like an "audit was done" bit, but doesn't go as far is it 
should.

The patch you posted to forbid dynamic binding unless use_driver_data is iset 
is probably the safest thing to do, given that drivers that *don't* set 
use_driver_data look like they might misbehave even with a driver_data value 
of 0...

What do you think, Greg?  Convinced yet? :)

Thanks,
Jesse
