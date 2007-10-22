Return-Path: <linux-kernel-owner+w=401wt.eu-S1755018AbXJVNmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018AbXJVNmh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 09:42:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580AbXJVNmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 09:42:18 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:52387 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752394AbXJVNmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 09:42:17 -0400
Message-ID: <393060478.03650@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Mon, 22 Oct 2007 21:41:13 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 100% iowait on one of cpus in current -git
Message-ID: <20071022134113.GA5644@mail.ustc.edu.cn>
References: <200710220822.52370.maximlevitsky@gmail.com> <200710221421.21439.maximlevitsky@gmail.com> <393056632.00561@ustc.edu.cn> <200710221505.35397.maximlevitsky@gmail.com> <20071022131045.GA5357@mail.ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071022131045.GA5357@mail.ustc.edu.cn>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2007 at 09:10:45PM +0800, Fengguang Wu wrote:
> Hmm, Maybe it's an reiserfs related issue.  Do you have the full log file?

Bingo! It can be reproduced in -mm on reiserfs:

# mkfs.reiserfs /dev/sdb1
# mount /dev/sdb1 /test
# cp bin /test
<wait for a while>
# dmesg
[...]
[  418.346113] requeue_io 308: inode 6 size 302 at 08:11(sdb1)
[  418.346119] requeue_io 308: inode 7 size 196 at 08:11(sdb1)
[  418.346125] requeue_io 308: inode 8 size 85 at 08:11(sdb1)
[  418.346131] requeue_io 308: inode 9 size 180 at 08:11(sdb1)
[  418.346136] requeue_io 308: inode 10 size 1488 at 08:11(sdb1)
[  418.346142] requeue_io 308: inode 12 size 1358 at 08:11(sdb1)
[  418.346148] requeue_io 308: inode 13 size 482 at 08:11(sdb1)
[  418.346153] requeue_io 308: inode 14 size 171 at 08:11(sdb1)
[  418.346159] requeue_io 308: inode 15 size 93 at 08:11(sdb1)
[  418.346164] requeue_io 308: inode 16 size 81 at 08:11(sdb1)
[  418.346170] requeue_io 308: inode 17 size 212 at 08:11(sdb1)
[  418.346176] requeue_io 308: inode 18 size 431 at 08:11(sdb1)
[  418.346181] requeue_io 308: inode 19 size 231 at 08:11(sdb1)
[  418.346187] requeue_io 308: inode 20 size 1756 at 08:11(sdb1)
[  418.346193] requeue_io 308: inode 21 size 1229 at 08:11(sdb1)
[  418.346198] requeue_io 308: inode 22 size 157 at 08:11(sdb1)
[  418.346204] requeue_io 308: inode 23 size 3430 at 08:11(sdb1)
[  418.346210] requeue_io 308: inode 24 size 200 at 08:11(sdb1)
[  418.346215] requeue_io 308: inode 25 size 202 at 08:11(sdb1)
[  418.346221] requeue_io 308: inode 26 size 386 at 08:11(sdb1)
[  418.346226] requeue_io 308: inode 27 size 264 at 08:11(sdb1)
[  418.346232] requeue_io 308: inode 28 size 268 at 08:11(sdb1)
[  418.346238] requeue_io 308: inode 29 size 1228 at 08:11(sdb1)
[  418.346243] requeue_io 308: inode 30 size 404 at 08:11(sdb1)
[  418.346249] requeue_io 308: inode 31 size 2452 at 08:11(sdb1)
[  418.346255] requeue_io 308: inode 32 size 1236 at 08:11(sdb1)
[  418.346260] requeue_io 308: inode 33 size 655 at 08:11(sdb1)
[  418.346266] requeue_io 308: inode 35 size 330 at 08:11(sdb1)
[  418.346272] requeue_io 308: inode 36 size 248 at 08:11(sdb1)
[  418.346277] requeue_io 308: inode 37 size 683 at 08:11(sdb1)
[  418.346283] requeue_io 308: inode 38 size 1451 at 08:11(sdb1)
[  418.346288] requeue_io 308: inode 39 size 894 at 08:11(sdb1)
[  418.346294] requeue_io 308: inode 40 size 879 at 08:11(sdb1)
[  418.346300] requeue_io 308: inode 42 size 797 at 08:11(sdb1)
[  418.346305] requeue_io 308: inode 43 size 1314 at 08:11(sdb1)
[  418.346311] requeue_io 308: inode 44 size 1463 at 08:11(sdb1)
[  418.346317] requeue_io 308: inode 45 size 3032 at 08:11(sdb1)
[  418.346322] requeue_io 308: inode 46 size 325 at 08:11(sdb1)
[  418.346328] requeue_io 308: inode 47 size 583 at 08:11(sdb1)
[  418.346334] requeue_io 308: inode 48 size 1660 at 08:11(sdb1)
[  418.346339] requeue_io 308: inode 49 size 3159 at 08:11(sdb1)
[  418.346345] requeue_io 308: inode 50 size 510 at 08:11(sdb1)
[  418.346350] requeue_io 308: inode 51 size 100 at 08:11(sdb1)
[  418.346356] requeue_io 308: inode 52 size 143 at 08:11(sdb1)
[  418.346370] requeue_io 308: inode 53 size 954 at 08:11(sdb1)
[  418.346373] requeue_io 308: inode 54 size 322 at 08:11(sdb1)
[  418.346376] requeue_io 308: inode 55 size 970 at 08:11(sdb1)
[  418.346379] requeue_io 308: inode 57 size 483 at 08:11(sdb1)
[  418.346382] requeue_io 308: inode 58 size 1125 at 08:11(sdb1)
[  418.346385] requeue_io 308: inode 59 size 2196 at 08:11(sdb1)
[  418.346388] requeue_io 308: inode 60 size 104 at 08:11(sdb1)
[  418.346391] requeue_io 308: inode 61 size 488 at 08:11(sdb1)
[  418.346394] requeue_io 308: inode 62 size 116 at 08:11(sdb1)
[  418.346397] requeue_io 308: inode 63 size 907 at 08:11(sdb1)
[  418.346400] requeue_io 308: inode 64 size 1076 at 08:11(sdb1)
[  418.346403] requeue_io 308: inode 65 size 460 at 08:11(sdb1)
[  418.346406] requeue_io 308: inode 66 size 1092 at 08:11(sdb1)
[  418.346409] requeue_io 308: inode 67 size 424 at 08:11(sdb1)
[  418.346412] requeue_io 308: inode 68 size 696 at 08:11(sdb1)
[  418.346415] requeue_io 308: inode 70 size 137 at 08:11(sdb1)
[  418.346418] requeue_io 308: inode 71 size 201 at 08:11(sdb1)
[  418.346421] requeue_io 308: inode 72 size 150 at 08:11(sdb1)
[  418.346424] requeue_io 308: inode 73 size 188 at 08:11(sdb1)
[  418.346427] requeue_io 308: inode 75 size 1208 at 08:11(sdb1)
[  418.346431] requeue_io 308: inode 76 size 493 at 08:11(sdb1)
[  418.346434] requeue_io 308: inode 77 size 484 at 08:11(sdb1)
[  418.346437] requeue_io 308: inode 78 size 356 at 08:11(sdb1)
[  418.346440] requeue_io 308: inode 79 size 895 at 08:11(sdb1)
[  418.346443] requeue_io 308: inode 80 size 847 at 08:11(sdb1)
[  418.346446] requeue_io 308: inode 81 size 3281 at 08:11(sdb1)
[  418.346449] requeue_io 308: inode 82 size 3329 at 08:11(sdb1)
[  418.346452] requeue_io 308: inode 83 size 115 at 08:11(sdb1)
[  418.346455] requeue_io 308: inode 84 size 644 at 08:11(sdb1)
[  418.346458] requeue_io 308: inode 85 size 125 at 08:11(sdb1)
[  418.346461] requeue_io 308: inode 86 size 199 at 08:11(sdb1)
[  418.346464] requeue_io 308: inode 87 size 204 at 08:11(sdb1)
[  418.346467] requeue_io 308: inode 88 size 72 at 08:11(sdb1)
[  418.346476] mm/page-writeback.c 658 wb_kupdate: pdflush(209) 17174 global 2012 0 0 wc _M tw 1024 sk 0
[  418.366318] requeue_io 308: inode 6 size 302 at 08:11(sdb1)
[  418.366325] requeue_io 308: inode 7 size 196 at 08:11(sdb1)
[  418.366330] requeue_io 308: inode 8 size 85 at 08:11(sdb1)
[  418.366334] requeue_io 308: inode 9 size 180 at 08:11(sdb1)
[  418.366338] requeue_io 308: inode 10 size 1488 at 08:11(sdb1)
[  418.366342] requeue_io 308: inode 12 size 1358 at 08:11(sdb1)
[  418.366346] requeue_io 308: inode 13 size 482 at 08:11(sdb1)
[  418.366350] requeue_io 308: inode 14 size 171 at 08:11(sdb1)
[  418.366354] requeue_io 308: inode 15 size 93 at 08:11(sdb1)
[  418.366358] requeue_io 308: inode 16 size 81 at 08:11(sdb1)
[  418.366361] requeue_io 308: inode 17 size 212 at 08:11(sdb1)
[  418.366365] requeue_io 308: inode 18 size 431 at 08:11(sdb1)
[  418.366369] requeue_io 308: inode 19 size 231 at 08:11(sdb1)
[  418.366373] requeue_io 308: inode 20 size 1756 at 08:11(sdb1)
[  418.366378] requeue_io 308: inode 21 size 1229 at 08:11(sdb1)
[  418.366382] requeue_io 308: inode 22 size 157 at 08:11(sdb1)
[  418.366386] requeue_io 308: inode 23 size 3430 at 08:11(sdb1)
[  418.366390] requeue_io 308: inode 24 size 200 at 08:11(sdb1)
[  418.366394] requeue_io 308: inode 25 size 202 at 08:11(sdb1)
[  418.366398] requeue_io 308: inode 26 size 386 at 08:11(sdb1)
[  418.366402] requeue_io 308: inode 27 size 264 at 08:11(sdb1)
[  418.366407] requeue_io 308: inode 28 size 268 at 08:11(sdb1)
[  418.366411] requeue_io 308: inode 29 size 1228 at 08:11(sdb1)
[  418.366415] requeue_io 308: inode 30 size 404 at 08:11(sdb1)
[  418.366419] requeue_io 308: inode 31 size 2452 at 08:11(sdb1)
[  418.366423] requeue_io 308: inode 32 size 1236 at 08:11(sdb1)
[  418.366427] requeue_io 308: inode 33 size 655 at 08:11(sdb1)
[  418.366431] requeue_io 308: inode 35 size 330 at 08:11(sdb1)
[  418.366435] requeue_io 308: inode 36 size 248 at 08:11(sdb1)
[  418.366439] requeue_io 308: inode 37 size 683 at 08:11(sdb1)
[  418.366443] requeue_io 308: inode 38 size 1451 at 08:11(sdb1)
[  418.366446] requeue_io 308: inode 39 size 894 at 08:11(sdb1)
[  418.366450] requeue_io 308: inode 40 size 879 at 08:11(sdb1)
[  418.366453] requeue_io 308: inode 42 size 797 at 08:11(sdb1)
[  418.366457] requeue_io 308: inode 43 size 1314 at 08:11(sdb1)
[  418.366460] requeue_io 308: inode 44 size 1463 at 08:11(sdb1)
[  418.366464] requeue_io 308: inode 45 size 3032 at 08:11(sdb1)
[  418.366468] requeue_io 308: inode 46 size 325 at 08:11(sdb1)
[  418.366471] requeue_io 308: inode 47 size 583 at 08:11(sdb1)
[  418.366475] requeue_io 308: inode 48 size 1660 at 08:11(sdb1)
[  418.366478] requeue_io 308: inode 49 size 3159 at 08:11(sdb1)
[  418.366482] requeue_io 308: inode 50 size 510 at 08:11(sdb1)
[  418.366485] requeue_io 308: inode 51 size 100 at 08:11(sdb1)
[  418.366489] requeue_io 308: inode 52 size 143 at 08:11(sdb1)
[  418.366492] requeue_io 308: inode 53 size 954 at 08:11(sdb1)
[  418.366496] requeue_io 308: inode 54 size 322 at 08:11(sdb1)
[  418.366500] requeue_io 308: inode 55 size 970 at 08:11(sdb1)
[  418.366503] requeue_io 308: inode 57 size 483 at 08:11(sdb1)
[  418.366507] requeue_io 308: inode 58 size 1125 at 08:11(sdb1)
[  418.366511] requeue_io 308: inode 59 size 2196 at 08:11(sdb1)
[  418.366514] requeue_io 308: inode 60 size 104 at 08:11(sdb1)
[  418.366518] requeue_io 308: inode 61 size 488 at 08:11(sdb1)
[  418.366522] requeue_io 308: inode 62 size 116 at 08:11(sdb1)
[  418.366525] requeue_io 308: inode 63 size 907 at 08:11(sdb1)
[  418.366529] requeue_io 308: inode 64 size 1076 at 08:11(sdb1)
[  418.366532] requeue_io 308: inode 65 size 460 at 08:11(sdb1)
[  418.366536] requeue_io 308: inode 66 size 1092 at 08:11(sdb1)
[  418.366539] requeue_io 308: inode 67 size 424 at 08:11(sdb1)
[  418.366543] requeue_io 308: inode 68 size 696 at 08:11(sdb1)
[  418.366546] requeue_io 308: inode 70 size 137 at 08:11(sdb1)
[  418.366550] requeue_io 308: inode 71 size 201 at 08:11(sdb1)
[  418.366553] requeue_io 308: inode 72 size 150 at 08:11(sdb1)
[  418.366557] requeue_io 308: inode 73 size 188 at 08:11(sdb1)
[  418.366561] requeue_io 308: inode 75 size 1208 at 08:11(sdb1)
[  418.366564] requeue_io 308: inode 76 size 493 at 08:11(sdb1)
[  418.366567] requeue_io 308: inode 77 size 484 at 08:11(sdb1)
[  418.366571] requeue_io 308: inode 78 size 356 at 08:11(sdb1)
[  418.366575] requeue_io 308: inode 79 size 895 at 08:11(sdb1)
[  418.366578] requeue_io 308: inode 80 size 847 at 08:11(sdb1)
[  418.366582] requeue_io 308: inode 81 size 3281 at 08:11(sdb1)
[  418.366586] requeue_io 308: inode 82 size 3329 at 08:11(sdb1)
[  418.366590] requeue_io 308: inode 83 size 115 at 08:11(sdb1)
[  418.366593] requeue_io 308: inode 84 size 644 at 08:11(sdb1)
[  418.366597] requeue_io 308: inode 85 size 125 at 08:11(sdb1)
[  418.366600] requeue_io 308: inode 86 size 199 at 08:11(sdb1)
[  418.366604] requeue_io 308: inode 87 size 204 at 08:11(sdb1)
[  418.366607] requeue_io 308: inode 88 size 72 at 08:11(sdb1)
[  418.366622] mm/page-writeback.c 658 wb_kupdate: pdflush(209) 17174 global 2012 0 0 wc _M tw 1024 sk 0

