Return-Path: <linux-kernel-owner+w=401wt.eu-S1753569AbYFXHTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569AbYFXHTj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 03:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850AbYFXHTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 03:19:31 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:50784 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbYFXHTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 03:19:31 -0400
Date: Tue, 24 Jun 2008 16:19:03 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org, balbir@linux.vnet.ibm.com, xemul@openvz.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: end migration fix (was  [bad page] memcg:
 another bad page at page migration (2.6.26-rc5-mm3 + patch collection))
Message-Id: <20080624161903.238eb868.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20080624145127.539eb5ff.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080623145341.0a365c67.nishimura@mxp.nes.nec.co.jp>
	<20080624145127.539eb5ff.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2008 14:51:27 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> Hi, Nishimura-san. thank you for all your help. 
> 
> I think this one is......hopefully.
> 
I hope so too :)

I think the corner case that this patch fixes is likely
in my case(there may be other cases though..).

I'm testing this one now.

> ==
> 
> In general, mem_cgroup's charge on ANON page is removed when page_remove_rmap()
> is called.
> 
> At migration, the newpage is remapped again by remove_migration_ptes(). But
> pte may be already changed (by task exits).
> It is charged at page allocation but have no chance to be uncharged in that
> case because it is never added to rmap.
> 
I think "charged by mem_cgroup_prepare_migration()" is more precise.

> Handle that corner case in mem_cgroup_end_migration().
> 
> 


Thanks,
Daisuke Nishimura.
