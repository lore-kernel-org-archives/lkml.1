Return-Path: <linux-kernel-owner+w=401wt.eu-S1759845AbYLLStS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759845AbYLLStS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 13:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757861AbYLLStH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 13:49:07 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:35264 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757382AbYLLStF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 13:49:05 -0500
Date: Fri, 12 Dec 2008 19:49:04 +0100
From: Andreas Mohr <andi@lisas.de>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [REGRESSION] 2.6.28-rc8: oldish top core dumps (in its meminfo()
	function)
Message-ID: <20081212184904.GA6896@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081212094212.GA14641@rhlx01.hs-esslingen.de>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[f'up]

I just tried it on -rc8 and a (freshly rebooted) -rc7, both core
dumped, yet a 2.6.27.7 test does NOT do that.
Breakage may be older than -rc7, also might be caused by .config
changes (via make oldconfig), since a diff shows several changes.

This is a JFYI since I pretty much won't be able to debug this issue,
at least not now.

Oh, one important part, the crash in libproc.so happens at 0xb7f077b7:

0xb7f0770d <meminfo+413>:       je     0xb7f07a61 <meminfo+1265>
0xb7f07713 <meminfo+419>:       cld
0xb7f07714 <meminfo+420>:       mov    0xffffffbc(%ebp),%esi
0xb7f07717 <meminfo+423>:       mov    $0xe,%ecx
0xb7f0771c <meminfo+428>:       lea    0xfffff14e(%ebx),%edi
0xb7f07722 <meminfo+434>:       repz cmpsb %es:(%edi),%ds:(%esi)
0xb7f07724 <meminfo+436>:       je     0xb7f07a10 <meminfo+1184>
0xb7f0772a <meminfo+442>:       cld
0xb7f0772b <meminfo+443>:       mov    0xffffffbc(%ebp),%esi
0xb7f0772e <meminfo+446>:       mov    $0xa,%ecx
0xb7f07733 <meminfo+451>:       lea    0xfffff15c(%ebx),%edi
0xb7f07739 <meminfo+457>:       repz cmpsb %es:(%edi),%ds:(%esi)
0xb7f0773b <meminfo+459>:       je     0xb7f079c5 <meminfo+1109>
0xb7f07741 <meminfo+465>:       cld
0xb7f07742 <meminfo+466>:       mov    0xffffffbc(%ebp),%esi
0xb7f07745 <meminfo+469>:       mov    $0x9,%ecx
0xb7f0774a <meminfo+474>:       lea    0xfffff166(%ebx),%edi
0xb7f07750 <meminfo+480>:       repz cmpsb %es:(%edi),%ds:(%esi)
0xb7f07752 <meminfo+482>:       je     0xb7f0797a <meminfo+1034>
0xb7f07758 <meminfo+488>:       cld
0xb7f07759 <meminfo+489>:       mov    0xffffffbc(%ebp),%esi
0xb7f0775c <meminfo+492>:       mov    $0xb,%ecx
0xb7f07761 <meminfo+497>:       lea    0xfffff16f(%ebx),%edi
0xb7f07767 <meminfo+503>:       repz cmpsb %es:(%edi),%ds:(%esi)
0xb7f07769 <meminfo+505>:       je     0xb7f0792f <meminfo+959>
0xb7f0776f <meminfo+511>:       cld
0xb7f07770 <meminfo+512>:       mov    0xffffffbc(%ebp),%esi
0xb7f07773 <meminfo+515>:       mov    $0xa,%ecx
0xb7f07778 <meminfo+520>:       lea    0xfffff17a(%ebx),%edi
0xb7f0777e <meminfo+526>:       repz cmpsb %es:(%edi),%ds:(%esi)
0xb7f07780 <meminfo+528>:       je     0xb7f078e4 <meminfo+884>
0xb7f07786 <meminfo+534>:       cld
0xb7f07787 <meminfo+535>:       mov    0xffffffbc(%ebp),%esi
0xb7f0778a <meminfo+538>:       mov    $0xb,%ecx
0xb7f0778f <meminfo+543>:       lea    0xfffff184(%ebx),%edi
0xb7f07795 <meminfo+549>:       repz cmpsb %es:(%edi),%ds:(%esi)
0xb7f07797 <meminfo+551>:       je     0xb7f07893 <meminfo+803>
0xb7f0779d <meminfo+557>:       cld
0xb7f0779e <meminfo+558>:       mov    0xffffffbc(%ebp),%esi
0xb7f077a1 <meminfo+561>:       mov    $0xa,%ecx
0xb7f077a6 <meminfo+566>:       lea    0xfffff18f(%ebx),%edi
0xb7f077ac <meminfo+572>:       repz cmpsb %es:(%edi),%ds:(%esi)
0xb7f077ae <meminfo+574>:       je     0xb7f07842 <meminfo+722>
0xb7f077b4 <meminfo+580>:       mov    0xffffffc4(%ebp),%ecx
0xb7f077b7 <meminfo+583>:       movzbl (%ecx),%eax
0xb7f077ba <meminfo+586>:       inc    %ecx
0xb7f077bb <meminfo+587>:       mov    %ecx,0xffffffc4(%ebp)
0xb7f077be <meminfo+590>:       cmp    $0xa,%al
0xb7f077c0 <meminfo+592>:       jne    0xb7f077b4 <meminfo+580>
0xb7f077c2 <meminfo+594>:       lea    0x0(%esi),%esi
0xb7f077c9 <meminfo+601>:       lea    0x0(%edi),%edi
0xb7f077d0 <meminfo+608>:       mov    0xffffffc4(%ebp),%eax
0xb7f077d3 <meminfo+611>:       cmpb   $0x0,(%eax)
0xb7f077d6 <meminfo+614>:       jne    0xb7f07610 <meminfo+160>
0xb7f077dc <meminfo+620>:       mov    0x8(%ebp),%ecx
0xb7f077df <meminfo+623>:       mov    0x88(%ecx),%eax
0xb7f077e5 <meminfo+629>:       mov    0x8c(%ecx),%edx
0xb7f077eb <meminfo+635>:       sub    0x98(%ecx),%eax
0xb7f077f1 <meminfo+641>:       sbb    0x9c(%ecx),%edx
0xb7f077f7 <meminfo+647>:       mov    %eax,0x90(%ecx)
0xb7f077fd <meminfo+653>:       mov    (%ecx),%eax
0xb7f077ff <meminfo+655>:       sub    0x30(%ecx),%eax
0xb7f07802 <meminfo+658>:       mov    %edx,0x94(%ecx)
0xb7f07808 <meminfo+664>:       mov    0x4(%ecx),%edx
0xb7f0780b <meminfo+667>:       sbb    0x34(%ecx),%edx
0xb7f0780e <meminfo+670>:       mov    %eax,0x18(%ecx)
0xb7f07811 <meminfo+673>:       mov    0x8(%ecx),%eax
0xb7f07814 <meminfo+676>:       sub    0x38(%ecx),%eax
0xb7f07817 <meminfo+679>:       mov    %edx,0x1c(%ecx)
0xb7f0781a <meminfo+682>:       mov    0xc(%ecx),%edx
0xb7f0781d <meminfo+685>:       sbb    0x3c(%ecx),%edx
0xb7f07820 <meminfo+688>:       mov    %eax,0x20(%ecx)
0xb7f07823 <meminfo+691>:       mov    0x10(%ecx),%eax
0xb7f07826 <meminfo+694>:       sub    0x40(%ecx),%eax
0xb7f07829 <meminfo+697>:       mov    %edx,0x24(%ecx)
0xb7f0782c <meminfo+700>:       mov    0x14(%ecx),%edx
0xb7f0782f <meminfo+703>:       sbb    0x44(%ecx),%edx
0xb7f07832 <meminfo+706>:       mov    %eax,0x28(%ecx)
0xb7f07835 <meminfo+709>:       mov    %edx,0x2c(%ecx)
0xb7f07838 <meminfo+712>:       add    $0x5c,%esp
0xb7f0783b <meminfo+715>:       xor    %eax,%eax
0xb7f0783d <meminfo+717>:       pop    %ebx
0xb7f0783e <meminfo+718>:       pop    %esi
0xb7f0783f <meminfo+719>:       pop    %edi
0xb7f07840 <meminfo+720>:       pop    %ebp
0xb7f07841 <meminfo+721>:       ret

(gdb) inf reg
eax            0x0      0
ecx            0xb7f0e000       -1208950784
edx            0x1      1
ebx            0xb7f0a264       -1208966556
esp            0xbfc40220       0xbfc40220
ebp            0xbfc40288       0xbfc40288
esi            0xbfc40261       -1077673375
edi            0xb7f093f4       -1208970252
eip            0xb7f077b7       0xb7f077b7
eflags         0x210297 2163351
cs             0x73     115
ss             0x7b     123
ds             0x7b     123
es             0x7b     123
fs             0x0      0
gs             0x33     51


(gdb) x 0xb7f0e000
0xb7f0e000:     Cannot access memory at address 0xb7f0e000


Thanks,

Andreas Mohr
