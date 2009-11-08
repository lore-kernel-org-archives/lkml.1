Return-Path: <linux-kernel-owner+w=401wt.eu-S1754887AbZKHSnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbZKHSnH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 13:43:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754809AbZKHSnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 13:43:06 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:63818 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754745AbZKHSnE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 13:43:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Hw3oVIqO3X5ZxggO/BfmcCH+jskiBh4l7ifWMUgLRs8wTlGelAJJQtRzC9Ik5p3sfi
         qyqQI62TbMSpOqyan9QOJoa+kymjgtiXqup6qTlvmFFSBj6OXzAUhpA7VfNw8XbIK5LZ
         NP3/BCHDKnJBqsGeABhTjPOEb7NiN/D1wJjPI=
MIME-Version: 1.0
In-Reply-To: <4AF4526B.4060101@zytor.com>
References: <40101cc30910021912r17b3a08bue1b9412e4fa47d89@mail.gmail.com> 
	<20091003072127.GC21407@elte.hu> <40101cc30911060659k7b3b6428ob1340e476bdbac5b@mail.gmail.com> 
	<4AF4526B.4060101@zytor.com>
From: Matteo Croce <technoboy85@gmail.com>
Date: Sun, 8 Nov 2009 19:42:48 +0100
Message-ID: <40101cc30911081042n93e268bs66b9436a0174a19a@mail.gmail.com>
Subject: Re: i686 quirk for AMD Geode
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 6, 2009 at 5:44 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 11/06/2009 06:59 AM, Matteo Croce wrote:
>> indeed it has MMX, MMXEXT and CMOV, just lacks the long NOP instruction (NOPL).
>
> MMX and MMXEXT are hardly hallmarks of i686, which leaves only cmov.
> I'm somewhat wondering about the general value of this patch; is i686
> code really that much faster on Geode that it's worth it?
>
>        -hpa
>
> --
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.
>
>

There is a small advantage, but considering that GCC isn't much geode aware yet
there is stil room for improvement IMHO:

root@alix:/usr/src/dist# ll
totale 257M
-rwxr-xr-x 1 1000 src  93K  8 nov  2009 bzip2-i586
-rwxr-xr-x 1 1000 src  93K  8 nov  2009 bzip2-i686
-rwxr-xr-x 1 1000 src  60K  8 nov  2009 gzip-i586
-rwxr-xr-x 1 1000 src  60K  8 nov  2009 gzip-i686
-rw-r--r-- 1 1000 src 256M  8 nov  2009 linux-2.6.31.5.tar
-rwxr-xr-x 1 1000 src  90K  8 nov  2009 lzma-i586
-rwxr-xr-x 1 1000 src  94K  8 nov  2009 lzma-i686
root@alix:/usr/src/dist# time cat linux-2.6.31.5.tar >/dev/null

real    0m10.168s
user    0m0.030s
sys     0m1.390s
root@alix:/usr/src/dist# time ./gzip-i586 -9 < linux-2.6.31.5.tar >/dev/null

real    5m22.331s
user    5m10.820s
sys     0m11.170s
root@alix:/usr/src/dist# time ./gzip-i686 -9 < linux-2.6.31.5.tar >/dev/null

real    5m3.737s
user    4m51.880s
sys     0m11.510s
root@alix:/usr/src/dist# time ./bzip2-i586 -9 < linux-2.6.31.5.tar >/dev/null

real    9m16.539s
user    9m4.410s
sys     0m11.760s
root@alix:/usr/src/dist# time ./bzip2-i686 -9 < linux-2.6.31.5.tar >/dev/null

real    8m48.682s
user    8m34.950s
sys     0m13.260s
