Return-Path: <linux-kernel-owner+w=401wt.eu-S1757275AbXLQRSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275AbXLQRSj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 12:18:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753524AbXLQRSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 12:18:32 -0500
Received: from bizon.gios.gov.pl ([212.244.124.8]:49690 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964AbXLQRSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 12:18:31 -0500
Date: Mon, 17 Dec 2007 18:17:41 +0100 (CET)
From: Krzysztof Oledzki <olel@ans.pl>
X-X-Sender: olel@bizon.gios.gov.pl
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Osterried <osterried@jesse.de>, protasnb@gmail.com,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bug 9182] Critical memory leak (dirty pages)
In-Reply-To: <20071216135112.0b58ab74.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0712171750240.18593@bizon.gios.gov.pl>
References: <20071215221935.306A5108068@picon.linux-foundation.org>
 <Pine.LNX.4.64.0712152358240.14491@bizon.gios.gov.pl>
 <20071215203539.d6f71e96.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0712161016290.25065@bizon.gios.gov.pl>
 <20071216015112.d0ab08a1.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0712161440030.25065@bizon.gios.gov.pl>
 <20071216135112.0b58ab74.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-1126313559-1197911861=:18593"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-1126313559-1197911861=:18593
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Sun, 16 Dec 2007, Andrew Morton wrote:

> On Sun, 16 Dec 2007 14:46:36 +0100 (CET) Krzysztof Oledzki <olel@ans.pl> =
wrote:
>
>>>>> Which filesystem, which mount options
>>>>
>>>>   - ext3 on RAID1 (MD): / - rootflags=3Ddata=3Djournal
>>>
>>> It wouldn't surprise me if this is specific to data=3Djournal: that
>>> journalling mode is pretty complex wrt dairty-data handling and isn't w=
ell
>>> tested.
>>>
>>> Does switching that to data=3Dwriteback change things?
>>
>> I'll confirm this tomorrow but it seems that even switching to
>> data=3Dordered (AFAIK default o ext3) is indeed enough to cure this prob=
lem.
>
> yes, sorry, I meant ordered.

OK, I can confirm that the problem is with data=3Djournal. With data=3Dorde=
red=20
I get:

# uname -rns;uptime;sync;sleep 1;sync ;sleep 1; sync;grep Dirty /proc/memin=
fo
Linux cougar 2.6.24-rc5
  17:50:34 up 1 day, 20 min,  1 user,  load average: 0.99, 0.48, 0.35
Dirty:               0 kB

>> Two questions remain then: why system dies when dirty reaches ~200MB
>
> I think you have ~2G of RAM and you're running with
> /proc/sys/vm/dirty_ratio=3D10, yes?
>
> If so, when that machine hits 10% * 2G of dirty memory then everyone who
> wants to dirty pages gets blocked.

Oh, right. Thank you for the explanation.

>> and what is wrong with ext3+data=3Djournal with >=3D2.6.20-rc2?
>
> Ah.  It has a bug in it ;)
>
> As I said, data=3Djournal has exceptional handling of pagecache data and =
is
> not well tested.  Someone (and I'm not sure who) will need to get in ther=
e
> and fix it.

OK, I'm willing to test it. ;)

Best regrds,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1126313559-1197911861=:18593--
