Return-Path: <linux-kernel-owner+w=401wt.eu-S1761685AbXLOMeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761685AbXLOMeu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 07:34:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755999AbXLOMel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 07:34:41 -0500
Received: from bizon.gios.gov.pl ([212.244.124.8]:55204 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755877AbXLOMek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 07:34:40 -0500
Date: Sat, 15 Dec 2007 13:33:54 +0100 (CET)
From: Krzysztof Oledzki <olel@ans.pl>
X-X-Sender: olel@bizon.gios.gov.pl
To: Peter Zijlstra <peterz@infradead.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Osterried <osterried@jesse.de>, bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bug 9182] Critical memory leak (dirty pages)
In-Reply-To: <Pine.LNX.4.64.0712131655310.24173@bizon.gios.gov.pl>
Message-ID: <Pine.LNX.4.64.0712151324190.12202@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0709281005340.17152@bizon.gios.gov.pl> 
 <200709290614.02918.nickpiggin@yahoo.com.au>  <Pine.LNX.4.64.0712021603060.26896@bizon.gios.gov.pl>
  <200712030936.25363.osterried@jesse.de>  <Pine.LNX.4.64.0712131606410.24173@bizon.gios.gov.pl>
 <1197560671.6895.17.camel@twins> <Pine.LNX.4.64.0712131655310.24173@bizon.gios.gov.pl>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-1398310507-1197722034=:12202"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-1398310507-1197722034=:12202
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Thu, 13 Dec 2007, Krzysztof Oledzki wrote:

>
>
> On Thu, 13 Dec 2007, Peter Zijlstra wrote:
>
>>=20
>> On Thu, 2007-12-13 at 16:17 +0100, Krzysztof Oledzki wrote:
>>>=20
>>=20
>>> BTW: Could someone please look at this problem? I feel little ignored a=
nd
>>> in my situation this is a critical regression.
>>=20
>> I was hoping to get around to it today, but I guess tomorrow will have
>> to do :-/
>
> Thanks.
>
>> So, its ext3, dirty some pages, sync, and dirty doesn't fall to 0,
>> right?
>
> Not only doesn't fall but continuously grows.
>
>> Does it happen with other filesystems as well?
>
> Don't know. I generally only use ext3 and I'm afraid I'm not able to swit=
ch=20
> this system to other filesystem.
>
>> What are you ext3 mount options?
> /dev/root / ext3 rw,data=3Djournal 0 0
> /dev/VolGrp0/usr /usr ext3 rw,nodev,data=3Djournal 0 0
> /dev/VolGrp0/var /var ext3 rw,nodev,data=3Djournal 0 0
> /dev/VolGrp0/squid_spool /var/cache/squid/cd0 ext3=20
> rw,nosuid,nodev,noatime,data=3Dwriteback 0 0
> /dev/VolGrp0/squid_spool2 /var/cache/squid/cd1 ext3=20
> rw,nosuid,nodev,noatime,data=3Dwriteback 0 0
> /dev/VolGrp0/news_spool /var/spool/news ext3=20
> rw,nosuid,nodev,noatime,data=3Dordered 0 0

BTW: this regression also exists in 2.6.24-rc5. I'll try to find when it=20
was introduced but it is hard to do it on a highly critical production=20
system, especially since it takes ~2h after a reboot, to be sure.

However, 2h is quite good time, on other systems I have to wait ~2 months=
=20
to get 20MB of leaked memory:

# uptime
  13:29:34 up 58 days, 13:04,  9 users,  load average: 0.38, 0.27, 0.31

# sync;sync;sleep 1;sync;grep Dirt /proc/meminfo
Dirty:           23820 kB

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1398310507-1197722034=:12202--
