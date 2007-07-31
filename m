Return-Path: <linux-kernel-owner+w=401wt.eu-S940316AbXGaA2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940316AbXGaA2o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 20:28:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937923AbXGaA2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 20:28:34 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60418 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936407AbXGaA2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 20:28:32 -0400
Date: Tue, 31 Jul 2007 09:29:28 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Zoltan Menyhart <Zoltan.Menyhart@bull.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       "tony.luck@intel.com" <tony.luck@intel.com>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH] flush icache before set_pte() take 5.
Message-Id: <20070731092928.c6da9f25.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <46ADF61A.6000509@bull.net>
References: <20070728150319.d19f531f.kamezawa.hiroyu@jp.fujitsu.com>
	<46ADF61A.6000509@bull.net>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jul 2007 16:30:50 +0200
Zoltan Menyhart <Zoltan.Menyhart@bull.net> wrote:

> KAMEZAWA Hiroyuki wrote:
> 
> > Considerations:
> >   - I can add CONFIG_MONTECITO if necessary. But it will be confusing, I think.
> 
> What about this trick below?
> 
> identify_cpu() finds out the "c->family".
> If any of the CPUs has c->family==32 (and the future versions...) then
> set a global flag. And:
> 
> static inline void sync_icache_dcache(pte_t pte) {
>         if (pte_exec(pte) && global_flag)
>                 __sync_icache_dcache(pte);
> }
> 
Hmm...maybe better for old cpus even if cache miss occurs here.
I'll add add-on patch in take6.

Thanks,
-Kame

