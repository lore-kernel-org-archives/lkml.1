Return-Path: <linux-kernel-owner+w=401wt.eu-S1757363AbXI2TqB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363AbXI2TqB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 15:46:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751903AbXI2Tpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 15:45:54 -0400
Received: from mail-in-09.arcor-online.net ([151.189.21.49]:37773 "EHLO
	mail-in-09.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750985AbXI2Tpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 15:45:53 -0400
Date: Sat, 29 Sep 2007 21:45:49 +0200
From: Wolfgang Erig <Wolfgang.Erig@gmx.de>
To: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: Re: regression in 2.6.23-rc8 - power off failed
Message-ID: <20070929194549.GA19879@erig.dyndns.org>
Mail-Followup-To: "H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org,
	Alexey Starikovskiy <astarikovskiy@suse.de>
References: <20070929005453.GA4475@erig.dyndns.org> <46FDC0EB.3070003@zytor.com> <20070929082233.GA3447@erig.dyndns.org> <46FE0D29.4090706@zytor.com> <20070929093553.GA4451@erig.dyndns.org> <20070929180721.GA8371@erig.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070929180721.GA8371@erig.dyndns.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Sat, Sep 29, 2007 at 08:07:21PM +0200, Wolfgang Erig wrote:
> 
> Now I try the things written in
> http://marc.info/?i=46FD802D.2030804@zytor.com

I have dumped a memory region which is my understanding what you want
to see. The difference between the good and the bad case is only
the patch
"4fd06960f120e02e9abc802a09f9511c400042a5 Use the new x86 setup code for i386"

I modified arch/i386/kernel/setup.c and dumped 4K of /dev/kmem at the
address of boot_params.

Good case:
c0457340 > 00 08 fc ff 00 00 03 50  8c c8 03 00 8e c0 19 01 < .......P........
c0457350 > 10 00 7c fb fc be 31 00  ac 20 c0 74 09 b4 0e bb < ..|...1.. .t....
c0457360 > 07 00 cd 10 eb f2 31 c0  cd 16 cd 19 ea f0 ff 00 < ......1.........
c0457370 > f0                                               < .
c0457371  "Direct booting "
c0457380 > 02 01 00 f0 ff 96 00 00  00 f0 40 00 03 00 ff ff < ..........@.....
c0457390 > ff ff ff ff                                      < ....
c0457394  "nger supported."
c04573a3 > 0d 0a                                            < ..
c04573a5  "Please use a boot loader prp4"
c04573c2 > 0f 00 00 00 00 00 08 00  00 00 70 34 3f          < ..........p4?
c04573cf    11 * 00
c04573e0 > 08 00 fc 01 00 74 00 00  00 00                   < .....t....
c04573ea  " key to reboot . . ."
c04573fe > 0d 0a                                            < ..
c0457400   121 * 00
c0457521 > fc 01 00 00 00 09 00 05  00 00 00 00 00 00 00 00 < ................
c0457531 > 0e 01 00 f4 a4 01 00 00  00 00 0f 02 08 55 aa eb < .............U..
c0457541  ":HdrS"
c0457546 > 06 02 00 00 00 00 00 10  7f 11 71 81 00 80 00 00 < ..........q.....
c0457556 > 10 00 00 00 00 00 00 00  00 00 00 00 00 00 00 8e < ................
c0457566 > 00 00 00 90 09 00 ff ff  ff 1f 00 00 10 00 00 00 < ................
c0457576 > 00 00 ff 07 00 00 e8 c1  0c 90                   < ..........
c0457580    99 * 00
c0457619 > fc 09 00 00 00 00 00 01  00 00 00 00 fc 09 00 00 < ................
c0457629 > 00 00 00 00 04 00 00 00  00 00 00 02 00 00 00 3a < ...............:
c0457639 > 12 0f 00 00 00 00 00 c6  ed 00 00 00 00 00 00 02 < ................
c0457649 > 00 00 00 00 00 10 00 00  00 00 00 00 00 f0 07 00 < ................
c0457659 > 00 00 00 01 00 00 00 3a  12 ff ff 00 00 00 00 c6 < .......:........
c0457669 > ed 00 00 00 00 00 00 02                          < ........
c0457671   bcf * 00
c0458240 > b8 00 15 b2 81 cd 13 8c  c8 8e d8 81 3e a5 1b 55 < ............>..U
c0458250 > aa 75 4c 81 3e a7 1b                             < .uL.>..
c0458257  "ZZuD"
c045825b > eb 40 ac 20 c0 74 05 e8  08 00 eb f6 c3 e8 00 00 < .@. .t..........
c045826b > b0 20 50 51 bb 07 00 b9  01 00 b4 0e cd 10 59 58 < . PQ..........YX
c045827b > c3 b0 07 eb ed                                   < .....
c0458280  "No setup signature found ..."
c045829c > 00 eb 4f 8c c8 83 e8 20  8e d8 30 ff 8a 1e f1 01 < ..O.... ..0.....
c04582ac > 83 eb 04 c1 e3 08 89 d9  c1 eb 03 81 c3 00 10 2e < ................
c04582bc > 89 1e 0c 00 bf 00 08 29  f6 0e 07 b8 00 10 8e d8 < .......)........
c04582cc > f3 a5 8c c8 8e d8 81 3e  a5 1b 55 aa 75 0a 81 3e < .......>..U.u..>
c04582dc > a7 1b 5a 5a 75 02 eb 0a  8d 36 40 0d e8 72 ff f4 < ..ZZu....6@..r..
c04582ec > eb fd 8c c8 83 e8 20 8e  d8 2e f6 06 11 00 01 74 < ...... ........t
c04582fc > 2e 2e 80 3e 10 00 00 75  26 0e 1f 8d 36 d0 0d e8 < ...>...u&...6...
c045830c > 4f ff eb db                                      < O...
c0458310  "Wrong loader, giving up..."
c045832a > 00 e8 36 00 66 85 c0 74  61 8c c8 8e d8 8d 36 00 < ..6.f..ta.....6.
c045833a > 0e e8 1f ff eb fe                                < ......

Bad case:
c0457340 > 00 08 00 00 00 00 03 50  00 00 03 00 00 00 19 01 < .......P........
c0457350 > 10                                               < .
c0457351    4f * 00
c04573a0 > 80 86 00 00 00 00 00 00  00 00 00 00             < ............
c04573ac  "CISG"
c04573b0    30 * 00
c04573e0 > 08 00 fc 01 00 74                                < .....t
c04573e6   13e * 00
c0457524 > e0 29 09 00 05 00 00 00  00 00 00 00 00 13 01 00 < .)..............
c0457534 > fa a4 01 00 00 00 ff ff  02 08 55 aa eb          < ..........U..
c0457541  ":HdrS"
c0457546 > 06 02 00 00 00 00 00 10  3c 23 71 81 00 80 00 00 < ........<#q.....
c0457556 > 10 00 00 00 00 00 00 00  00 00 00 00 00 00 00 8e < ................
c0457566 > 00 00 00 90 09 00 ff ff  ff 1f 00 00 10          < .............
c0457573    a6 * 00
c0457619 > fc 09 00 00 00 00 00 01  00 00 00 00 fc 09 00 00 < ................
c0457629 > 00 00 00 00 04 00 00 00  00 00 00 02 00 00 00 3a < ...............:
c0457639 > 12 0f 00 00 00 00 00 c6  ed 00 00 00 00 00 00 02 < ................
c0457649 > 00 00 00 00 00 10 00 00  00 00 00 00 00 f0 07 00 < ................
c0457659 > 00 00 00 01 00 00 00 3a  12 ff ff 00 00 00 00 c6 < .......:........
c0457669 > ed 00 00 00 00 00 00 02                          < ........
c0457671   ccf * 00

$ cat /proc/cmdline
root=/dev/hda1

Wolfgang
