Return-Path: <linux-kernel-owner+w=401wt.eu-S1753307AbYH3Ob3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbYH3Ob3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 10:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750847AbYH3ObU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 10:31:20 -0400
Received: from toro.web-alm.net ([62.245.132.31]:52692 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817AbYH3ObT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 10:31:19 -0400
Message-ID: <48B9594E.4010905@osadl.org>
Date: Sat, 30 Aug 2008 16:29:34 +0200
From: Carsten Emde <Carsten.Emde@osadl.org>
Organization: Open Source Automation Development Lab (OSADL) eG
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: John Kacur <jkacur@gmail.com>
CC: Jon Masters <jonathan@jonmasters.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.26.3-rt3 bug report
References: <520f0cf10808241551x2fe64e9esadf66634b3790c54@mail.gmail.com>	 <520f0cf10808251615r5953794x9816bd58ea771ab3@mail.gmail.com>	 <1219724080.25366.13.camel@perihelion> <48B39969.8060501@osadl.org> <520f0cf10808290729q1d99b915s1543256796c8eeb7@mail.gmail.com>
In-Reply-To: <520f0cf10808290729q1d99b915s1543256796c8eeb7@mail.gmail.com>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

> Carsten Emde wrote:
>> Jon Masters wrote:
>>> John Kacur wrote:
>>>> Slightly different form today.
>>>> Bad page state in process 'firefox-bin'
>>>> page:ffffe20000daa360 flags:0x0100000000000000
>>>> mapping:ffffe20000daa378 mapcount:0 count:0
>>>> Trying to fix it up, but a reboot is needed
>>>> Backtrace:
>>>> Pid: 16955, comm: firefox-bin Not tainted 2.6.26.3-rt3 #3
>>> Er, does firefox run reliably on a non-RT 2.6.26.3 kernel? This many
>>> random calls to bad_page suggests more of a RAM problem.
>> Don't think so. Same problem here:
>> Bad page state in process 'bonobo-activati'
>> page:c18f66fc flags:0x40000000 mapping:c18f670c mapcount:0 count:0
>> [..]
>
> Hi Carsten
> Any progress or ideas here?
No. Admittedly, we have not yet started to take care of the 2.6.26 RT
tree. Finishing the 2.6.24 RT tree was quite difficult and took somewhat
longer than earlier trees so we now really need to use it and to
integrate it into the various industrial projects that waited long
enough for it. This will certainly keep us busy during the next weeks or so.

Unfortunately, the "Bad page state" is not the only regression.
Currently, we know of the following problems in 2.6.26.3-rt3:
- Bad page state
- Tasks blocked for more than 120 seconds
- Various kernel OOPSes
- Increased worst-case latencies as compared to 2.6.24.7-rt17
The problem with these regressions is that they occur only very rarely
and under specific high system load conditions. So we will probably
first need to work on test conditions that will make them happen more
frequently. The "Bad page state" thing appears especially difficult to
fix, since it is probably due to memory corruption.

However, we will continuously check this and future releases of the
2.6.26 RT tree and work on them as time permits, but we do not expect to
have 2.6.26.X-rtY ready for production before October. Meanwhile, if you
find a way to better reproduce the "Bad page state" message, we will
certainly appreciate and use it here.


Thanks,

	Carsten.
