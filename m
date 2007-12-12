Return-Path: <linux-kernel-owner+w=401wt.eu-S1752550AbXLLR2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbXLLR2G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 12:28:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750820AbXLLR1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 12:27:55 -0500
Received: from wr-out-0506.google.com ([64.233.184.227]:59449 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbXLLR1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 12:27:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Wu4wkfJ8eUgCnSXI6Aw5n6o6Szsh+SfMP7fXxpkEHMIY09GKN2de9Rhykk1DTtjDIbMn3oKog1Up+7V1iU9vY/vJoCWXt9mZZ4dj+jbHHILhVYBA1qEqCY61A0I7sx2H0RTywM6Hwo8H400KUyzAidb93k0wxhO38pOWVLwPzh8=
Message-ID: <47601A12.2040103@gmail.com>
Date: Wed, 12 Dec 2007 19:27:46 +0200
From: =?ISO-8859-15?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: Rene Herman <rene.herman@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, dpreed@reed.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, pavel@ucw.cz, andi@firstfloor.org,
       rol@as2917.net, Krzysztof Halasa <khc@pm.waw.pl>, david@davidnewall.com,
       hpa@zytor.com, john@stoffel.org, linux-os@analogic.com
Subject: Re: [RFT] Port 0x80 I/O speed
References: <475F1DC6.5090403@keyaccess.nl>
In-Reply-To: <475F1DC6.5090403@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> Good day.
>
> Would some people on x86 (both 32 and 64) be kind enough to compile
> and run the attached program? This is about testing how long I/O port
> access to port 0x80 takes. It measures in CPU cycles so CPU speed is
> crucial in reporting.
>
> Posted a previous incarnation of this before, buried in the outb 0x80
> thread which had a serialising problem. This one should as far as I
> can see measure the right thing though. Please yell if you disagree...
>
Hi,

Tested on 2 systems.

System I
------------
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 47
model name      : AMD Athlon(tm) 64 Processor 3200+
stepping        : 2
cpu MHz         : 2000.000
cache size      : 512 KB
fpu             : yes
fpu_exception   : yes

Motherboard: Asus A9N-E


With -m32:

edwin@lightspeed2:~$ sudo ./port80
cycles: out 1107, in 1067
edwin@lightspeed2:~$ sudo ./port80
cycles: out 1107, in 1067
edwin@lightspeed2:~$ sudo ./port80
cycles: out 1107, in 1067
edwin@lightspeed2:~$ sudo ./port80
cycles: out 1107, in 1067
edwin@lightspeed2:~$ sudo ./port80
cycles: out 1107, in 1067
edwin@lightspeed2:~$ sudo ./port80
cycles: out 619, in 583
edwin@lightspeed2:~$ sudo ./port80
cycles: out 619, in 583
edwin@lightspeed2:~$ sudo ./port80
cycles: out 1107, in 1067
edwin@lightspeed2:~$ sudo ./port80
cycles: out 1107, in 1067
edwin@lightspeed2:~$ sudo ./port80
cycles: out 1107, in 1067
edwin@lightspeed2:~$ sudo ./port80
cycles: out 1107, in 1067
edwin@lightspeed2:~$ sudo ./port80
cycles: out 1107, in 1067

After making the __asm__ __volatile__ ("rdtsc" : "=a" (lo), "=d" (hi));
I get this with 64:
edwin@lightspeed2:~$ sudo ./port80
cycles: out 1107, in 1067
edwin@lightspeed2:~$ sudo ./port80
cycles: out 1107, in 1067
edwin@lightspeed2:~$ sudo ./port80
cycles: out 1107, in 1067
edwin@lightspeed2:~$ sudo ./port80
cycles: out 1107, in 1067
edwin@lightspeed2:~$ sudo ./port80
cycles: out 1107, in 1067
edwin@lightspeed2:~$ sudo ./port80
cycles: out 1107, in 1067
edwin@lightspeed2:~$ sudo ./port80
cycles: out 1107, in 1067
edwin@lightspeed2:~$ sudo ./port80
cycles: out 1107, in 1067
edwin@lightspeed2:~$ sudo ./port80
cycles: out 618, in 583
edwin@lightspeed2:~$ sudo ./port80
cycles: out 618, in 583
edwin@lightspeed2:~$ sudo ./port80
cycles: out 1107, in 1067

If I stop cpudyn I get a constant 618/583.

System II
------------

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 14
model name      : Genuine Intel(R) CPU           T2300  @ 1.66GHz
stepping        : 8
cpu MHz         : 1667.000
cache size      : 2048 KB
physical id     : 0
siblings        : 2

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 14
model name      : Genuine Intel(R) CPU           T2300  @ 1.66GHz
stepping        : 8
cpu MHz         : 1667.000
cache size      : 2048 KB
physical id     : 0
siblings        : 2


Dell Inspiron 6400, Intel Core Duo (ICH7 chipset)

thunder:/home/edwin# ./port80
cycles: out 2480, in 1867
thunder:/home/edwin# ./port80
cycles: out 2482, in 1865
thunder:/home/edwin# ./port80
cycles: out 2968, in 1893
thunder:/home/edwin# ./port80
cycles: out 1991, in 1372
thunder:/home/edwin# ./port80
cycles: out 1979, in 1366
thunder:/home/edwin# ./port80
cycles: out 2473, in 1865
thunder:/home/edwin# ./port80
cycles: out 2484, in 1869

After setting CPU governor to performance:

# ./port80
cycles: out 2368, in 1783
thunder:/home/edwin# ./port80
cycles: out 2377, in 1783
thunder:/home/edwin# ./port80
cycles: out 2367, in 1774
thunder:/home/edwin# ./port80
cycles: out 2370, in 1780
thunder:/home/edwin# ./port80
cycles: out 2365, in 1782
thunder:/home/edwin# ./port80
cycles: out 2369, in 1774
thunder:/home/edwin# ./port80
cycles: out 2366, in 1784
thunder:/home/edwin# ./port80
cycles: out 2379, in 1786
thunder:/home/edwin# ./port80
cycles: out 2367, in 1773
thunder:/home/edwin# ./port80
cycles: out 2376, in 1783
thunder:/home/edwin# ./port80
cycles: out 2360, in 1784
thunder:/home/edwin# ./port80
cycles: out 2367, in 1783
thunder:/home/edwin# ./port80
cycles: out 2370, in 1783
thunder:/home/edwin# ./port80
cycles: out 2382, in 1782

Also tried in a loop, but values are not constant:
while true; do ./port80; done
cycles: out 2415, in 1818
cycles: out 2405, in 1817
cycles: out 2414, in 1810
cycles: out 2411, in 1819
cycles: out 2407, in 1821
cycles: out 2410, in 1820
cycles: out 2418, in 1821
cycles: out 2408, in 1847
cycles: out 2404, in 1805
cycles: out 2411, in 1858
cycles: out 2395, in 1765
cycles: out 2377, in 1786
cycles: out 2378, in 1813
cycles: out 2395, in 1800
cycles: out 2381, in 1793
cycles: out 2382, in 1790
cycles: out 2399, in 1835
cycles: out 1928, in 1327
cycles: out 2410, in 1781
cycles: out 1996, in 1287
cycles: out 2369, in 1768
cycles: out 2401, in 1805
cycles: out 2395, in 1802
cycles: out 2389, in 1786
cycles: out 2359, in 1768
cycles: out 2495, in 1858
cycles: out 2408, in 1809
cycles: out 2919, in 1859
cycles: out 2404, in 1798
cycles: out 2393, in 1791
cycles: out 2882, in 1797
cycles: out 2404, in 1789
cycles: out 2406, in 1785
cycles: out 2393, in 1840
cycles: out 2498, in 1818
cycles: out 2402, in 1805
cycles: out 2888, in 1858
cycles: out 2397, in 1802
cycles: out 2411, in 1810
cycles: out 2396, in 1788
cycles: out 2362, in 1780
cycles: out 2861, in 1785
cycles: out 2380, in 1780
cycles: out 2357, in 1785
cycles: out 2342, in 1783
cycles: out 1916, in 1294
cycles: out 2358, in 1768
cycles: out 2371, in 1763
cycles: out 2386, in 1783
cycles: out 1919, in 1320
cycles: out 2355, in 1782
cycles: out 2330, in 1787
cycles: out 2350, in 1781
cycles: out 1881, in 1269
cycles: out 2378, in 1768
cycles: out 2381, in 1739
cycles: out 2365, in 1768
cycles: out 2362, in 1759
cycles: out 2368, in 1739
cycles: out 2354, in 1775
cycles: out 2375, in 1783
cycles: out 2369, in 1785
cycles: out 2361, in 1769
cycles: out 2382, in 1785
cycles: out 2370, in 1783


--Edwin
