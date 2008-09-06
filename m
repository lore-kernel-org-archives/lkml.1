Return-Path: <linux-kernel-owner+w=401wt.eu-S1753064AbYIFBXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064AbYIFBXa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 21:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751640AbYIFBXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 21:23:22 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:61866 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbYIFBXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 21:23:21 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=BdgKl3PTBkXPoYIcGc8A:9 a=c50arj2azqEt6alBQusA:7 a=nOQoQPcYK7dZZNYh0ruEE_beaUgA:4
Message-ID: <48C1DB85.6020605@shaw.ca>
Date: Fri, 05 Sep 2008 19:23:17 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?=22J=2EA=2E_Magall=F3n=22?= <jamagallon@ono.com>
CC: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: iozone lies/bug ?
References: <fa.g18ZP/j70dwkyZRjfglzPcKZzdc@ifi.uio.no>
In-Reply-To: <fa.g18ZP/j70dwkyZRjfglzPcKZzdc@ifi.uio.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

J.A. Magallón wrote:
> Hi all...
> 
> This is a curious thing, I think...
> I wanted to test the speed of an usb stick, and as a first step used hdparm
> on my root disk (real SCSI) and on the stick:
> 
> werewolf:/media/media# lsscsi
> [1:0:0:0]    disk    SEAGATE  ST336807LW       0C01  /dev/sda
> [1:0:1:0]    disk    SEAGATE  ST336807LW       0C01  /dev/sdb
> [2:0:0:0]    disk    ATA      ST3120022A       3.06  /dev/sdc
> [2:0:1:0]    cd/dvd  HL-DT-ST DVDRAM GSA-H10N  JL12  /dev/sr0
> [4:0:0:0]    disk    ATA      ST3200822AS      3.01  /dev/sdd
> [5:0:0:0]    disk    ATA      WDC WD3200AVJS-6 12.0  /dev/sde
> [7:0:0:0]    disk    USB      DISK 2.0         1219  /dev/sdf
> werewolf:/media/media# hdparm -tT /dev/sda /dev/sdf
> 
> /dev/sda:
>  Timing cached reads:   1402 MB in  2.00 seconds = 700.54 MB/sec
>  Timing buffered disk reads:  226 MB in  3.02 seconds =  74.86 MB/sec
> 
> /dev/sdf:
>  Timing cached reads:   1272 MB in  2.00 seconds = 635.69 MB/sec
>  Timing buffered disk reads:   52 MB in  3.02 seconds =  17.20 MB/sec
> 
> Well, looks reasonable.
> But, as hdparm is not a 'serious' test, and I wanted also write speed,
> used iozone:
> 
> werewolf:/media/media# iozone -v
>        'Iozone' Filesystem Benchmark Program
> 
>         Version $Revision: 3.287 $
>     Compiled for 32 bit mode.
> 
> But it gives strange results:
> 
> for sda1 (/):
> 
>     Machine = Linux werewolf.home 2.6.26-jam07 #1 SMP PREEMPT Mon Sep 1 01:47:23 C  Auto Mode
>     Auto Mode
>     File size set to 4096 KB
>     Command line used: iozone -M -a -s 4m
>     Output is in Kbytes/sec
>     Time Resolution = 0.000001 seconds.
>     Processor cache size set to 1024 Kbytes.
>     Processor cache line size set to 32 bytes.
>     File stride size set to 17 * record size.
>                                                             random  random    bkwd  record  stride
>               KB  reclen   write rewrite    read    reread    read   write    read rewrite    read   fwrite frewrite   fread  freread
>             4096       4  180855  742576  1275252  1130840 1143176  597607  998780 670266 1168616   231962   670815 1071129  1259145
>             4096       8  247673  809183  1246875  1407083 1351815  711728 1176673 854936 1298668   236817   744321 1233363  1519851
>             4096      16  251644  851010  1123131  1691931 1668431  716459 1094017 931544 1259145   245622   793337 1110328  1659643
>             4096      32  253245  871663  1463432  1764719 1808388  757396 1339875 885813 1393197   261107   796112 1128374  1742978
>             4096      64  254837  862332  1139037  1789405 1585752  779448 1136199 961728 1844214   259684   799687 1124965  1538114
>             4096     128  250090  868154  1177029  1715966 1700996  771810 1181084 980842 1643659   228405   792569 1003429  1720285
>             4096     256  242984  791959   950372   718080  930274  826472  694472 708038  913470   223751   566606  698737   918385
>             4096     512  238696  664406   764459   803304  720492  519335  727660 420102  686557   212735   416768  728695   695534
>             4096    1024  232926  667198   711975   773266  735896  689562  781828 663857  742297   253183   541297  658732   816912
>             4096    2048  243548  659167   653899   738807  728048  632684  638304 493137  599707   305011   660858  664180   792569
>             4096    4096  218417  655142   857449   732729  694826  696717  689098 557278  627643   242913   610705  713588   784073
> 
> for sdf1:
> 
>     Machine = Linux werewolf.home 2.6.26-jam07 #1 SMP PREEMPT Mon Sep 1 01:47:23 C  Auto Mode
>     Auto Mode
>     File size set to 4096 KB
>     Command line used: iozone -M -a -s 4m
>     Output is in Kbytes/sec
>     Time Resolution = 0.000001 seconds.
>     Processor cache size set to 1024 Kbytes.
>     Processor cache line size set to 32 bytes.
>     File stride size set to 17 * record size.
>                                                             random  random    bkwd  record  stride
>               KB  reclen   write rewrite    read    reread    read   write    read rewrite    read   fwrite frewrite   fread  freread
>             4096       4  391850  843302   885058  1159992  746900  704385  778707 566371  941825   481712   772247 1204705   795494
>             4096       8  385690  981087  1036709  1419270  945740  755162  978967 555842 1211475   390392   919622 1209329  1071970
>             4096      16  613438 1121897  1335497  1594434 1441745  683008 1217598 973152 1117903   558038  1014363 1144453  1552103
>             4096      32  559635  968335  1494912  1601847 1676627 1129619 1491081 1264978 1675941   604932  1051334 1217598  1629276
>             4096      64  627925 1197687  1557477  1697406 1573569 1082738 1589445 1237462 1755679   587830  1090812 1216513  1678000
>             4096     128  538446 1177653  1366266  1268879  963537  796422  981548 983197 1582077   428272   977099 1431167  1643000
>             4096     256  611078 1160652   907177  1041725 1114861 1214349 1088204 1161985  813343   454051   552021  919003   984852
>             4096     512  448633  912842   725981   782419  722526  983197  579103 870748  644937   432341   632684  718092   768336
>             4096    1024  473859  816750   717209   795504  738683  660964  694472 793337  716083   385070   699573  718092   760207
>             4096    2048  513161  789051   685059   768041  718974  652437  643418 639500  715583   486749   881049  715708   747854
>             4096    4096  505174  700760   835748   775173  786029  794414  797507 718470  594830   408904   835066  637608   670815
> 
> First, Output is not in Kb, or I have a disk that gives 1Gb/s... :).
> And second, how can both drives give the same ? The file is too small ?
> Do I need -e to iozone to account for sync ? But that would not affect read
> speed...
> Strange (for my understanding).

A file size of 4096KB is probably just running entirely out of the cache..
