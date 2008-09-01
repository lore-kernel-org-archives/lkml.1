Return-Path: <linux-kernel-owner+w=401wt.eu-S1759207AbYIAUJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759207AbYIAUJj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 16:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751568AbYIAUJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 16:09:30 -0400
Received: from www.tglx.de ([62.245.132.106]:44443 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751544AbYIAUJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 16:09:30 -0400
Date: Mon, 1 Sep 2008 22:09:17 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
cc: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alok Kataria <akataria@vmware.com>, Michael Buesch <mb@bu3sch.de>
Subject: Re: Regression in 2.6.27 caused by commit bfc0f59
In-Reply-To: <48BC444D.5030601@lwfinger.net>
Message-ID: <alpine.LFD.1.10.0809012208010.3243@apollo.tec.linutronix.de>
References: <48BB2116.1060904@lwfinger.net> <alpine.LFD.1.10.0809011311210.3243@apollo.tec.linutronix.de> <48BC2A03.9000104@lwfinger.net> <alpine.LFD.1.10.0809012018000.3243@apollo.tec.linutronix.de> <48BC444D.5030601@lwfinger.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Sep 2008, Larry Finger wrote:
> The timed sleep is as accurate as I can measure.
> 
> I put in some test prints. The value of pm2 is zero when the else branch of
> the "if (hpet)" is entered; however, pm1 is 15768471. When we reach the
> do_div(tsc2, tsc1) statement, tsc2 is zero, which I think means that the two
> calls to tsc_read_refs() are returning the same junk value.

Ok, so the pmtimer is probably detected later as unusable and disabled.
Please check your logs for: 
"PM-Timer had inconsistent results:"

Thanks,

	tglx
