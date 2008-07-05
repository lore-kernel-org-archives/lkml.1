Return-Path: <linux-kernel-owner+w=401wt.eu-S1754941AbYGEGCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941AbYGEGCP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 02:02:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752500AbYGEGB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 02:01:57 -0400
Received: from elasmtp-kukur.atl.sa.earthlink.net ([209.86.89.65]:57233 "EHLO
	elasmtp-kukur.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752261AbYGEGB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 02:01:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=mindspring.com;
  b=RhqitzVrI0XY9OkzFejjmoOXA8/Gm9r2mTQmJmPwrXTXC1eJW+FGnXgUdT+Tf11e;
  h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Date: Sat, 5 Jul 2008 02:01:24 -0400
From: Bill Fink <billfink@mindspring.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Trent Piepho <tpiepho@freescale.com>,
       Olivier Galibert <galibert@pobox.com>,
       David Woodhouse <dwmw2@infradead.org>, Hannes Reinecke <hare@suse.de>,
       Takashi Iwai <tiwai@suse.de>, Theodore Tso <tytso@mit.edu>,
       Jeff Garzik <jeff@garzik.org>, Andi Kleen <andi@firstfloor.org>,
       David Miller <davem@davemloft.net>, hugh@veritas.com,
       akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
       mchan@broadcom.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org
Subject: Re: [bug?] tg3: Failed to load firmware "tigon/tg3_tso.bin"
Message-Id: <20080705020124.ac73e979.billfink@mindspring.com>
In-Reply-To: <20080705035215.GA15899@khazad-dum.debian.net>
References: <1215177044.10393.743.camel@pmac.infradead.org>
	<486E2260.5050503@garzik.org>
	<1215178035.10393.763.camel@pmac.infradead.org>
	<20080704141014.GA23215@mit.edu>
	<s5habgxloct.wl%tiwai@suse.de>
	<486E3622.1000900@suse.de>
	<1215182557.10393.808.camel@pmac.infradead.org>
	<20080704231322.GA4410@dspnet.fr.eu.org>
	<20080704235839.GA5649@khazad-dum.debian.net>
	<Pine.LNX.4.64.0807041742500.13075@t2.domain.actdsltmp>
	<20080705035215.GA15899@khazad-dum.debian.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.8.6; powerpc-yellowdog-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: c598f748b88b6fd49c7f779228e2f6aeda0071232e20db4dc1de5b5fa75f586d13da5c7f63c7dac8350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 96.234.158.248
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Jul 2008, Henrique de Moraes Holschuh wrote:

> On Fri, 04 Jul 2008, Trent Piepho wrote:
> > On Fri, 4 Jul 2008, Henrique de Moraes Holschuh wrote:
> > > On Sat, 05 Jul 2008, Olivier Galibert wrote:
> > >> Won't that break multiple kernel installs on any binary packaging
> > >> system that cares about file collisions?  Multiple kernel rpms
> > >> providing the same /lib/firmware files would break things wouldn't
> > >> they ?
> > >
> > > We will probably need per-kernel directories, exactly like what is done for
> > > modules.  And since there are (now) both kernel-version-specific, and
> > > non-kernel-version-specific firmware, this means the firmware loader should
> > > look first on the version-specific directory (say, /lib/firmware/$(uname
> > > -r)/), then if not found, on the general directory (/lib/firmware).
> > 
> > How about /lib/modules/`uname -r`/firmware
> 
> I am fine with it, it certainly has a few advantages.

Why not put it in the same /lib/modules directory as the foo.ko
kernel module itself?  Then those who like to scp kernel modules
around (which I've done myself on occasion) just need to learn
to scp foo.* instead of foo.ko.  Why replicate a separate
/lib/modules/`uname -r`/firmware directory?

						-Bill
