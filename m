Return-Path: <linux-kernel-owner+w=401wt.eu-S1754023AbZAIHYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbZAIHYT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 02:24:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbZAIHYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 02:24:04 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:34991 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250AbZAIHYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 02:24:02 -0500
Date: Fri, 9 Jan 2009 16:22:55 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] NOOP cgroup subsystem
Message-Id: <20090109162255.4e57f079.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4966F230.4020905@cn.fujitsu.com>
References: <20090109143226.b79d21b4.kamezawa.hiroyu@jp.fujitsu.com>
	<6599ad830901082226h6d47053cp801dafb67b6e2bc9@mail.gmail.com>
	<4966EEDD.5070204@cn.fujitsu.com>
	<6599ad830901082237l664fb403y386482a577ed185e@mail.gmail.com>
	<4966F230.4020905@cn.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Jan 2009 14:44:00 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> Paul Menage wrote:
> > On Thu, Jan 8, 2009 at 10:29 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> >> Agreed, but it can't work by just removing the checking in cgroup mount option,
> > 
> > Right - it's more complicated than that. There are some places in the
> > code that rely on the fact that every hierarchy currently has at least
> > one subsystem (anything that uses find_first_subsystem() for example)
> > and we'd need to work around that.
> > 
> 
> And some other problems, like what's the semantic of /proc/<pid>/cgroup when
> using none subsys.
> 
> I'm afraid even if it's do-able it might require a lot of changes in cgroup.
> 
After quick look,
it seems that css_set->subsys==empty case cannot be handled and need much
changes. Maintaining hierarchy tree itself seems difficult.

I think cgroup is being stable day by day. So, I don't like to crash it
by big hummer for this tiny feature.

How about adding "none" subsys  ? (I'd like to set default=y ;)

As Paul said, "Show multiple hierarchy view for each mount point"
seems attractive but it's not very fundametal, IMHO.
If we can increase subsys_id dynamically or subsys can have
multiple root node, the situation will change.

Thanks,
-Kame

