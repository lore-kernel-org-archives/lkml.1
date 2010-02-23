Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961Ab0BWI0L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 03:26:11 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55834 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751380Ab0BWI0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 03:26:09 -0500
Message-ID: <4B839103.2060901@cn.fujitsu.com>
Date: Tue, 23 Feb 2010 16:25:39 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: Re: [regression] cpuset,mm: update tasks' mems_allowed in time (58568d2)
References: <20100218134921.GF9738@laptop> <alpine.DEB.2.00.1002181302430.13707@chino.kir.corp.google.com> <20100219033126.GI9738@laptop> <alpine.DEB.2.00.1002190143040.6293@chino.kir.corp.google.com> <20100222121222.GV9738@laptop> <alpine.DEB.2.00.1002221400060.23881@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1002221400060.23881@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 2010-2-23 6:00, David Rientjes wrote:
> On Mon, 22 Feb 2010, Nick Piggin wrote:
> 
>> If you have a concurrent reader without any synchronisation, then what
>> stops it from loading a word of the mask before stores to add the new
>> nodes and then loading another word of the mask after the stores to
>> remove the old nodes? (which can give an empty mask).
>>
> 
> Currently nothing, so we'll need a variant for configurations where the 
> size of nodemask_t is larger than we can atomically store.
> 

Sorry, Could you explain what you advised?
I think it is hard to fix this problem by adding a variant, because it is
hard to avoid loading a word of the mask before

	nodes_or(tsk->mems_allowed, tsk->mems_allowed, *newmems);

and then loading another word of the mask after

	tsk->mems_allowed = *newmems;

unless we use lock.

Maybe we need a rw-lock to protect task->mems_allowed.

