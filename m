Return-Path: <linux-kernel-owner+w=401wt.eu-S1753516AbYCQGMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516AbYCQGMx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 02:12:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbYCQGMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 02:12:44 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:38259 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbYCQGMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 02:12:43 -0400
Message-ID: <47DE0BD7.7020500@skyrush.com>
Date: Mon, 17 Mar 2008 00:12:39 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080228)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>, vatsa@linux.vnet.ibm.com
Subject: Interactivity degrades with CONFIG_[FAIR]_GROUP_SCHED set in 2.6.24
 and later
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First of all, I am very excited to see the CFS in the kernel.
Interactivity is really great; much better than before.

When going from kernel 2.6.23 to 2.6.24, however, I noticed that
interactivity (namely the smoothness of mouse motion) was noticeably
less smooth under load.  The most obvious case was while pulling down a
Subversion repository; the mouse would freeze for quite long periods
while being moved (i.e. a large fraction of a second), which never
happens under 2.6.23.  I was using ZFS-FUSE on the partition I was
writing to, and it uses a lot of CPU at times, but 2.6.23 seems to
handle it better.

After reading many posts on similar sounding issues, I decided to try
getting later versions of the kernel: 2.6.25-rc5 and the latest 2.6.25
from the git archive (as of yesterday, 3/16) in case recent patches
addressed this.  They both still exibit the issue, however.

I then tried compiling without CONFIG_GROUP_SCHED (which also turned off
CONFIG_FAIR_GROUP_SCHED and a number of other options), and the behavior
seems to be back to the (better) 2.6.23 performance, at least has far as
what I can tell from my tests.

After playing around with the later kernels with CONFIG_GROUP_SCHED
enabled, I noticed a number of random times the mouse was not smooth and
seemed to not be getting an "interactive" amount of CPU time, but I have
a couple of tasks that repeat the problem reliably, so if there is any
debug information I can provide, please let me know, and I'll be glad to
help out in any way I can.

					Thanks, Joe
