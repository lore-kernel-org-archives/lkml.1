Return-Path: <linux-kernel-owner+w=401wt.eu-S1756847AbYCZI6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847AbYCZI6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 04:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753247AbYCZI6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 04:58:11 -0400
Received: from isuela.unizar.es ([155.210.1.53]:34397 "EHLO relay.unizar.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753233AbYCZI6K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 04:58:10 -0400
X-Greylist: delayed 1948 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Mar 2008 04:58:09 EDT
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>
Message-Id: <8CAC9F9E-60FE-40A5-A720-27BA63BEEADC@ono.com>
From: "=?ISO-8859-1?Q?=22J.A._Magall=F3n=22?=" <jamagallon@ono.com>
To: Emmanuel Florac <eflorac@intellique.com>
In-Reply-To: <20080326090527.42286e8e@galadriel.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed; delsp=yes
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: RAID-1 performance under 2.4 and 2.6
Date: Wed, 26 Mar 2008 09:25:29 +0100
References: <20080325194306.4ac71ff2@galadriel.home> <47E975F8.3000702@redhat.com> <47E98108.9000906@tmr.com> <47E98712.6090203@redhat.com> <47E98DE4.9000906@tmr.com> <20080326090527.42286e8e@galadriel.home>
X-Mailer: Apple Mail (2.919.2)
X-Mail-Scanned: Criba 2.0 + Clamd & Bogofilter
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2008.03.26, at 09:05, Emmanuel Florac wrote:
> Le Tue, 25 Mar 2008 19:42:28 -0400 vous écriviez:
>
>> And this is what I was saying earlier, there is a trend to blame the
>> benchmark when in fact the same benchmark runs well on 2.4.
>
> As I mentioned, it looks like 2.4 actually buffers write data on  
> RAID-1
> which is inherently bad (after all if I do RAID-1 it's for the sake of
> data integrity, and write caching just counters that).

Not bad, it buffer flushing is secure. You just have 'one buffer size'
delay. If your system crashes, think it just crashed 'one buffer size'
before...

>
> However, how bad dd may be, it reflects broadly my problem : on small
> systems using software RAID, IO is overall way better with 2.4 than
> 2.6, especially NFS thruput.
> Though I can substantially enhance 2.6 performance through tweaking
> (playing with read ahead, disk queue length etc), it still lags behind
> 2.4 with defaults settings by a clear margin (10% or more).
> This isn't true - fortunately - of larger systems with 12, 24, 48  
> disks
> drives, hardware RAID, Fibre Channel and al.
>
>

But you shouldn't have to tweak anything.
Let's forget for a moment calling dd a 'benchmark'. The fact is that a
certain program (in its default behaviour, dd if=xxx of=yyy) is waaay
slower in 2.6 than in 2.4. So something has gone nuts.
The typical question is 'who cares dd ?'. And the answer: all normal
applications that just read and write, that do not use any *advise()
because they tried to be portable, that are not rewritten and fancy
optimized to take advantage of latest kernel knobs, in short, any normal
app that just fopen()s and fread()s...
Seriously, are people telling that I have to tweak my app to get the
same performance that in 2.4 ? The basic performance should be the same,
and all those knobs should let you get _better_ throughput, not just the
same. To say anything else is to hide the head on the floor...

--
J.A. Magallon <jamagallon()ono!com>     \              Software is  
like sex:
                                          \        It's better when  
it's free
Mandriva Linux release 2008.1 (Cooker) for i586



