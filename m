Return-Path: <linux-kernel-owner+w=401wt.eu-S934316AbZLMBtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934316AbZLMBtp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 20:49:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934296AbZLMBto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 20:49:44 -0500
Received: from rcpt-mqugw.biglobe.ne.jp ([133.205.19.69]:56932 "HELO
	rcpt-mqugw.biglobe.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934287AbZLMBtn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 20:49:43 -0500
X-Biglobe-Sender: <d-nishimura@mtf.biglobe.ne.jp>
Date: Sat, 12 Dec 2009 23:34:09 +0900
From: Daisuke Nishimura <d-nishimura@mtf.biglobe.ne.jp>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: containers@lists.linux-foundation.org, linux-mm@kvack.org,
       Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, Dan Malek <dan@embeddedalley.com>,
       Vladislav Buzov <vbuzov@embeddedalley.com>,
       linux-kernel@vger.kernel.org,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH RFC v2 3/4] memcg: rework usage of stats by soft limit
Message-Id: <20091212233409.60da66fb.d-nishimura@mtf.biglobe.ne.jp>
In-Reply-To: <cc557aab0912120506x56b9a707ob556035fdcf40a22@mail.gmail.com>
References: <cover.1260571675.git.kirill@shutemov.name>
	<ca59c422b495907678915db636f70a8d029cbf3a.1260571675.git.kirill@shutemov.name>
	<c1847dfb5c4fed1374b7add236d38e0db02eeef3.1260571675.git.kirill@shutemov.name>
	<747ea0ec22b9348208c80f86f7a813728bf8e50a.1260571675.git.kirill@shutemov.name>
	<20091212125046.14df3134.d-nishimura@mtf.biglobe.ne.jp>
	<cc557aab0912120506x56b9a707ob556035fdcf40a22@mail.gmail.com>
Reply-To: nishimura@mxp.nes.nec.co.jp
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-MIME-Autoconverted: from 8bit to quoted-printable by rcpt-mqugw.biglobe.ne.jp id nBCEaxdU030812
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Dec 2009 15:06:52 +0200
"Kirill A. Shutemov" <kirill@shutemov.name> wrote:

> On Sat, Dec 12, 2009 at 5:50 AM, Daisuke Nishimura
> <d-nishimura@mtf.biglobe.ne.jp> wrote:
> > Sorry, I disagree this change.
> >
> > mem_cgroup_soft_limit_check() is used for checking how much current usage exceeds
> > the soft_limit_in_bytes and updating softlimit tree asynchronously, instead of
> > checking every charge/uncharge. What if you change the soft_limit_in_bytes,
> > but the number of charges and uncharges are very balanced afterwards ?
> > The softlimit tree will not be updated for a long time.
> 
> I don't see how my patch affects the logic you've described.
> Statistics updates and
> checks in the same place. It just uses decrement instead of increment.
> 
Ah... my bad. Ignore this comment, please.
I misunderstood this patch.

> >
> > And IIUC, it's the same for your threshold feature, right ?
> > I think it would be better:
> >
> > - discard this change.
> > - in 4/4, rename mem_cgroup_soft_limit_check to mem_cgroup_event_check,
> >  and instead of adding a new STAT counter, do like:
> >
> >        if (mem_cgroup_event_check(mem)) {
> >                mem_cgroup_update_tree(mem, page);
> >                mem_cgroup_threshold(mem);
> >        }
> 
> I think that mem_cgroup_update_tree() and mem_cgroup_threshold() should be
> run with different frequency. How to share MEM_CGROUP_STAT_EVENTS
> between soft limits and thresholds in this case?
> 
hmm, both softlimit and your threshold count events at the same place(charge and uncharge).
So, I think those events can be shared.
Is there any reason they should run in different frequency ?


Thanks,
Daisuke Nishimura.
