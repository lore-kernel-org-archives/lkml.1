Return-Path: <linux-kernel-owner+w=401wt.eu-S1755977AbYLJHuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbYLJHuQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 02:50:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754761AbYLJHuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 02:50:07 -0500
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:33135 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767AbYLJHuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 02:50:06 -0500
Date: Wed, 10 Dec 2008 13:16:11 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: menage@google.com, KAMEZAWA Hiroyuki <kamezawa.hiroyuki@jp.fujitsu.com>,
       Daisuke Miyakawa <dmiyakawa@google.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [RFC][RFT] memcg fix cgroup_mutex deadlock when cpuset
	reclaims memory
Message-ID: <20081210074611.GA25467@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
	menage@google.com,
	KAMEZAWA Hiroyuki <kamezawa.hiroyuki@jp.fujitsu.com>,
	Daisuke Miyakawa <dmiyakawa@google.com>,
	YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20081210051947.GH7593@balbir.in.ibm.com> <20081210151948.9a83f70a.nishimura@mxp.nes.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20081210151948.9a83f70a.nishimura@mxp.nes.nec.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> [2008-12-10 15:19:48]:

> On Wed, 10 Dec 2008 10:49:47 +0530, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > Hi,
> > 
> > Here is a proposed fix for the memory controller cgroup_mutex deadlock
> > reported. It is lightly tested and reviewed. I need help with review
> > and test. Is the reported deadlock reproducible after this patch? A
> > careful review of the cpuset impact will also be highly appreciated.
> > 
> > From: Balbir Singh <balbir@linux.vnet.ibm.com>
> > 
> > cpuset_migrate_mm() holds cgroup_mutex throughout the duration of
> > do_migrate_pages(). The issue with that is that
> > 
> > 1. It can lead to deadlock with memcg, as do_migrate_pages()
> >    enters reclaim
> > 2. It can lead to long latencies, preventing users from creating/
> >    destroying other cgroups anywhere else
> > 
> > The patch holds callback_mutex through the duration of cpuset_migrate_mm() and
> > gives up cgroup_mutex while doing so.
> > 
> I agree changing cpuset_migrate_mm not to hold cgroup_mutex to fix the dead lock
> is one choice, and it looks good to me at the first impression.
> 
> But I'm not sure it's good to change cpuset(other subsystem) code because of memcg.
> 
> Anyway, I'll test this patch and report the result tomorrow.
> (Sorry, I don't have enough time today.)

Thanks for helping Daisuke-San!

I'll look forward to your test result. I'll continue to pound my
system meanwhile

-- 
	Balbir
