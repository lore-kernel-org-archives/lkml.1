Return-Path: <linux-kernel-owner+w=401wt.eu-S1752479AbZFECWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479AbZFECWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 22:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751576AbZFECWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 22:22:09 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:50604 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbZFECWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 22:22:08 -0400
Date: Fri, 5 Jun 2009 11:20:36 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: balbir@linux.vnet.ibm.com, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] remove memory.limit v.s. memsw.limit comparison.
Message-Id: <20090605112036.2dd64ab1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090605093420.0b208c33.nishimura@mxp.nes.nec.co.jp>
References: <20090604141043.9a1064fd.kamezawa.hiroyu@jp.fujitsu.com>
	<20090604123625.GE7504@balbir.in.ibm.com>
	<0921392c77890fc84fa69653ae4f31d9.squirrel@webmail-b.css.fujitsu.com>
	<20090605093420.0b208c33.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Jun 2009 09:34:20 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> > Sorry, I don't push this patch as this is. But adding documentation about
> > "What happens when you set memory.limit == memsw.limit" will be necessary.
> > 
> I agree.
> 
I'd like to prepare some.

> > ...maybe give all jobs to user-land and keep the kernel as it is now
> > is a good choice.
> > 
> > BTW, I'd like to avoid useless swap-out in memory.limit == memsw.limit case.
> > If someone has good idea, please :(
> > 
> I think so too.
> 
> From my simple thoughts, how about changing __mem_cgroup_try_charge() like:
> 
> 1. initialize "noswap" as "bool noswap = !!(mem->res.limit == mem->memsw.limit)".
> 2. add check "if (mem->res.limit == mem->memsw.limit)" on charge failure to mem->res
>    and set "noswap" to true if needed. 
> 3. charge mem->memsw before mem->res.
> 
> There would be other ideas, but I prefer 1 among these choices.
> 
ok, thank you for advices.

Regards,
-Kame


> 
> Thanks,
> Daisuke Nishimura.
> 

