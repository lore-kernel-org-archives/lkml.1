Return-Path: <linux-kernel-owner+w=401wt.eu-S1753117AbXJHPBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117AbXJHPBp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 11:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751596AbXJHPBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 11:01:37 -0400
Received: from ns1.q-leap.de ([153.94.51.193]:33734 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560AbXJHPBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 11:01:37 -0400
From: Bernd Schubert <bs@q-leap.de>
To: Rik van Riel <riel@redhat.com>
Subject: Re: 2.6.23 regression: do_nanosleep will not return
Date: Mon, 8 Oct 2007 17:01:34 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <fed93g$eq4$1@sea.gmane.org> <fedaqr$njj$1@sea.gmane.org> <20071008103252.5fe81529@bree.surriel.com>
In-Reply-To: <20071008103252.5fe81529@bree.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710081701.34368.bs@q-leap.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 October 2007 16:32:52 Rik van Riel wrote:
> On Mon, 08 Oct 2007 15:20:26 +0200
>
> Bernd Schubert <bs@q-leap.de> wrote:
> > Bernd Schubert wrote:
> > > we have a system here were e.g. "sleep 1" will never finish. This
> > > is an issue of 2.6.23, on all older kernel versions it did work
> > > fine.
> > >
> > > Seems to hang in do_nanosleep()
> >
> > Update: Enabling hpet in the bios and setting clocksource=hpet as
> > command line parameter will fix it, but still its not nice that
> > something that worked without a problem in 2.6.22 and below suddenly
> > doesn't work in 2.6.23.
>
> Which timer source is in use when the system hangs?

Well, not the systems hangs, only processes running nanosleep. Well, since the 
system is booted diskless, one of the very first commands is to 
run "/etc/init.d/portmap start", which has a sleep call in its script and so 
it will halt the boot process.

The problematic timer source is acpi_pm. Its also interesting that setting the 
timer source 
via /sys/devices/system/clocksource/clocksource0/current_clocksource won't 
fix that problem. Only the boot option clocksource={other than acpi_pm} does 
help.

Thanks,
Bernd

-- 
Bernd Schubert
Q-Leap Networks GmbH
