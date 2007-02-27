Return-Path: <linux-kernel-owner+w=401wt.eu-S1751427AbXB0BlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427AbXB0BlF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 20:41:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752475AbXB0BlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 20:41:05 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:48338 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbXB0BlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 20:41:03 -0500
Date: Tue, 27 Feb 2007 10:39:52 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, miklos@szeredi.hu,
       yumiko.sugita.yf@hitachi.com, masami.hiramatsu.pt@hitachi.com,
       hidehiro.kawai.ez@hitachi.com, yuji.kakutani.uw@hitachi.com,
       soshima@redhat.com, haoki@redhat.com, nikita@clusterfs.com
Subject: Re: [RFC][PATCH 0/3] VM throttling: avoid blocking occasional
 writers
Message-Id: <20070227103952.4fc236bd.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <45E38048.3020705@hitachi.com>
References: <45DED819.9040404@hitachi.com>
	<20070224134646.0f4edeae.kamezawa.hiroyu@jp.fujitsu.com>
	<45E38048.3020705@hitachi.com>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Feb 2007 09:50:16 +0900
Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com> wrote:

> Hi Kamezawa-san,
> 
> thanks for your reply.
> 
> KAMEZAWA Hiroyuki wrote:
> > Interesting, but how about adjust this parameter like below instead of
> > adding new control knob ?(this kind of knob is not easy to use.)
> >
> > ==
> >                 struct writeback_control wbc = {
> >                         .bdi            = bdi,
> >                         .sync_mode      = WB_SYNC_NONE,
> >                         .older_than_this = NULL,
> >                         .nr_to_write    = 0,
> >                         .range_cyclic   = 1,
> >                 };
> > <snip>
> >                 if (nr_reclaimable) {
> > 			/* Just do what I can do */
> > 			dirty_pages_on_device = count_dirty_pages_on_device_limited(bdi, writechunk);
> > 			wbc.nr_to_write = dirty_pages_on_device.
> > 			writeback_inodes(&wbc);
> >
> > ==
> >
> > count_dirty_pages_on_device_limited(bdi, writechunk) above returns
> > dirty pages on bdi. if # of dirty_pages on bdi is larger than writechunk,
> > just returns writechunk.
> 
> 
> I think that way is not enough to control the total amount of
> Dirty+Writeback.
> 
> In that way, while writeback_inodes() scans for dirty pages and writes
> them back, the caller will be blocked only if the length of the write-
> requests queue is longer than nr_requests.
What nr_request means ?
But Ok, maybe I'm not understanding. What I want to ask you is do 
per-device-write-throttling rather than adding a new parameter.

Bye.
-Kame



