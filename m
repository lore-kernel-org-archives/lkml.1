Return-Path: <linux-kernel-owner+w=401wt.eu-S1758829AbZKEUEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829AbZKEUEN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 15:04:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758763AbZKEUEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 15:04:13 -0500
Received: from smtp4.ultrahosting.com ([74.213.175.253]:48649 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758514AbZKEUEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 15:04:13 -0500
Date: Thu, 5 Nov 2009 10:20:18 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       akpm@linux-foundation.org,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH] lib: generic percpu counter array
In-Reply-To: <20091105141653.132d4977.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.1.10.0911051017310.25718@V090114053VZO-1>
References: <20091104152426.eacc894f.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.1.10.0911041414560.7409@V090114053VZO-1> <20091105090659.9a5d17b1.kamezawa.hiroyu@jp.fujitsu.com> <20091105141653.132d4977.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Nov 2009, KAMEZAWA Hiroyuki wrote:

> Anothter major percpu coutner is vm_stat[]. This patch implements
> vm_stat[] style counter array in lib/percpu_counter.c
> This is designed for introducing vm_stat[] style counter to memcg,
> but maybe useful for other people. By using this, counter array
> using percpu can be implemented easily in compact structure.


Note that vm_stat support was written that way because we have extreme
space constraints due to the need to keep statistics per zone and per cpu
and avoid cache line pressure that would result through the use of big
integer arrays per zone and per cpu. For a large number of zones and cpus
this is desastrous.

If you only need to keep statistics per cpu for an entity then the vmstat
approach is overkill. A per cpu allocation of a counter is enough.

