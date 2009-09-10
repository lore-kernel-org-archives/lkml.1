Return-Path: <linux-kernel-owner+w=401wt.eu-S1752521AbZIJSFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbZIJSFW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 14:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbZIJSFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 14:05:21 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:38715 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751150AbZIJSFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 14:05:21 -0400
Date: Thu, 10 Sep 2009 14:03:55 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, linux-mm <linux-mm@kvack.org>,
       Oleg Nesterov <onestero@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] lru_add_drain_all() vs isolation
In-Reply-To: <20090910083340.9CB7.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.1.10.0909101402340.13682@V090114053VZO-1>
References: <20090909131945.0CF5.A69D9226@jp.fujitsu.com> <alpine.DEB.1.10.0909091005010.28070@V090114053VZO-1> <20090910083340.9CB7.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Sep 2009, KOSAKI Motohiro wrote:

> How about this?
>   - pass 1-2,  lru_add_drain_all_async()
>   - pass 3-10, lru_add_drain_all()
>
> this scheme might save RT-thread case and never cause regression. (I think)

Sounds good.

> The last remain problem is, if RT-thread binding cpu's pagevec has migrate
> targetted page, migration still face the same issue.
> but we can't solve it...
> RT-thread must use /proc/sys/vm/drop_caches properly.

A system call "sys_os_quiet_down" may be useful. It would drain all
caches, fold counters etc etc so that there will be no OS activities
needed for those things later.

