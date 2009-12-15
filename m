Return-Path: <linux-kernel-owner+w=401wt.eu-S934188AbZLOX7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934188AbZLOX7R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 18:59:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758647AbZLOX7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 18:59:13 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:43561 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756042AbZLOX7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 18:59:03 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 16 Dec 2009 08:55:52 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       containers@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, Dan Malek <dan@embeddedalley.com>,
       Vladislav Buzov <vbuzov@embeddedalley.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH RFC v2 1/4] cgroup: implement eventfd-based generic API
  for notifications
Message-Id: <20091216085552.91ebc559.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <cc557aab0912150703qcfe6458paa7da71cb032cb93@mail.gmail.com>
References: <cover.1260571675.git.kirill@shutemov.name>
	<ca59c422b495907678915db636f70a8d029cbf3a.1260571675.git.kirill@shutemov.name>
	<cc557aab0912150111k41517b41t8999568db3bd8daa@mail.gmail.com>
	<20091215183533.1a1e87d9.kamezawa.hiroyu@jp.fujitsu.com>
	<cc557aab0912150703qcfe6458paa7da71cb032cb93@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Dec 2009 17:03:37 +0200
"Kirill A. Shutemov" <kirill@shutemov.name> wrote:
> >> > +       /*
> >> > +        * Unregister events and notify userspace.
> >> > +        * FIXME: How to avoid race with cgroup_event_remove_work()
> >> > +        *        which runs from workqueue?
> >> > +        */
> >> > +       mutex_lock(&cgrp->event_list_mutex);
> >> > +       list_for_each_entry_safe(event, tmp, &cgrp->event_list, list) {
> >> > +               cgroup_event_remove(event);
> >> > +               eventfd_signal(event->eventfd, 1);
> >> > +       }
> >> > +       mutex_unlock(&cgrp->event_list_mutex);
> >> > +
> >> > +out:
> >> >        return ret;
> >> >  }
> >
> > How ciritical is this FIXME ?
> > But Hmm..can't we use RCU ?
> 
> It's not reasonable to have RCU here, since event_list isn't mostly-read.
> 
ok.

Thanks,
-Kame

