Return-Path: <linux-kernel-owner+w=401wt.eu-S1755573AbYIGPdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573AbYIGPdp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 11:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751640AbYIGPdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 11:33:36 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:48846 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751531AbYIGPdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 11:33:36 -0400
Message-ID: <48C3F444.4060908@linux.vnet.ibm.com>
Date: Sun, 07 Sep 2008 21:03:24 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>, Li Zefan <lizf@cn.fujitsu.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][mmotm]memcg: handle null dereference of mm->owner
References: <20080905165017.b2715fe4.nishimura@mxp.nes.nec.co.jp> <20080905174021.9fa29b01.kamezawa.hiroyu@jp.fujitsu.com> <6599ad830809050903s7e1a1004i6b31660502c0dcf2@mail.gmail.com>
In-Reply-To: <6599ad830809050903s7e1a1004i6b31660502c0dcf2@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Fri, Sep 5, 2008 at 1:40 AM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> BTW, I have a question to Balbir and Paul. (I'm sorry I missed the discussion.)
>> Recently I wonder why we need MM_OWNER.
>>
>> - What's bad with thread's cgroup ?
> 
> Because lots of mm operations take place in a context where we don't
> have a thread pointer, and hence no cgroup.
> 

Right, Thanks! Allocating memory is not that big a problem (we usually know the
context), while freeing memory, we can't assume that current is freeing it

-- 
	Balbir
