Return-Path: <linux-kernel-owner+w=401wt.eu-S1751939AbZKCXJL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939AbZKCXJL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 18:09:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751764AbZKCXJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 18:09:09 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58003 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbZKCXJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 18:09:07 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: vedran.furac@gmail.com
Subject: Re: [PATCH] oom_kill: use rss value instead of vm size for badness
Cc: kosaki.motohiro@jp.fujitsu.com, David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrea Arcangeli <aarcange@redhat.com>
In-Reply-To: <4AEF394A.4050102@gmail.com>
References: <2f11576a0911020435n103538d0p9d2afed4d39b4726@mail.gmail.com> <4AEF394A.4050102@gmail.com>
Message-Id: <20091104002903.0B4D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  4 Nov 2009 08:09:08 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> KOSAKI Motohiro wrote:
> 
> > Oh, I'm sorry. I mesured with rss patch.
> > Then, I haven't understand what makes Xorg bad score.
> > 
> > Hmm...
> > Vedran,  Can you please post following command result?
> > 
> > # cat /proc/`pidof Xorg`/smaps
> > 
> > I hope to undestand the issue clearly before modify any code.
> 
> No problem:
> 
> http://pastebin.com/d66972025 (long)
> 
> Xorg is from debian unstable.

Hmm...

Your Xorg have pretty large heap. I'm not sure why it happen.
(ATI video card issue?)
Unfortunatelly, It is showed as normal large heap from kernel. then,
I doubt kernel can distinguish X from other process. Probably
oom-adj is most reasonable option....

-------------------------------------------------
[heap]
Size:             433812 kB
Rss:              433304 kB
Pss:              433304 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:       280 kB
Private_Dirty:    433024 kB
Referenced:       415656 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB




