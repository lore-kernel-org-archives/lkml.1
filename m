Return-Path: <linux-kernel-owner+w=401wt.eu-S1754241AbZLOGZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241AbZLOGZ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 01:25:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbZLOGZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 01:25:58 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:58114 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbZLOGZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 01:25:57 -0500
Message-ID: <4B272BAC.3080502@gmail.com>
Date: Tue, 15 Dec 2009 07:24:44 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       Pekka Enberg <penberg@cs.helsinki.fi>, Mel Gorman <mel@csn.ul.ie>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [this_cpu_xx V7 6/8] Make slub statistics use this_cpu_inc
References: <20091214220320.665065925@quilx.com> <20091214220341.901590053@quilx.com>
In-Reply-To: <20091214220341.901590053@quilx.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 15 Dec 2009 07:24:45 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 14/12/2009 23:03, Christoph Lameter a écrit :
> this_cpu_inc() translates into a single instruction on x86 and does not
> need any register. So use it in stat(). We also want to avoid the
> calculation of the per cpu kmem_cache_cpu structure pointer. So pass
> a kmem_cache pointer instead of a kmem_cache_cpu pointer.
> 

Hmm, last time I checked, [__]this_cpu_inc were not using "inc" on x86,
but the default [__]this_cpu_add((pcp), 1)

