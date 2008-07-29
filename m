Return-Path: <linux-kernel-owner+w=401wt.eu-S1754193AbYG2Bp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbYG2Bp7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 21:45:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbYG2Bpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 21:45:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60512 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751665AbYG2Bpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 21:45:50 -0400
Message-ID: <488E75E9.9080202@cn.fujitsu.com>
Date: Tue, 29 Jul 2008 09:44:09 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: akpm@linux-foundation.org, menage@google.com,
       seto.hidetoshi@jp.fujitsu.com, laijs@cn.fujitsu.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] cpuset: clean up cpuset hierarchy traversal code
References: <488D332A.1030008@cn.fujitsu.com>	<20080727233746.7f057e74.pj@sgi.com> <20080728001205.f3801aca.pj@sgi.com>
In-Reply-To: <20080728001205.f3801aca.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> pj wrote:
>> Can you figure out if we are holding any system wide lock, such as
>> cgroup_mutex, at this point?
> 
> Nevermind ... this is in rebuild_sched_domains(), which must be
> called with cgroup_mutex held.  So we danged well better be holding
> a system wide lock.
> 

Yes, and even after Max's patch, the code playing with ->stack_list is
still protected by cgroup_mutex. :)

