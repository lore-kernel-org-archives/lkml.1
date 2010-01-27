Return-Path: <linux-kernel-owner+w=401wt.eu-S1754975Ab0A0AI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975Ab0A0AI7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 19:08:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753923Ab0A0AI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 19:08:57 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37521 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913Ab0A0AI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 19:08:56 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 27 Jan 2010 09:05:31 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "containers@lists.osdl.org" <containers@lists.osdl.org>
Subject: Re: [PATCH 1/2] cgroups: Fix to return errno in a failure path
Message-Id: <20100127090531.546f8bea.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <6599ad831001261501q2e6e54bckebb3d2d225ecc126@mail.gmail.com>
References: <4B5EA4EC.8020700@cn.fujitsu.com>
	<6599ad831001261501q2e6e54bckebb3d2d225ecc126@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jan 2010 15:01:26 -0800
Paul Menage <menage@google.com> wrote:

> On Tue, Jan 26, 2010 at 12:16 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> >
> > Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> 
> Acked-by: Paul Menage <menage@google.com>
> 
Thank you.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

> > ---
> >  cgroup.c |    7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> >
> > --- a/kernel/cgroup.c.orig      2010-01-19 16:37:37.000000000 +0800
> > +++ a/kernel/cgroup.c   2010-01-19 16:39:07.000000000 +0800
> > @@ -3279,14 +3279,17 @@ static long cgroup_create(struct cgroup
> >
> >        for_each_subsys(root, ss) {
> >                struct cgroup_subsys_state *css = ss->create(ss, cgrp);
> > +
> >                if (IS_ERR(css)) {
> >                        err = PTR_ERR(css);
> >                        goto err_destroy;
> >                }
> >                init_cgroup_css(css, ss, cgrp);
> > -               if (ss->use_id)
> > -                       if (alloc_css_id(ss, parent, cgrp))
> > +               if (ss->use_id) {
> > +                       err = alloc_css_id(ss, parent, cgrp);
> > +                       if (err)
> >                                goto err_destroy;
> > +               }
> >                /* At error, ->destroy() callback has to free assigned ID. */
> >        }
> >
> >
> 

