Return-Path: <linux-kernel-owner+w=401wt.eu-S1751739Ab0ADAhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739Ab0ADAhM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 19:37:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751438Ab0ADAhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 19:37:11 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:50927 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294Ab0ADAhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 19:37:10 -0500
Date: Mon, 4 Jan 2010 06:06:12 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: containers@lists.linux-foundation.org, linux-mm@kvack.org,
       Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Pavel Emelyanov <xemul@openvz.org>, Dan Malek <dan@embeddedalley.com>,
       Vladislav Buzov <vbuzov@embeddedalley.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Alexander Shishkin <virtuoso@slind.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 0/4] cgroup notifications API and memory thresholds
Message-ID: <20100104003612.GF16187@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <cover.1262186097.git.kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <cover.1262186097.git.kirill@shutemov.name>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kirill A. Shutemov <kirill@shutemov.name> [2009-12-30 17:57:55]:

> This patchset introduces eventfd-based API for notifications in cgroups and
> implements memory notifications on top of it.
> 
> It uses statistics in memory controler to track memory usage.
> 
> Output of time(1) on building kernel on tmpfs:
> 
> Root cgroup before changes:
> 	make -j2  506.37 user 60.93s system 193% cpu 4:52.77 total
> Non-root cgroup before changes:
> 	make -j2  507.14 user 62.66s system 193% cpu 4:54.74 total
> Root cgroup after changes (0 thresholds):
> 	make -j2  507.13 user 62.20s system 193% cpu 4:53.55 total
> Non-root cgroup after changes (0 thresholds):
> 	make -j2  507.70 user 64.20s system 193% cpu 4:55.70 total
> Root cgroup after changes (1 thresholds, never crossed):
> 	make -j2  506.97 user 62.20s system 193% cpu 4:53.90 total
> Non-root cgroup after changes (1 thresholds, never crossed):
> 	make -j2  507.55 user 64.08s system 193% cpu 4:55.63 total
> 
> Any comments?

Hi,

I just saw that the notification work for me using the tool you
supplied. One strange thing was that I got notified even though
the amount of data I was using was reducing, so I hit the notification
two ways

        +------------+-----------
                    1G
                ----> (got notified on increase)
                <---- (got notified on decrease)

I am not against the behaviour, but it can be confusing unless
clarified with the event.

-- 
	Balbir
