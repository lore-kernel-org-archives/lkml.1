Return-Path: <linux-kernel-owner+w=401wt.eu-S1752943AbZH3AjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943AbZH3AjI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 20:39:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752899AbZH3AjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 20:39:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752897AbZH3AjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 20:39:07 -0400
Message-ID: <4A99C9FC.2010004@redhat.com>
Date: Sat, 29 Aug 2009 20:38:20 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       containers@lists.linux-foundation.org, dm-devel@redhat.com,
       nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       torvalds@linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH 11/23] io-controller: Introduce group idling
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com> <1251495072-7780-12-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1251495072-7780-12-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> o It is not always that IO from a process or group is continuous. There are
>   cases of dependent reads where next read is not issued till previous read
>   has finished. For such cases, CFQ introduced the notion of slice_idle,
>   where we idle on the queue for sometime hoping next request will come
>   and that's how fairness is provided otherwise queue will be deleted
>   immediately from the service tree and this process will not get the
>   fair share.
> 
> o This patch introduces the similar concept at group level. Idle on the group
>   for a period of "group_idle" which is tunable through sysfs interface. So
>   if a group is empty and about to be deleted, we idle for the next request.
> 
> o This patch also introduces the notion of wait busy where we wait for one
>   extra group_idle period even if queue has consumed its time slice. The
>   reason being that group will loose its share upon removal from service
>   tree as some other entity will be picked for dispatch and vtime jump will
>   take place.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
