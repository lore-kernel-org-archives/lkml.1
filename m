Return-Path: <linux-kernel-owner+w=401wt.eu-S1754711AbZIAOyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbZIAOyl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 10:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754559AbZIAOyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 10:54:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754542AbZIAOyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 10:54:40 -0400
Message-ID: <4A9D3576.70801@redhat.com>
Date: Tue, 01 Sep 2009 10:53:42 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Ryo Tsuruta <ryov@valinux.co.jp>, nauman@google.com,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       containers@lists.linux-foundation.org, dm-devel@redhat.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       torvalds@linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH 18/23] io-controller: blkio_cgroup patches from Ryo to
 track async bios.
References: <4A9C09BE.4060404@redhat.com> <20090831185640.GF3758@redhat.com> <e98e18940908311651s26de5b70ye6f4a82402956309@mail.gmail.com> <20090901.160004.226800357.ryov@valinux.co.jp> <20090901141142.GA13709@redhat.com>
In-Reply-To: <20090901141142.GA13709@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Tue, Sep 01, 2009 at 04:00:04PM +0900, Ryo Tsuruta wrote:

>> I think that swap writeouts should be charged to the memory hogging
>> process, because the process consumes more resources and it should get
>> a penalty.
> 
> A process requesting memory gets IO penalty? 

There is no easy answer here.

On the one hand, you want to charge the process that uses
the resources.

On the other hand, if a lower resource use / higher priority
process tries to free up some of those resources, it should
not have its IO requests penalized (and get slowed down)
because of something the first process did...

-- 
All rights reversed.
