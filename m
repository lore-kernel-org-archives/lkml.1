Return-Path: <linux-kernel-owner+w=401wt.eu-S1753139AbYJAFa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139AbYJAFa5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 01:30:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751638AbYJAFat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 01:30:49 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:44319 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751372AbYJAFas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 01:30:48 -0400
Message-ID: <48E30B02.3030506@linux.vnet.ibm.com>
Date: Wed, 01 Oct 2008 11:00:42 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "xemul@openvz.org" <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Dave Hansen <haveblue@us.ibm.com>,
       ryov@valinux.co.jp
Subject: Re: [PATCH 9/12] memcg allocate all page_cgroup at boot
References: <20080925151124.25898d22.kamezawa.hiroyu@jp.fujitsu.com> <20080925153206.281243dc.kamezawa.hiroyu@jp.fujitsu.com> <48E2F6A9.9010607@linux.vnet.ibm.com> <20081001140748.637b9831.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081001140748.637b9831.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Wed, 01 Oct 2008 09:33:53 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>> Can we make this patch indepedent of the flags changes and push it in ASAP.
>>
> Need much work....Hmm..rewrite all again ? 
> 

I don't think you'll need to do a major rewrite? Will you? My concern is that
this patch does too much to be a single patch. Consider someone trying to do a
git-bisect to identify a problem? It is hard to review as well and I think the
patch that just removes struct page member can go in faster.

It will be easier to test/debug as well, we'll know if the problem is because of
new page_cgroup being outside struct page rather then guessing if it was the
atomic ops that caused the problem.

-- 
	Balbir
