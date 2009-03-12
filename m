Return-Path: <linux-kernel-owner+w=401wt.eu-S1754487AbZCLEP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487AbZCLEP5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 00:15:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbZCLEPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 00:15:49 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49841 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbZCLEPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 00:15:48 -0400
Date: Thu, 12 Mar 2009 13:14:19 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH 2/5] add softlimit to res_counter
Message-Id: <20090312131419.5250cdaf.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090312041038.GF23583@balbir.in.ibm.com>
References: <20090312095247.bf338fe8.kamezawa.hiroyu@jp.fujitsu.com>
	<20090312095612.4a7758e1.kamezawa.hiroyu@jp.fujitsu.com>
	<20090312035444.GC23583@balbir.in.ibm.com>
	<20090312125839.3b01e20c.kamezawa.hiroyu@jp.fujitsu.com>
	<20090312041038.GF23583@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Mar 2009 09:40:38 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> Correct me if I am wrong, but this boils down to checking if the top
> root is above it's soft limit? 

  Level_1    soft limit=400M
    Level_2  soft limit=200M
      Level_3  no soft limit
      Level_3  softlimit=100M
    Level_2  soft limit=200M
    Level_2  soft limit=200M

When checking Level3, we need to check Level_2 and Level_1.


> Instead of checking all the way up in
> the hierarchy, can't we do a conditional check for
> 
>         c->parent == NULL && (c->softlimit < c->usage)
> 
> BTW, I would prefer to split the word softlimit to soft_limit, it is
> more readable that way.
> 
Ok, it will give me tons of HUNK but will do ;)

Thanks,
-Kame

