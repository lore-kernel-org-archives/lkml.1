Return-Path: <linux-kernel-owner+w=401wt.eu-S1755470AbYKQGbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470AbYKQGbJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 01:31:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbYKQGa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 01:30:56 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:41109 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554AbYKQGaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 01:30:55 -0500
Date: Mon, 17 Nov 2008 15:30:12 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [PATCH] mm: evict streaming IO cache first
Message-Id: <20081117153012.51ece88f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081116204720.1b8cbe18.akpm@linux-foundation.org>
References: <20081115181748.3410.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20081115210039.537f59f5.akpm@linux-foundation.org>
	<alpine.LFD.2.00.0811161013270.3468@nehalem.linux-foundation.org>
	<49208E9A.5080801@redhat.com>
	<20081116204720.1b8cbe18.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Nov 2008 20:47:20 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sun, 16 Nov 2008 16:20:26 -0500 Rik van Riel <riel@redhat.com> wrote:
> Anyway, we need to do something.
> 
> Shouldn't get_scan_ratio() be handling this case already?
> 
Hmm, could I make a question ?

I think

  - recent_rolated[LRU_FILE] is incremented when file cache is moved from
    ACTIVE_FILE to INACTIVE_FILE.
  - recent_scanned[LRU_FILE] is sum of scanning numbers on INACTIVE/ACTIVE list
    of file.
  - file caches are added to INACITVE_FILE, at first.
  - get_scan_ratio() calculates %file to be

                         file        recent rotated.
   %file = IO_cost * ------------ / -------------
                      anon + file    recent scanned.

But when "files are used by streaming or some touch once application",
there is no rotation because they are in INACTIVE FILE at first add_to_lru().
But recent_rotated will not increase while recent_scanned goes bigger and bigger.

Then %file goes to 0 rapidly.

Hmm?

Thanks,
-kame

