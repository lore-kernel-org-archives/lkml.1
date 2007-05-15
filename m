Return-Path: <linux-kernel-owner+w=401wt.eu-S1759329AbXEOPZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759329AbXEOPZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 11:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756671AbXEOPZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 11:25:19 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:39913 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742AbXEOPZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 11:25:17 -0400
Message-ID: <4649D0EF.6080203@de.ibm.com>
Date: Tue, 15 May 2007 17:25:35 +0200
From: Martin Peschke <mp3@de.ibm.com>
Organization: =?ISO-8859-1?Q?IBM_Deutschland_Entwicklung_GmbH_Vor?=
 =?ISO-8859-1?Q?sitzender_des_Aufsichtsrats=3A_Johann_Weihen_Ge?=
 =?ISO-8859-1?Q?sch=E4ftsf=FChrung=3A_Herbert_Kircher_Sitz_der_?=
 =?ISO-8859-1?Q?Gesellschaft=3A_B=F6blingen_Registergericht=3A_Amts?=
 =?ISO-8859-1?Q?gericht_Stuttgart=2C_HRB_243294?=
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de
Subject: Re: + timer_stats-slimmed-down-using-statistics-infrastucture.patch
 added to -mm tree
References: <200704210018.l3L0IJBN027188@shell0.pdx.osdl.net> <1179082720.19106.4.camel@laptopd505.fenrus.org> <46481D18.7080302@de.ibm.com> <1179187579.3654.0.camel@laptopd505.fenrus.org>
In-Reply-To: <1179187579.3654.0.camel@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Mon, 2007-05-14 at 10:26 +0200, Martin Peschke wrote:
>>>> [root@t2930041 timer_stats]# cat data
>>> this patch changes the userspace API though, and breaks PowerTOP :(
>> Though I think it was unfortunate to add the "old" proc API in 2.6.21.
>> timer_stats is clearly labeled as debug stuff in config help, which is why 
>> debugfs would have been a proper place.
> 
> but it's not there, it's in it's current place. And userspace apps
> depend on it...

mea culpa

> so what's the reason to change this after it became ABI ?

A sort of race condition ;-)

I posted this as an RFC when one of the last 2.6.21-rc's came out, that is 
timerstats wasn't ABI yet, anticipating that I was late anyway.

> If there's a good one I can fix powertop..

  kernel/time/timer_stats.c |  385 +++++-------------------------------
  kernel/timer.c            |    2
  2 files changed, 59 insertions(+), 328 deletions(-)

It would be similar for other kernel code I have looked at.
And I think there would be an advantage if one was able to understand device 
driver A's statistics code immediately because it was written against some 
common library functions.

But it isn't easy to get this interface into the kernel by finding users.
I have got to "intercept" candidates before they add some own ABI to proc or 
whereever, while I can't change established statistics.

In short, if you would like to help in this case, I would appreciate it.

> but.... oh well I hope you kept the rest of the file format the same ;)

Almost. Though, there might be ways to keep the old format totally unchanged.
It would be a matter of stretching the concepts of a unified user interface for 
statistics.

Currently, my format comes with a substring representing <statistics name> 
<basket> preceding each line, which currently reads "expired - " plus the line 
powertop is familiar with.

Would it be feasible to to teach powertop to skip the first two elements?


Martin

