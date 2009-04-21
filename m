Return-Path: <linux-kernel-owner+w=401wt.eu-S1756965AbZDUBSM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756965AbZDUBSM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 21:18:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755388AbZDUBR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 21:17:56 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:39472 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217AbZDUBRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 21:17:55 -0400
Date: Tue, 21 Apr 2009 10:16:17 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrea Righi <righi.andrea@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, dhaval@linux.vnet.ibm.com,
       arozansk@redhat.com, jens.axboe@oracle.com,
       Balbir Singh <balbir@linux.vnet.ibm.com>, paolo.valente@unimore.it,
       jmoyer@redhat.com, fernando@intellilink.co.jp, oz-kernel@redhat.com,
       fchecconi@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       menage@google.com
Subject: Re: IO controller discussion (Was: Re: [PATCH 01/10] Documentation)
Message-Id: <20090421101617.27d62587.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090419155358.GC5514@linux>
References: <20090312001146.74591b9d.akpm@linux-foundation.org>
	<20090312180126.GI10919@redhat.com>
	<49D8CB17.7040501@gmail.com>
	<20090407064046.GB20498@redhat.com>
	<20090408203756.GB10077@linux>
	<20090416183753.GE8896@redhat.com>
	<20090417093656.GA5246@linux>
	<20090417141358.GD29086@redhat.com>
	<661de9470904180619k34e7998ch755a2ad3bed9ce5e@mail.gmail.com>
	<20090419134508.GG8493@redhat.com>
	<20090419155358.GC5514@linux>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Apr 2009 17:53:59 +0200
Andrea Righi <righi.andrea@gmail.com> wrote:
> > 
> > Got a question for you. Does memory controller already have the per cgroup
> > dirty pages limit? If no, has this been discussed in the past? if yes,
> > what was the conclsion?
> 

IMHO, dirty page handling and I/O throttling is a different problem.

 - A task (or cgroup) which makes the page dirty
 and
 - A task (or cgroup) to which a page is accounted

Is different from each other, in general.

I have a plan to add dirty_ratio to memcg, but it's for avoiding massive stavation in
memory reclaim, not for I/O control.

If you want to implement I/O throttle in MM layer, plz don't depend on memcg.
The perpose is different.

Thanks,
-Kame

