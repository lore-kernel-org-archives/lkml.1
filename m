Return-Path: <linux-kernel-owner+w=401wt.eu-S1762174AbXLOXJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762174AbXLOXJh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 18:09:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753267AbXLOXJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 18:09:29 -0500
Received: from bizon.gios.gov.pl ([212.244.124.8]:60348 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195AbXLOXJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 18:09:28 -0500
Date: Sun, 16 Dec 2007 00:08:52 +0100 (CET)
From: Krzysztof Oledzki <olel@ans.pl>
X-X-Sender: olel@bizon.gios.gov.pl
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Osterried <osterried@jesse.de>, protasnb@gmail.com,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bug 9182] Critical memory leak (dirty pages)
In-Reply-To: <20071215221935.306A5108068@picon.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0712152358240.14491@bizon.gios.gov.pl>
References: <20071215221935.306A5108068@picon.linux-foundation.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-1628307171-1197760132=:14491"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-1628307171-1197760132=:14491
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Sat, 15 Dec 2007, bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=3D9182
>
>
> ------- Comment #33 from protasnb@gmail.com  2007-12-15 14:19 -------
> Krzysztof, I'd hate point you to a hard path (at least time consuming), b=
ut
> you've done a lot of digging by now anyway. How about git bisecting betwe=
en
> 2.6.20-rc2 and rc1? Here is great info on bisecting:
> http://www.kernel.org/doc/local/git-quick.html

As I'm smarter than git-bistect I can tell that 2.6.20-rc1-git8 is as bad=
=20
as 2.6.20-rc2 but 2.6.20-rc1-git8 with one patch reverted seems to be OK.=
=20
So it took me only 2 reboots. ;)

The guilty patch is the one I proposed just an hour ago:
  http://git.kernel.org/?p=3Dlinux%2Fkernel%2Fgit%2Fstable%2Flinux-2.6.20.y=
=2Egit;a=3Dcommitdiff_plain;h=3Dfba2591bf4e418b6c3f9f8794c9dd8fe40ae7bd9

So:
  - 2.6.20-rc1: OK
  - 2.6.20-rc1-git8 with fba2591bf4e418b6c3f9f8794c9dd8fe40ae7bd9 reverted:=
 OK
  - 2.6.20-rc1-git8: very BAD
  - 2.6.20-rc2: very BAD
  - 2.6.20-rc4: very BAD
  - >=3D 2.6.20: BAD (but not *very* BAD!)

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1628307171-1197760132=:14491--
