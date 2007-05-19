Return-Path: <linux-kernel-owner+w=401wt.eu-S1765313AbXESXW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765313AbXESXW2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 19:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932398AbXESXWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 19:22:14 -0400
Received: from neon.samage.net ([85.17.153.66]:39608 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765188AbXESXWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 19:22:12 -0400
Message-ID: <2741.81.207.0.53.1179616929.squirrel@secure.samage.net>
In-Reply-To: <464F7440.10900@garzik.org>
References: <20070519053532.GA32522@havoc.gtf.org>
    <1441.81.207.0.53.1179591630.squirrel@secure.samage.net>
    <464F7440.10900@garzik.org>
Date: Sun, 20 May 2007 01:22:09 +0200 (CEST)
Subject: Re: [PATCH] sata_sil: Greatly improve DMA support
From: "Indan Zupancic" <indan@nul.nu>
To: "Jeff Garzik" <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, "LKML" <linux-kernel@vger.kernel.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.8
X-Scan-Signature: 488b5a33f748713be529de57fa847022
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 20, 2007 00:03, Jeff Garzik wrote:
> Indan Zupancic wrote:
>> This patch seems to work with my SiI 3512, though I don't notice any
>> difference, neither a speedup, nor a slowdown. Hdparm gives the same
>> speeds (-tT), and cp -a'ing kernel sources is abysmal slow in both cases,
>> (need to look into that one) so I didn't really test it that well.
>
>
> It won't result in much of a speedup, except in situations where IOMMU
> or other situation that causes you to run into the 64k boundary being an
> issue -- generally only on huge transfers.
>
> A good measure is to dd(1) to/from the block device, rather than using a
> filesystem.  As has been shown on LKML, the filesystem can really slow
> things down in some cases.

I didn't really expect a speedup, it's more that I've no regression to report.

I could benchmark the patch more thoroughly, but right now I'm more worried
about the crawling cp I just discovered. Talking about filesystems slowing down
things...

Test:

$ cp -a linux-2.6/ /tmp/

done on the same ext3 partition. linux-2.6 contains source and git repo only,
I'm compiling stuff with O=../obj.

$ vmstat 10
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 0  1      0   4168   3316 195700    0    0   739   494  530  393 15  3 66 16
 0  3      4   4120   2040 198196    0    0 14677 14111 1247  435  0 17  0 83
 0  1      4   3588   1444 199696    0    0  8892  9472 1362  438  0 12  0 88
 1  0      4   3772   4228 196012    0    0   764   454 1161  345  0  4  0 96
 0  1      4   3548   6156 193088    0    0   793   851 1158  340  0  4  0 96
 0  1      4   3852   7608 189096    0    0   798   523 1160  474  1  4  0 95
 1  1      4   3612   8684 186048    0    0  1244   864 1178  430  2  5  0 93
 0  1      4  90660   9308  96396    0    0   853   906 1244  578  7  6  0 87
 0  1      4  72280   9816 112368    0    0   830   854 1278  429 12  5  0 83
 1  0      4  52488  10296 130560    0    0   935   861 1178  418  1  6  0 94
 0  1      4  30500  10788 149776    0    0   977   858 1178  371  0  6  0 94
 0  1      4   9792  11244 167856    0    0   918  1394 1182  350  1  5  0 94
 0  1      4   4016  11216 172504    0    0  1017   858 1181  382  1  6  0 94
 0  1      4   3660  11484 171484    0    0   966   861 1182  410  1  6  0 94

It never finished, as I had no patience to copy about 900 Mb with this rate.

As it's a git tree, I suppose it's heavily fragmented, but this is still rather
pathetic. Should I blame cp, or is something else wrong? Any ideas how
to figure this one out would be appreciated. Sorry for the off-topicness.

Greetings,

Indan


