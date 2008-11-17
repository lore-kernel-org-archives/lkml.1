Return-Path: <linux-kernel-owner+w=401wt.eu-S1753087AbYKQIW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbYKQIW5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 03:22:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756601AbYKQIWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 03:22:46 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46465 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbYKQIWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 03:22:45 -0500
Date: Mon, 17 Nov 2008 17:22:02 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Rik van Riel" <riel@redhat.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       "Gene Heskett" <gene.heskett@gmail.com>
Subject: Re: [PATCH] mm: evict streaming IO cache first
Message-Id: <20081117172202.343e1b35.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <2f11576a0811162303t51609098o6cd765c04d791581@mail.gmail.com>
References: <20081115181748.3410.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20081115210039.537f59f5.akpm@linux-foundation.org>
	<alpine.LFD.2.00.0811161013270.3468@nehalem.linux-foundation.org>
	<49208E9A.5080801@redhat.com>
	<20081116204720.1b8cbe18.akpm@linux-foundation.org>
	<20081117153012.51ece88f.kamezawa.hiroyu@jp.fujitsu.com>
	<2f11576a0811162239w58555c6dq8a61ec184b22bd52@mail.gmail.com>
	<20081117155417.5cc63907.kamezawa.hiroyu@jp.fujitsu.com>
	<2f11576a0811162303t51609098o6cd765c04d791581@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Nov 2008 16:03:48 +0900
"KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com> wrote:
> > How about resetting zone->recent_scanned/rotated to be some value calculated from
> > INACTIVE_ANON/INACTIVE_FILE at some time (when the system is enough idle) ?
> 
> in get_scan_ratio()
> 
But active/inactive ratio (and mapped_ratio) is not handled there.

Follwoing 2 will return the same scan ratio.
==case 1==
  active_anon = 480M
  inactive_anon = 32M
  active_file = 2M
  inactive_file = 510M

==case 2==
  active_anon = 480M
  inactive_anon = 32M
  active_file = 480M
  inactive_file = 32M
==



-Kame


