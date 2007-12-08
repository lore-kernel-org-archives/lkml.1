Return-Path: <linux-kernel-owner+w=401wt.eu-S1756987AbXLHI2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756987AbXLHI2t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 03:28:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754887AbXLHI2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 03:28:40 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38192 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754716AbXLHI2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 03:28:39 -0500
Date: Sat, 8 Dec 2007 09:28:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Fabio Comolli <fabio.comolli@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, Len Brown <lenb@kernel.org>
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
Message-ID: <20071208082815.GB30997@elte.hu>
References: <200712080340.49546.rjw@sisk.pl> <b637ec0b0712072253k7f7410b6iaebf5b7b64ae4509@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b637ec0b0712072253k7f7410b6iaebf5b7b64ae4509@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Fabio Comolli <fabio.comolli@gmail.com> wrote:

> <snip>
> 
> > Subject         : Battery shows up twice in kpowersave
> > Submitter       : Rolf Eike Beer <eike-kernel@sf-tec.de>
> > References      : http://bugzilla.kernel.org/show_bug.cgi?id=9494
> > Handled-By      : Alexey Starikovskiy <astarikovskiy@suse.de>
> > Patch           :
> >
> 
> I don't think that this is a regression: I reported on RedHat bugzilla 
> when I switched from F7 to F8 and I was using 2.6.23.8 at that time. 
> It looks to me an HAL regression, but of course I may be wrong :-) as 
> the reported bisected to a bad commit.
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=373041
> 
> By the way, I now switched to Fedrora Rawhide with a 2.6.24-rc4-git5 
> custom kernel and Gnome desktop and the problem is still present, even 
> with gnome-power-manager.

to me this looks like an ABI regression - utilities should work without 
change. Something changed in /sys output that caused HAL to think that 
there are two batteries:

| The output of lshal shows that there are two UDI's with 
| info.capabilities = { 'battery' }:
|
| udi = '/org/freedesktop/Hal/devices/acpi_BAT0'
| udi = '/org/freedesktop/Hal/devices/computer_power_supply_0'

whether it's a HAL bug or a kernel bug, the original state should be 
restored and it should be worked out without breaking users of older HAL 
versions.

grumble: way too many times do various system utilities break when i 
upgrade the kernel on my laptop. Maybe a new debug mechanism: we should 
start fingerprinting the exact /sys and /proc output and enforce that 
it's immutable across kernel releases as long as the hardware is 
unmodified?

	Ingo
