Return-Path: <linux-kernel-owner+w=401wt.eu-S1759612AbYHOSzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759612AbYHOSzh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 14:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756073AbYHOSz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 14:55:29 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:30983 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754883AbYHOSz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 14:55:28 -0400
Date: Fri, 15 Aug 2008 20:55:00 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Greg KH <greg@kroah.com>, Milton Miller <miltonm@bga.com>,
       Michael Ellerman <michael@ellerman.id.au>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org
Subject: Re: [PATCH/RFC] pci: dynids.use_driver_data considered harmful
Message-ID: <20080815205500.1945916f@hyperion.delvare>
In-Reply-To: <200808151046.59590.jbarnes@virtuousgeek.org>
References: <for-27-patch1-0@bga.com>
	<20080814221214.GG30057@kroah.com>
	<20080815175014.2e005377@hyperion.delvare>
	<200808151046.59590.jbarnes@virtuousgeek.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesse,

On Fri, 15 Aug 2008 10:46:59 -0700, Jesse Barnes wrote:
> So I think your point about dynamic IDs in general is a good one; this flag 
> really does look like an "audit was done" bit, but doesn't go as far is it 
> should.
> 
> The patch you posted to forbid dynamic binding unless use_driver_data is iset 
> is probably the safest thing to do, given that drivers that *don't* set 
> use_driver_data look like they might misbehave even with a driver_data value 
> of 0...

In fact we can do even better than that. We could accept from
user-space only driver_data values which at least one device ID entry in
the driver already uses. That should be fairly easy to implement, and
would offer a level of safety an order of magnitude above what we have
at the moment... And it works both ways: if 0 is not a valid data for
some driver, that would force the user to provide a non-zero (and
valid) data value. And it guarantees that the user can't ask for
something the driver doesn't expect, so drivers don't even need extra
checks. And no need for a use_driver_data flag either.

The only drawback is that it prevents the user from passing a "new"
data value even if it would be valid. But honestly, I don't expect that
case to happen frequently... if ever at all. So I'd say the benefits
totally outweight the drawback.

If the interested people agree with the idea, I'll look into
implementing it.

-- 
Jean Delvare
