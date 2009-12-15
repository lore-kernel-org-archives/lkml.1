Return-Path: <linux-kernel-owner+w=401wt.eu-S1753293AbZLOBib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbZLOBib (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 20:38:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752287AbZLOBi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 20:38:29 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53318 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbZLOBi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 20:38:26 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 15 Dec 2009 10:35:17 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: nishimura@mxp.nes.nec.co.jp, containers@lists.linux-foundation.org,
       linux-mm@kvack.org, Paul Menage <menage@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, Dan Malek <dan@embeddedalley.com>,
       Vladislav Buzov <vbuzov@embeddedalley.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v2 3/4] memcg: rework usage of stats by soft limit
Message-Id: <20091215103517.75645536.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <cc557aab0912121146y276a8d26v8baee15be1f83a97@mail.gmail.com>
References: <cover.1260571675.git.kirill@shutemov.name>
	<ca59c422b495907678915db636f70a8d029cbf3a.1260571675.git.kirill@shutemov.name>
	<c1847dfb5c4fed1374b7add236d38e0db02eeef3.1260571675.git.kirill@shutemov.name>
	<747ea0ec22b9348208c80f86f7a813728bf8e50a.1260571675.git.kirill@shutemov.name>
	<20091212125046.14df3134.d-nishimura@mtf.biglobe.ne.jp>
	<cc557aab0912120506x56b9a707ob556035fdcf40a22@mail.gmail.com>
	<20091212233409.60da66fb.d-nishimura@mtf.biglobe.ne.jp>
	<cc557aab0912121146y276a8d26v8baee15be1f83a97@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Dec 2009 21:46:08 +0200
"Kirill A. Shutemov" <kirill@shutemov.name> wrote:

> On Sat, Dec 12, 2009 at 4:34 PM, Daisuke Nishimura
> <d-nishimura@mtf.biglobe.ne.jp> wrote:
> > On Sat, 12 Dec 2009 15:06:52 +0200
> > "Kirill A. Shutemov" <kirill@shutemov.name> wrote:
> >
> >> On Sat, Dec 12, 2009 at 5:50 AM, Daisuke Nishimura
> >> <d-nishimura@mtf.biglobe.ne.jp> wrote:
> >> > And IIUC, it's the same for your threshold feature, right ?
> >> > I think it would be better:
> >> >
> >> > - discard this change.
> >> > - in 4/4, rename mem_cgroup_soft_limit_check to mem_cgroup_event_check,
> >> >  and instead of adding a new STAT counter, do like:
> >> >
> >> >        if (mem_cgroup_event_check(mem)) {
> >> >                mem_cgroup_update_tree(mem, page);
> >> >                mem_cgroup_threshold(mem);
> >> >        }
> >>
> >> I think that mem_cgroup_update_tree() and mem_cgroup_threshold() should be
> >> run with different frequency. How to share MEM_CGROUP_STAT_EVENTS
> >> between soft limits and thresholds in this case?
> >>
> > hmm, both softlimit and your threshold count events at the same place(charge and uncharge).
> > So, I think those events can be shared.
> > Is there any reason they should run in different frequency ?
> 
> SOFTLIMIT_EVENTS_THRESH is 1000. If use the same value for thresholds,
> a threshold can
> be exceed on 1000*nr_cpu_id pages. It's too many. I think, that 100 is
> a reasonable value.
> 

Hmm, then what amount of costs does this code add ?

Do you have benchmark result ?

Thanks,
-Kame

