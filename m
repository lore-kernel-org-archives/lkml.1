Return-Path: <linux-kernel-owner+w=401wt.eu-S1754717AbYKNE6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbYKNE6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 23:58:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751192AbYKNE6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 23:58:37 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:52856 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbYKNE6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 23:58:36 -0500
From: "Satoshi UCHIDA" <s-uchida@ap.jp.nec.com>
To: "'Vivek Goyal'" <vgoyal@redhat.com>,
       "'Nauman Rafique'" <nauman@google.com>
Cc: "'Peter Zijlstra'" <peterz@infradead.org>, <linux-kernel@vger.kernel.org>,
       <containers@lists.linux-foundation.org>,
       <virtualization@lists.linux-foundation.org>, <jens.axboe@oracle.com>,
       "'Hirokazu Takahashi'" <taka@valinux.co.jp>,
       "'Ryo Tsuruta'" <ryov@valinux.co.jp>,
       "'Andrea Righi'" <righi.andrea@gmail.com>, <fernando@oss.ntt.co.jp>,
       <balbir@linux.vnet.ibm.com>,
       "'Andrew Morton'" <akpm@linux-foundation.org>, <menage@google.com>,
       <ngupta@google.com>, "'Rik van Riel'" <riel@redhat.com>,
       "'Jeff Moyer'" <jmoyer@redhat.com>, <dpshah@google.com>,
       "'Mike Waychison'" <mikew@google.com>, <rohitseth@google.com>,
       "'Fabio Checconi'" <fchecconi@gmail.com>, <paolo.valente@unimore.it>
References: <20081106163957.GB7461@redhat.com> <1225990327.7803.4776.camel@twins> <20081106170830.GD7461@redhat.com> <e98e18940811061507t3e19183byf2b8b291458ba81b@mail.gmail.com> <20081107141943.GC21884@redhat.com> <e98e18940811071336n58a073d8w2cbaeddd5657d1e9@mail.gmail.com> <20081110141143.GC26956@redhat.com> <e98e18940811111155q4bd73480pebe088fa1adbe2e4@mail.gmail.com> <20081111223024.GA31527@redhat.com> <e98e18940811121320w5f321302n13b526887cbb4012@mail.gmail.com> <20081113180821.GF7542@redhat.com>
In-Reply-To: <20081113180821.GF7542@redhat.com>
Subject: RE: [patch 0/4] [RFC] Another proportional weight IO controller
Date: Fri, 14 Nov 2008 13:58:13 +0900
Message-ID: <002c01c94615$99061520$cb123f60$@jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AclFutb+o1gNwGewRuGHkMVBow9VSwAWnSTw
Content-Language: ja
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Vivek

> 
> I think doing proportional weight division at elevator level will be
> little difficult, because if we go for a full hierarchical solution then
> we will be doing proportional weight division among tasks as well as
> groups.
> 
> For example, consider this. Assume at root level there are three tasks
> A, B, C and two cgroups D and E. Now for proportional weight division we
> should consider A, B, C, D and E at same level and then try to divide
> the BW (Thanks to peterz for clarifying this).
> 
> Other approach could be that consider A, B, C in root cgroup and then
> consider root, D and E competing groups and try to divide the BW. But
> this is not how cpu controller operates and this approach I think was
> initially implemented for group scheduling in cpu controller and later
> changed.
> 
> How the proportional weight division is done among tasks is a property
> of IO scheduler. cfq decides to use time slices according to priority
> and bfq decides to use tokens. So probably we can't move this to common
> elevator layer.
> 
> I think Satoshi's cfq controller patches also do not seem to be considering
> A, B, C, D and E to be at same level, instead it treats cgroup "/" , D and
> E
> at same level and tries to do proportional BW division among these.
> Satoshi, please correct me, if that's not the case.
> 

Yes.
I think that a controller should be divided share among "/(root)" and two groups.
This reason is follows:

  * If these tasks are handled at same level, it is enough by using a traditional 
    CFQ scheduler.
    If you want to make all tasks in the same group the same priority(parameter),
    It is not I/O control but is parameter control.
    
  * I think that the group means the environment which makes some sense and 
    user want to control I/O per groups.
    Next, the group is the environment.  So, tasks within the group will have
    priorities for themselves respectively as traditional environment.
    Of course, group may not be need to control I/O.
    In such time, a ioprio of tasks should be set the same priority.

Therefore, our scheduler controls among group and then among tasks


Satoshi UCHIDA

