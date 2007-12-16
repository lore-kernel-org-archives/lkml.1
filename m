Return-Path: <linux-kernel-owner+w=401wt.eu-S932700AbXLPKNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932700AbXLPKNT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 05:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759692AbXLPKNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 05:13:04 -0500
Received: from bizon.gios.gov.pl ([212.244.124.8]:44673 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765939AbXLPKNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 05:13:01 -0500
Date: Sun, 16 Dec 2007 11:12:20 +0100 (CET)
From: Krzysztof Oledzki <olel@ans.pl>
X-X-Sender: olel@bizon.gios.gov.pl
To: mingo@elte.hu
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Osterried <osterried@jesse.de>, protasnb@gmail.com,
       bugme-daemon@bugzilla.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bug 9182] Critical memory leak (dirty pages)
In-Reply-To: <20071216095834.1B899108069@picon.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0712161103010.25065@bizon.gios.gov.pl>
References: <20071216095834.1B899108069@picon.linux-foundation.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-2058317769-1197799940=:25065"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-2058317769-1197799940=:25065
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Sun, 16 Dec 2007, bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=3D9182
>
>
>
>
>
> ------- Comment #39 from mingo@elte.hu  2007-12-16 01:58 -------
>
>> So:
>>   - 2.6.20-rc1: OK
>>   - 2.6.20-rc1-git8 with fba2591bf4e418b6c3f9f8794c9dd8fe40ae7bd9 revert=
ed: OK
>>   - 2.6.20-rc1-git8: very BAD
>>   - 2.6.20-rc2: very BAD
>>   - 2.6.20-rc4: very BAD
>>   - >=3D 2.6.20: BAD (but not *very* BAD!)
>
> based on the great info you already acquired, you should be able to
> bisect this rather effectively, via:
>
> 2.6.20-rc1-git8 =3D=3D 921320210bd2ec4f17053d283355b73048ac0e56
>
> $ git-bisect start
> $ git-bisect bad 921320210bd2ec4f17053d283355b73048ac0e56
> $ git-bisect good v2.6.20-rc1
> Bisecting: 133 revisions left to test after this
>
> so about 7-8 bootups would pinpoint the breakage.

Except that I have very limited time where I can do my tests on this host.=
=20
Please also note that it takes about ~2h after a reboot, to be 100% sure.=
=20
So, 7-8 bootups =3D> 14-16h. :|

> It would likely pinpoint fba2591b, so it would perhaps be best to first
> attempt a revert of fba2591b on a recent kernel.

I wish I could: :(

ole@cougar:/usr/src/linux-2.6.23.9$ cat ..p1 |patch -p1 --dry-run -R
patching file fs/hugetlbfs/inode.c
Hunk #1 succeeded at 203 (offset 27 lines).
patching file include/linux/page-flags.h
Hunk #1 succeeded at 262 (offset 9 lines).
patching file mm/page-writeback.c
Hunk #1 succeeded at 903 (offset 58 lines).
patching file mm/truncate.c
Unreversed patch detected!  Ignore -R? [n] y
Hunk #1 succeeded at 52 with fuzz 2 (offset 1 line).
Hunk #2 FAILED at 85.
Hunk #3 FAILED at 365.
Hunk #4 FAILED at 400.
3 out of 4 hunks FAILED -- saving rejects to file mm/truncate.c.rej

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-2058317769-1197799940=:25065--
