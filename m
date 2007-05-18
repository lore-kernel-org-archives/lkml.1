Return-Path: <linux-kernel-owner+w=401wt.eu-S1760027AbXERD7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760027AbXERD7h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 23:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757673AbXERD7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 23:59:30 -0400
Received: from tuxrocks.com ([63.99.9.217]:60201 "EHLO tuxrocks.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755796AbXERD73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 23:59:29 -0400
Message-ID: <464D23CC.1040906@tuxrocks.com>
Date: Thu, 17 May 2007 22:55:56 -0500
From: Frank Sorenson <frank@tuxrocks.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alistair John Strachan <s0348365@sms.ed.ac.uk>
Subject: Re: [PATCH] x86-64 highres/dyntick support 2.6.22-rc1-v5
References: <1178485128.31213.98.camel@localhost.localdomain> <1179309789.3764.20.camel@chaos> <464B5FF7.5070701@tuxrocks.com> <464BD945.2070007@tuxrocks.com> <464CA90B.20100@tuxrocks.com> <Pine.LNX.4.64.0705171219140.3043@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0705171219140.3043@schroedinger.engr.sgi.com>
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Christoph Lameter wrote:
> On Thu, 17 May 2007, Frank Sorenson wrote:
>> Frank Sorenson wrote:
>>
>>> Hrm.  Looks like it gets past the hpet_is_known  There's still something
>>> in the hpet detection code, but I didn't get to the bottom of it yet.
>>> I'll do some more debugging to track down where it's really hanging.
>>> Sorry for the noise.
>> I've tracked down this hang to a kzalloc in the hpet code that never
>> returns.  But only when using SLUB.  Using SLAB, the highres/dyntick
>> patch boots without problem.
>>
>> ...adding Christoph to the CC list...
> 
> Please boot with slub_debug.

No debugging output at all.  Still hangs with only:
	Kernel alive
	Kernel direct mapping tables up to 100000000 @ 8000-d000

Frank
- --
Frank Sorenson - KD7TZK
Linux Systems Engineer, DSS Engineering, UBS AG
frank@tuxrocks.com
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGTSPMaI0dwg4A47wRAkiaAJ0X80qq/ASp6zDEDAibOebZ1awBLACgh0OM
mHK5zxK+rwSNoiDlVRv6p8g=
=vegA
-----END PGP SIGNATURE-----
