Return-Path: <linux-kernel-owner+w=401wt.eu-S1754786AbZJJVxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786AbZJJVxc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 17:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbZJJVxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 17:53:31 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:34600 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751433AbZJJVxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 17:53:30 -0400
X-Sasl-enc: PWF1ikTH0zTWSrYH36fdG3jVzW9eHbO7AR9SUzfHx5Fr 1255211547
Date: Sat, 10 Oct 2009 18:52:24 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] battery: Fix charge_now returned by broken batteries
Message-ID: <20091010215224.GA32139@khazad-dum.debian.net>
References: <200910042246.23712.rjw@sisk.pl>
 <4AC91578.2020807@suse.de>
 <ca2dc2820910041455h18ece909rc2280a40f1899c0a@mail.gmail.com>
 <4AC923F4.9050100@suse.de>
 <ca2dc2820910041653o29d4b253n69270d231e56e447@mail.gmail.com>
 <4AC93B45.8090707@suse.de>
 <ca2dc2820910061005k2beae176lece9792bb15cda90@mail.gmail.com>
 <20091010120448.GB1811@ucw.cz>
 <ca2dc2820910101353g65e4591ds82bf9fff8378abd4@mail.gmail.com>
 <20091010212521.GD14051@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091010212521.GD14051@elf.ucw.cz>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Oct 2009, Pavel Machek wrote:
> > >> In "broken" batteries (is it broken finally? or is it expected
> > >> behaviour?) like mine the old problem will be corrected, as it was
> > >> only present in the charged state.
> > >
> > > I believe you better work around this in userspace... or agree that
> > >>100% charge is possible.
> > 
> > I agree that >100% charge is possible while charging (because that
> > would mean the battery is over the last charged level); however, what
> > does it mean when charged?
> 
> Well, maybe the battery only updates full_charge_capacity during
> powerdown or when the moon is full or something? (IOW you may be
> breaking already working machines).
> 
> > In any case, my laptop's battery is not charging over 100% its
> > original capacity anyway, just reporting a wrong value.
> 
> True. But I do not think  you are fixing it properly. Maybe ask for
> fixed BIOS?
> 
> Or perhaps add quirk based on DMI or something?

FIW, I do think we should attempt to fix situations that are always wrong,
we have a long history of doing that, and it doesn't make sense to send to
userspace stuff that we _know_ to be crap.

The problem is that to, e.g., fix last_full_capacity, you need to be able to
trust your reports of battery state (needs to be idle or discharging), and
current capacity.

So it ends up needing to be quirk-based, as different broken crap will fail
in conflicting ways, so you can't fix them all in one sweep, you'll just
make it worse.  And the _one_ thing we must never do is to make it worse for
the hardware/firmware that gets it right...

I agree with Pavel, can you make it quirk-based?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
