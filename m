Return-Path: <linux-kernel-owner+w=401wt.eu-S1759556AbYEPSxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759556AbYEPSxQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 14:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762378AbYEPSul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 14:50:41 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40366 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762348AbYEPSuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 14:50:39 -0400
Date: Fri, 16 May 2008 11:50:38 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: =?ISO-8859-1?Q?St=E9phane_ANCELOT?= <sancelot@free.fr>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: detecting kernel mem leak
In-Reply-To: <482D4CC8.2050501@free.fr>
Message-ID: <Pine.LNX.4.64.0805161148170.3113@schroedinger.engr.sgi.com>
References: <1209462094.4816ed4e93977@imp.free.fr>
 <84144f020804290546h666983aci77fbb08eb507e777@mail.gmail.com>
 <Pine.LNX.4.64.0804290956360.10847@schroedinger.engr.sgi.com>
 <4821C526.8030901@free.fr> <Pine.LNX.4.64.0805071020210.3173@schroedinger.engr.sgi.com>
 <4829566B.7090804@free.fr> <Pine.LNX.4.64.0805151036030.18708@schroedinger.engr.sgi.com>
 <482D4CC8.2050501@free.fr>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1700579579-2072485358-1210963838=:3113"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1700579579-2072485358-1210963838=:3113
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Fri, 16 May 2008, St=E9phane ANCELOT wrote:

> In the kernel, there is SLAB or SLUB , my kernel is at this time configur=
ed
> for SLAB allocator.

SLAB does not support the slabinfo tool. It only supports /proc/slabinfo.

> it is documented SLUB minimizes cache line usage.
> Do you think I have to switch to SLUB ?

If you want to use the slabinfo tool then yes.

> 2) regarding memory debugging, your reply and some mesages told it was no=
rmal
> the memory was growing (with ext3 buffer_heads...) and released on demand=
=2E
> This sounds to me it becomes VERY VERY difficult telling if my system is
> STABLE or NOT. Is there a way to bypass it ?

This the basic design of memory handling in Linux. Why would the use of=20
memory mean that your system is unstable?

> I assume I have to do some kind of small program trying to allocate almos=
t the
> full remaining memory available at startup to empty caches ?

There is a way to drop caches. See what you can do with=20
/proc/sys/vm/drop_caches

f.e.

echo 1 >/proc/sys/vm/drop_caches
echo 2 >/proc/sys/vm/drop_caches

Should free most of memory.

---1700579579-2072485358-1210963838=:3113--
