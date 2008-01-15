Return-Path: <linux-kernel-owner+w=401wt.eu-S1757019AbYAOCWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757019AbYAOCWW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 21:22:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbYAOCWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 21:22:14 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:39332 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbYAOCWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 21:22:12 -0500
Date: Tue, 15 Jan 2008 11:20:56 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC][PATCH 3/5] add /dev/mem_notify device
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Marcelo Tosatti <marcelo@kvack.org>,
       Daniel Spang <daniel.spang@gmail.com>, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080115111035.d516639a.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080115100029.1178.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080115111035.d516639a.kamezawa.hiroyu@jp.fujitsu.com>
Message-Id: <20080115110918.118B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kame

> > +	if (pressure) {
> > +		nr_wakeup = max_t(int, atomic_read(&nr_watcher_task)>>4, 100);
> > +		atomic_long_set(&last_mem_notify, jiffies);
> > +		wake_up_locked_nr(&mem_wait, nr_wakeup);
> > +	}
> What is this for ? and Why ?
> Are there too many waiters ?

my intent is for avoid thundering herd.
100 is heuristic value.

and too many wakeup cause too much memory freed.
I don't want it.

of course, if any problem happened, I will change.
Do you dislike it?


