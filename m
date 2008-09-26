Return-Path: <linux-kernel-owner+w=401wt.eu-S1755555AbYIZJxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555AbYIZJxy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 05:53:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbYIZJxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 05:53:44 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36020 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbYIZJxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 05:53:44 -0400
Date: Fri, 26 Sep 2008 18:59:44 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "xemul@openvz.org" <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Dave Hansen <haveblue@us.ibm.com>,
       ryov@valinux.co.jp
Subject: Re: [PATCH 3/12] memcg make root cgroup unlimited.
Message-Id: <20080926185944.c2e7055a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <48DCAB8C.5030405@linux.vnet.ibm.com>
References: <20080925151124.25898d22.kamezawa.hiroyu@jp.fujitsu.com>
	<20080925151543.ba307898.kamezawa.hiroyu@jp.fujitsu.com>
	<48DCA01C.9020701@linux.vnet.ibm.com>
	<20080926182122.c7c88a65.kamezawa.hiroyu@jp.fujitsu.com>
	<48DCAB8C.5030405@linux.vnet.ibm.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Sep 2008 14:59:48 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> > I think "feature" flag is complicated, at this stage.
> > We'll add more features and not settled yet.
> > 
> 
> I know.. but breaking ABI is a bad bad thing. We'll have to keep the feature
> flags extensible (add new things). If we all feel we don't have enough users
> affected by this change, I might agree with you and make that change.
> 
Hmm...I'll drop this and add force_empty_may_fail logic in changes in force_empty.

> > Hmm, if you don't like this,
> > calling try_to_free_page() at force_empty() instead of move_account() ?
> > 
> 
> Not sure I understand this.
> 
In following series, force_empty() uses move_account() rather than forget all.
By this, accounted file caches are kept as accounted and the whole accounting
will be sane.

Another choice is calling try_to_free_pages() at force_empty rather than forget all
and makes memory usage to be Zero. This will also makes the whole accounting sange.

Thanks,
-Kame

