Return-Path: <linux-kernel-owner+w=401wt.eu-S1757284AbZAVDaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284AbZAVDaA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 22:30:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756207AbZAVD3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 22:29:51 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:32905 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756203AbZAVD3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 22:29:51 -0500
Date: Thu, 22 Jan 2009 12:28:43 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Evgeniy Polyakov <zbr@ioremap.net>, Chris Snook <csnook@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
       Paul Menage <menage@google.com>, containers@lists.linux-foundation.org
Subject: Re: [RFC] [PATCH] Cgroup based OOM killer controller
Message-Id: <20090122122843.7e94878e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <200901211638.23101.knikanth@suse.de>
References: <200901211638.23101.knikanth@suse.de>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jan 2009 16:38:21 +0530
Nikanth Karthikesan <knikanth@suse.de> wrote:

> As Alan Cox suggested/wondered in this thread, 
> http://lkml.org/lkml/2009/1/12/235 , this is a container group based approach 
> to override the oom killer selection without losing all the benefits of the 
> current oom killer heuristics and oom_adj interface.
> 
> It adds a tunable oom.victim to the oom cgroup. The oom killer will kill the 
> process using the usual badness value but only within the cgroup with the 
> maximum value for oom.victim before killing any process from a cgroup with a 
> lesser oom.victim number. Oom killing could be disabled by setting 
> oom.victim=0.
> 
> Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
> 

Assume following
  - the usar can tell "which process should be killed at first"

What is the difference between oom_adj and this cgroup to users ?
If oom_adj is hard to use, making it simpler is a good way, I think.
rather than adding new complication.

It seems both of oom_adj and this cgroup will be hard-to-use functions
for usual system administrators. But no better idea than using memcg
and committing memory usage.

Thanks,
-Kame

