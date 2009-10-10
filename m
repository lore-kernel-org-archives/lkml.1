Return-Path: <linux-kernel-owner+w=401wt.eu-S1758342AbZJJMG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758342AbZJJMG2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 08:06:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756893AbZJJMGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 08:06:25 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37413 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883AbZJJMGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 08:06:25 -0400
Date: Sat, 10 Oct 2009 14:04:48 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] battery: Fix charge_now returned by broken batteries
Message-ID: <20091010120448.GB1811@ucw.cz>
References: <1254669853.26496.0.camel@carter> <ca2dc2820910041046i47a1c3dhba82266bb14a440c@mail.gmail.com> <4AC8F02B.6080209@suse.de> <200910042246.23712.rjw@sisk.pl> <4AC91578.2020807@suse.de> <ca2dc2820910041455h18ece909rc2280a40f1899c0a@mail.gmail.com> <4AC923F4.9050100@suse.de> <ca2dc2820910041653o29d4b253n69270d231e56e447@mail.gmail.com> <4AC93B45.8090707@suse.de> <ca2dc2820910061005k2beae176lece9792bb15cda90@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca2dc2820910061005k2beae176lece9792bb15cda90@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > current full charge, when the charging is complete. It may end up lower or
> > greater than
> > previous value.
> > Comparing current charge with the last full charge may correctly give you
> >>100%.
> 
> Then maybe we can write something like...
> 
> val->intval = acpi_battery_is_charged(battery)
> 	? min(battery->capacity_now, battery->full_charge_capacity) * 1000
> 	: battery->capacity_now * 1000;
> 
> So we only use the min() operation when it is fully charged (returning
> to 100%) without losing information when charging.
> 
> The problem is that percentage may jump from >100% to 100% in
> batteries whose full capacity increase, but I think that is OK, since
> when completely charged, the >100% is the new 100%.
> 
> In "broken" batteries (is it broken finally? or is it expected
> behaviour?) like mine the old problem will be corrected, as it was
> only present in the charged state.

I believe you better work around this in userspace... or agree that
>100% charge is possible.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
