Return-Path: <linux-kernel-owner+w=401wt.eu-S1763923AbZAUKf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763923AbZAUKf4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 05:35:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755382AbZAUKfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 05:35:46 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36273 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219AbZAUKfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 05:35:45 -0500
Date: Wed, 21 Jan 2009 19:34:36 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Paul Menage <menage@google.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 1.5/4] cgroup: delay populate css id
Message-Id: <20090121193436.c314ad7d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <6599ad830901210136j9baf45ft4c86a93fec70827f@mail.gmail.com>
References: <20090115192120.9956911b.kamezawa.hiroyu@jp.fujitsu.com>
	<20090115192712.33b533c3.kamezawa.hiroyu@jp.fujitsu.com>
	<6599ad830901191739t45c793afk2ceda8fc430121ce@mail.gmail.com>
	<20090120110221.005e116c.kamezawa.hiroyu@jp.fujitsu.com>
	<6599ad830901191823q556faeeub28d02d39dda7396@mail.gmail.com>
	<20090120115832.0881506c.kamezawa.hiroyu@jp.fujitsu.com>
	<20090120144337.82ed51d5.kamezawa.hiroyu@jp.fujitsu.com>
	<6599ad830901210136j9baf45ft4c86a93fec70827f@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jan 2009 01:36:32 -0800
Paul Menage <menage@google.com> wrote:

> On Mon, Jan 19, 2009 at 9:43 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > +static void populate_css_id(struct cgroup_subsys_state *css)
> > +{
> > +       struct css_id *id = rcu_dereference(css->id);
> > +       if (id)
> > +               rcu_assign_pointer(id->css, css);
> > +}
> 
> I don't think this needs to be split out into a separate function.
ok.

> Also, there's no need for an rcu_dereference(), since we're holding
> cgroup_mutex.
> 
Sure. I'll fix.

I'll merge this behavior to CSS ID patch and post it again.

Thanks,
-Kame

