Return-Path: <linux-kernel-owner+w=401wt.eu-S1755811AbXEQTPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811AbXEQTPf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 15:15:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754437AbXEQTP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 15:15:28 -0400
Received: from tuxrocks.com ([63.99.9.217]:47839 "EHLO tuxrocks.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754183AbXEQTP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 15:15:27 -0400
Message-ID: <464CA90B.20100@tuxrocks.com>
Date: Thu, 17 May 2007 14:12:11 -0500
From: Frank Sorenson <frank@tuxrocks.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Frank Sorenson <frank@tuxrocks.com>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alistair John Strachan <s0348365@sms.ed.ac.uk>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH] x86-64 highres/dyntick support 2.6.22-rc1-v5
References: <1178485128.31213.98.camel@localhost.localdomain> <1179309789.3764.20.camel@chaos> <464B5FF7.5070701@tuxrocks.com> <464BD945.2070007@tuxrocks.com>
In-Reply-To: <464BD945.2070007@tuxrocks.com>
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Frank Sorenson wrote:

> Hrm.  Looks like it gets past the hpet_is_known  There's still something
> in the hpet detection code, but I didn't get to the bottom of it yet.
> I'll do some more debugging to track down where it's really hanging.
> Sorry for the noise.

I've tracked down this hang to a kzalloc in the hpet code that never
returns.  But only when using SLUB.  Using SLAB, the highres/dyntick
patch boots without problem.

...adding Christoph to the CC list...

Frank
- --
Frank Sorenson - KD7TZK
Linux Systems Engineer, DSS Engineering, UBS AG
frank@tuxrocks.com

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGTKkLaI0dwg4A47wRArYeAJwLs4fJDfj8CuYmUpCaifou6DBsHgCg9nvP
ilEqTd1DdOD13LSl7xVeKls=
=RT2W
-----END PGP SIGNATURE-----
