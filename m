Return-Path: <linux-kernel-owner+w=401wt.eu-S1754503AbZKIUQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbZKIUQF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 15:16:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754412AbZKIUQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 15:16:04 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:38441 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754388AbZKIUQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 15:16:03 -0500
Date: Mon, 9 Nov 2009 20:16:08 +0000
To: Matteo Croce <technoboy85@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
Message-ID: <20091109201608.GD15159@caffeine.csclub.uwaterloo.ca>
References: <40101cc30910021912r17b3a08bue1b9412e4fa47d89@mail.gmail.com> <20091003072127.GC21407@elte.hu> <40101cc30911060659k7b3b6428ob1340e476bdbac5b@mail.gmail.com> <4AF4526B.4060101@zytor.com> <40101cc30911081042n93e268bs66b9436a0174a19a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40101cc30911081042n93e268bs66b9436a0174a19a@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 08, 2009 at 07:42:48PM +0100, Matteo Croce wrote:
> There is a small advantage, but considering that GCC isn't much geode aware yet
> there is stil room for improvement IMHO:

Perhaps gcc considers geode to mean geode GX[m12] not geode LX (which is
newer and the one in question here).

The Geode GX line prefers i486 code to i586 code (which appears to be
what -march=geode is for).  I am using i486 at the moment when I build
for this one.

The Geode LX is what is being discussed which is in fact mostly a K6 as
far as I understand things.  It seems to like i686 code, other than
apparently those NOP instructions.  I wonder if the K6 has those noop
instructions and if not, perhaps gcc 4.4's -march=k6-3 would be the
right choice.  I have always suspected the LX was really a K6-3 based
design (the cache sizes are a bit different, but clock speeds and
instruction sets seem to match).

The Geode NX (which no one has mentioned yet) is an Athlon derived chip.

> root@alix:/usr/src/dist# ll
> totale 257M
> -rwxr-xr-x 1 1000 src  93K  8 nov  2009 bzip2-i586
> -rwxr-xr-x 1 1000 src  93K  8 nov  2009 bzip2-i686
> -rwxr-xr-x 1 1000 src  60K  8 nov  2009 gzip-i586
> -rwxr-xr-x 1 1000 src  60K  8 nov  2009 gzip-i686
> -rw-r--r-- 1 1000 src 256M  8 nov  2009 linux-2.6.31.5.tar
> -rwxr-xr-x 1 1000 src  90K  8 nov  2009 lzma-i586
> -rwxr-xr-x 1 1000 src  94K  8 nov  2009 lzma-i686
> root@alix:/usr/src/dist# time cat linux-2.6.31.5.tar >/dev/null
> 
> real    0m10.168s
> user    0m0.030s
> sys     0m1.390s
> root@alix:/usr/src/dist# time ./gzip-i586 -9 < linux-2.6.31.5.tar >/dev/null
> 
> real    5m22.331s
> user    5m10.820s
> sys     0m11.170s
> root@alix:/usr/src/dist# time ./gzip-i686 -9 < linux-2.6.31.5.tar >/dev/null
> 
> real    5m3.737s
> user    4m51.880s
> sys     0m11.510s
> root@alix:/usr/src/dist# time ./bzip2-i586 -9 < linux-2.6.31.5.tar >/dev/null
> 
> real    9m16.539s
> user    9m4.410s
> sys     0m11.760s
> root@alix:/usr/src/dist# time ./bzip2-i686 -9 < linux-2.6.31.5.tar >/dev/null
> 
> real    8m48.682s
> user    8m34.950s
> sys     0m13.260s

-- 
Len Sorensen
