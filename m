Return-Path: <linux-kernel-owner+w=401wt.eu-S1755456AbYFXHYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbYFXHYt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 03:24:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751830AbYFXHYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 03:24:41 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48674 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbYFXHYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 03:24:40 -0400
Date: Tue, 24 Jun 2008 16:30:24 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: linux-mm@kvack.org, balbir@linux.vnet.ibm.com, xemul@openvz.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: end migration fix (was  [bad page] memcg:
 another bad page at page migration (2.6.26-rc5-mm3 + patch collection))
Message-Id: <20080624163024.7acd8419.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080624161903.238eb868.nishimura@mxp.nes.nec.co.jp>
References: <20080623145341.0a365c67.nishimura@mxp.nes.nec.co.jp>
	<20080624145127.539eb5ff.kamezawa.hiroyu@jp.fujitsu.com>
	<20080624161903.238eb868.nishimura@mxp.nes.nec.co.jp>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2008 16:19:03 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> On Tue, 24 Jun 2008 14:51:27 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > Hi, Nishimura-san. thank you for all your help. 
> > 
> > I think this one is......hopefully.
> > 
> I hope so too :)
> 
> I think the corner case that this patch fixes is likely
> in my case(there may be other cases though..).
> 
> I'm testing this one now.
> 
> > ==
> > 
> > In general, mem_cgroup's charge on ANON page is removed when page_remove_rmap()
> > is called.
> > 
> > At migration, the newpage is remapped again by remove_migration_ptes(). But
> > pte may be already changed (by task exits).
> > It is charged at page allocation but have no chance to be uncharged in that
> > case because it is never added to rmap.
> > 
> I think "charged by mem_cgroup_prepare_migration()" is more precise.
> 
Thanks, will rewrite.

Regards,
-Kame


> > Handle that corner case in mem_cgroup_end_migration().
> > 
> > 
> 
> 
> Thanks,
> Daisuke Nishimura.
> 

