Return-Path: <linux-kernel-owner+w=401wt.eu-S1752756AbZIVCn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756AbZIVCn7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 22:43:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752719AbZIVCn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 22:43:57 -0400
Received: from ozlabs.org ([203.10.76.45]:59269 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982AbZIVCnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 22:43:46 -0400
Date: Tue, 22 Sep 2009 12:39:20 +1000
From: Anton Blanchard <anton@samba.org>
To: Frederic Weisbecker <fweisbec@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] tracing/workqueue fixes
Message-ID: <20090922023920.GA31801@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

The workqueue tracepoint patchset looks to have stalled for a bit. While
we discuss how much functionality we want in kernel, I think we have a
solid case for tracing the latency caused by workqueue events.

For an example we can look at the rt_worker_func work. As memory grew its
duration would also grow, and I measured 14ms spikes on one box. Once found
we placed a cap on it:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=c9503e0fe052020e0294cd07d0ecd982eb7c9177

The following patches add entry and exit tracepoints so we can find these
things easily.

Anton
