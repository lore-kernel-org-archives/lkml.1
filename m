Return-Path: <linux-kernel-owner+w=401wt.eu-S1756628AbXLLN33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628AbXLLN33 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 08:29:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752489AbXLLN3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 08:29:15 -0500
Received: from bizon.gios.gov.pl ([212.244.124.8]:47032 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510AbXLLN3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 08:29:13 -0500
Date: Wed, 12 Dec 2007 14:28:48 +0100 (CET)
From: Krzysztof Oledzki <olel@ans.pl>
X-X-Sender: olel@bizon.gios.gov.pl
To: bugme-daemon@bugzilla.kernel.org
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [Bug 9182] Critical memory leak (dirty pages)
In-Reply-To: <Pine.LNX.4.64.0712111844510.21312@bizon.gios.gov.pl>
Message-ID: <Pine.LNX.4.64.0712121419490.21312@bizon.gios.gov.pl>
References: <20071205213750.14194108010@picon.linux-foundation.org>
 <Pine.LNX.4.64.0712052238520.21312@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0712111844510.21312@bizon.gios.gov.pl>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-23993542-1197466128=:21312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-23993542-1197466128=:21312
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Tue, 11 Dec 2007, Krzysztof Oledzki wrote:

>
>
> On Wed, 5 Dec 2007, Krzysztof Oledzki wrote:
>
>>=20
>>=20
>> On Wed, 5 Dec 2007, bugme-daemon@bugzilla.kernel.org wrote:
>>=20
>>> http://bugzilla.kernel.org/show_bug.cgi?id=3D9182
>>>=20
>>>=20
>>> ------- Comment #20 from akpm@osdl.org  2007-12-05 13:37 -------
>>> Please monitor the "Dirty:" record in /proc/meminfo.  Is it slowly risi=
ng
>>> and never falling?
>>=20
>> It is slowly rising with respect to a small fluctuation caused by a curr=
ent=20
>> load.
>>=20
>>> Does it then fall if you run /bin/sync?
>> Only a little, by ~1-2MB like in a normal system. But it is not able to=
=20
>> fall below a local minimum. So, after a first sync it does not fall more=
=20
>> with additional synces.
>>=20
>>> Compile up usemem.c from
>>> http://www.zip.com.au/~akpm/linux/patches/stuff/ext3-tools.tar.gz and r=
un
>>>=20
>>> usemem -m <N>
>>>=20
>>> where N is the number of megabytes whcih that machine has.
>>=20
>> It has 2GB but:
>>=20
>> # ./usemem -m 1662 ; echo $?
>> 0
>>=20
>> # ./usemem -m 1663 ; echo $?
>> ./usemem: mmap failed: Cannot allocate memory
>> 1
>>
>>>  Did this cause /proc/meminfo:Dirty to fall?
>> No.
>
> OK, I booted a kernel without 2:2 memsplit but instead with a standard=20
> 3.1:0.9 and even without highmem. So, now I have ~900MB and I am able to =
set=20
> -m to the number of megabytes which themachine has. However, usemem still=
=20
> does does not cause dirty memory usage to fall. :(

OK, I can confirm that this is a regression from 2.6.18 where it works OK:

ole@cougar:~$ uname -r
2.6.18.8

ole@cougar:~$ uptime;grep Dirt /proc/meminfo;sync;sleep 2;sync;sleep 1;sync=
;grep Dirt /proc/meminfo
  14:21:53 up  1:00,  1 user,  load average: 0.23, 0.36, 0.35
Dirty:             376 kB
Dirty:               0 kB

It seems that this leak also exists in my other system as even after many=
=20
synces number of dirty pages are still >> 0, but this the only one where=20
it is so critical and at the same time - so easy to reproduce.

Best regards,


 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-23993542-1197466128=:21312--
