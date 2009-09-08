Return-Path: <linux-kernel-owner+w=401wt.eu-S1754373AbZIHNSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373AbZIHNSq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 09:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754073AbZIHNSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 09:18:44 -0400
Received: from depni.sinp.msu.ru ([213.131.7.21]:52031 "EHLO depni.sinp.msu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754082AbZIHNSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 09:18:43 -0400
X-Greylist: delayed 1291 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Sep 2009 09:18:43 EDT
From: Serge Belyshev <belyshev@depni.sinp.msu.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: Epic regression in throughput since v2.6.23
References: <20090906205952.GA6516@elte.hu>
Date: Tue, 08 Sep 2009 12:57:09 +0000
In-Reply-To: <20090906205952.GA6516@elte.hu> (Ingo Molnar's message of "Sun, 6
	Sep 2009 22:59:52 +0200")
Message-ID: <87hbvdiogq.fsf@depni.sinp.msu.ru>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi. I've done measurments of time taken by make -j4 kernel build
on a quadcore box.  Results are interesting: mainline kernel
has regressed since v2.6.23 release by more than 10%.

The following graph is time taken by "make -j4" (median over 9 runs)
versus kernel version.  The huge (10%) regressions since v2.6.23 is
apparent.  Note that tip/master c26f010 is better than current mainline.
Also note that BFS is significantly better than both and shows the same
throughput as vanilla v2.6.23:

http://img403.imageshack.us/img403/7029/epicmakej4.png


The following plot is a detailed comparison of time taken versus number
of parallel jobs. Note that at "make -j4" (which equals number of hardware
threads), BFS has the minimum (best performance), 
and tip/master -- maximum (worst).  I've also tested mainline v2.6.31
(not shown on the graph) which produces similar, albeit a bit slower,
results as the tip/master.

http://img179.imageshack.us/img179/5335/epicbfstip.png


Conclusion are
1) mainline has severely regressed since v2.6.23
2) BFS shows optimal performance at make -jN where N equals number of
   h/w threads, while current mainline scheduler performance is far from
   optimal in this case.
