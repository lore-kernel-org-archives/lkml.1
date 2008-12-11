Return-Path: <linux-kernel-owner+w=401wt.eu-S1755952AbYLKA0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952AbYLKA0g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 19:26:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753639AbYLKA01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 19:26:27 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53566 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657AbYLKA00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 19:26:26 -0500
Date: Thu, 11 Dec 2008 09:25:31 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Paul Menage <menage@google.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 1/6] memcg: fix pre_destory handler
Message-Id: <20081211092531.175c6830.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <6599ad830812101035v33dbc6cfh57aa5510f6d65d54@mail.gmail.com>
References: <20081209200213.0e2128c1.kamezawa.hiroyu@jp.fujitsu.com>
	<20081209200647.a1fa76a9.kamezawa.hiroyu@jp.fujitsu.com>
	<6599ad830812100240g5e549a5cqe29cbea736788865@mail.gmail.com>
	<29741.10.75.179.61.1228908581.squirrel@webmail-b.css.fujitsu.com>
	<6599ad830812101035v33dbc6cfh57aa5510f6d65d54@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Dec 2008 10:35:34 -0800
Paul Menage <menage@google.com> wrote:

> On Wed, Dec 10, 2008 at 3:29 AM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> >
> > (BTW, I don't like hierarchy-walk-by-small-locks approarch now because
> >  I'd like to implement scan-and-stop-continue routine.
> >  See how readdir() aginst /proc scans PID. It's very roboust against
> >  very temporal PIDs.)
> 
> So you mean that you want to be able to sleep, and then contine
> approximately where you left off, without keeping any kind of
> reference count on the last cgroup that you touched? OK, so in that
> case I agree that you would need some kind of hierarch
> 
> > I tried similar patch and made it to use only one shared refcnt.
> > (my previous patch...)
> 
> A crucial difference is that your css_tryget() fails if the cgroups
> framework is trying to remove the cgroup but might abort due to
> another subsystem holding a reference, whereas mine spins and if the
> rmdir is aborted it will return a refcount.
> 
sure.
> >
> > We need rolling update of refcnts and rollback. Such code tends to make
> > a hole (This was what my first patch did...).
> 
> Can you clarify what you mean by "rolling update of refcnts"?
> 
 for(..i++)
	atomic_dec/inc( refcnt[i)

But my first version of this patch did above. I can write it again easily.

Thanks,
-Kame

