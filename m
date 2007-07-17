Return-Path: <linux-kernel-owner+w=401wt.eu-S935967AbXGQTzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935967AbXGQTzV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 15:55:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760456AbXGQTzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 15:55:07 -0400
Received: from orion2.pixelized.ch ([195.190.190.13]:53999 "EHLO
	mail.pixelized.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756409AbXGQTzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 15:55:06 -0400
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Jul 2007 15:55:06 EDT
Message-ID: <469D1D5E.8050609@cateee.net>
Date: Tue, 17 Jul 2007 21:49:50 +0200
From: Giacomo Catenazzi <cate@cateee.net>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070622)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: regression: disk error loop (panic?) ide_do_rw_disk-bad:
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

last git changes to git give me the following error (repead very quickly):

sector 14657019, nr/cmr 0/0
bio f7b59280, biotail f7b59280, buffer 0000000, date 0000000, len 36
ide_do_rw_disk-bad command: dev hda: type 2, flags 104c8

[note: manually copied]


I tried bisect:


cate@catee:~/kernel/6,v2.6/linux-2.6$ git bisect log
# bad: [a5fcaa210626a79465321e344c91a6a7dc3881fa] Merge branch
'drm-patches' of
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6
# good: [8f41958bdd577731f7411c9605cfaa9db6766809] Merge
git://git.infradead.org/battery-2.6
git-bisect start 'a5fcaa21' '8f41958b'
# good: [02b2318e07f98a7cdf7089a4457a8d62424aa824] Merge branch 'master'
of master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6
git-bisect good 02b2318e07f98a7cdf7089a4457a8d62424aa824
# good: [f716a425c15ebadf60286cd4fb60d1d6f46e3cf9] [POWERPC] VIOTAPE:
Use designated initializers for fops member structures.
git-bisect good f716a425c15ebadf60286cd4fb60d1d6f46e3cf9
# good: [14dc5249728ff699b1ca4dac01ad416a350a147a] Merge branch
'for-linus' of git://git.kernel.dk/data/git/linux-2.6-block
git-bisect good 14dc5249728ff699b1ca4dac01ad416a350a147a
# good: [c2dc1ad582196208a2f990eb0230eb922046c684] Merge branch
'drm-patches' of
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6
git-bisect good c2dc1ad582196208a2f990eb0230eb922046c684
# good: [c5e3ae8823693b260ce1f217adca8add1bc0b3de] forcedeth bug fix:
realtek phy
git-bisect good c5e3ae8823693b260ce1f217adca8add1bc0b3de
# good: [70584578ab3e940ac9d7820f268f9adc9884e407] [POWERPC] Check for
NULL ppc_md.init_IRQ() before calling
git-bisect good 70584578ab3e940ac9d7820f268f9adc9884e407
# good: [bf22f6fe2d72b4d7e9035be8ceb340414cf490e3] Merge branch
'for-2.6.23' into merge
git-bisect good bf22f6fe2d72b4d7e9035be8ceb340414cf490e3
# bad: [f798634d806615bee27d1b83479034087a02aa0f] [SERIAL] SUNHV: Fix
jerky console on LDOM guests.
git-bisect bad f798634d806615bee27d1b83479034087a02aa0f
# bad: [29417b899a77aaba1c060f5e123db4f50006f58a] Make BLK_DEV_BSG
depend strictly on SCSI=y
git-bisect bad 29417b899a77aaba1c060f5e123db4f50006f58a

but last changeset don't compile (and it doesn't seem relevant).

ciao
	cate
