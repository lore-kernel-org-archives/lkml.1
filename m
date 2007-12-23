Return-Path: <linux-kernel-owner+w=401wt.eu-S1756789AbXLWTU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789AbXLWTU0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 14:20:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752883AbXLWTUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 14:20:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47282 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556AbXLWTUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 14:20:13 -0500
Date: Sun, 23 Dec 2007 20:19:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <gregkh@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bug 9528] x86: Increase PCIBIOS_MIN_IO to 0x1500 to fix
	nForce 4 suspend-to-RAM
Message-ID: <20071223191937.GA28836@elte.hu>
References: <200712231419.40207.carlos@strangeworlds.co.uk> <alpine.LFD.0.9999.0712230933570.21557@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0712230933570.21557@woody.linux-foundation.org>
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



* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > Why:
> > 
> > After debugging _PTS() in the DSDT, it turns out these nVidia boards are
> > trying to write to an IO port > 0x1000 (0x142E) during suspend. Before the
> > re-ordering, we got away with this.
> 
> Very interesting.
> 
> HOWEVER.
> 
> I'd much rather figure out what the magic IO resource is that clashes.

Carlos, could you please run the following script as root:

  http://redhat.com/~mingo/misc/probe-ports.sh

and send us the resulting probe-ports.txt file?

This script will probe all unused ports as per /proc/ioports and will 
list "suspect" IO port areas: ones that do not produce the expected 0xff 
default reply from unclaimed IO ports. Magic chipset register areas can 
potentially be mapped this way.

[ CAREFUL: This probes IO ports which might in theory trigger various
  nastiness such as lockups. I this on a few boxes and the script
  worked, but save any work in case you get lockups. ]

	Ingo
