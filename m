Return-Path: <linux-kernel-owner+w=401wt.eu-S1758028AbYFXDUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028AbYFXDUt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 23:20:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbYFXDUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 23:20:42 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:57596 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbYFXDUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 23:20:41 -0400
Date: Tue, 24 Jun 2008 12:26:26 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>, linux-mm@kvack.org,
       balbir@linux.vnet.ibm.com, xemul@openvz.org,
       linux-kernel@vger.kernel.org
Subject: Re: [bad page] memcg: another bad page at page migration
 (2.6.26-rc5-mm3 + patch collection)
Message-Id: <20080624122626.913030bd.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080624122257.ee590a80.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080623145341.0a365c67.nishimura@mxp.nes.nec.co.jp>
	<20080623150817.628aef9f.kamezawa.hiroyu@jp.fujitsu.com>
	<20080623202111.f2c54e21.kamezawa.hiroyu@jp.fujitsu.com>
	<20080623204448.2c4326ab.nishimura@mxp.nes.nec.co.jp>
	<20080624103709.3b5db84d.nishimura@mxp.nes.nec.co.jp>
	<20080624122257.ee590a80.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2008 12:22:57 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Tue, 24 Jun 2008 10:37:09 +0900
> Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> 
> > > I don't use shmem explicitly, but I'll test this patch anyway
> > > and report the result.
> > > 
> > Unfortunately, this patch doesn't solve my problem, hum...
> > I'll dig more, too.
> > In my test, I don't use large amount of memory, so I think
> > no swap activities happens, perhaps.
> > 
> Sigh, one hint in the log is
> ==
> Bad page state in process 'switch.sh'
> page:ffffe2000c8e59c0 flags:0x0200000000080018 mapping:000
> 0000000000000 mapcount:0 count:0
> cgroup:ffff81062a817050
> ==
> 
> - the page was mapped one.
> - a page is swapbacked ....Anon or Shmem/tmpfs.
> - mapping is NULL
> 
ignore this... free_hot_cold_page() clears page->mapping. (--;

-Kame

