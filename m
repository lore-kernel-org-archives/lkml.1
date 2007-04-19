Return-Path: <linux-kernel-owner+w=401wt.eu-S1766903AbXDSRuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766903AbXDSRuo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 13:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766910AbXDSRuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 13:50:44 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:53392 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766903AbXDSRuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 13:50:44 -0400
To: a.p.zijlstra@chello.nl
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, a.p.zijlstra@chello.nl,
       nikita@clusterfs.com, trond.myklebust@fys.uio.no,
       yingchao.zhou@gmail.com
In-reply-to: <20070417071703.959920360@chello.nl> (message from Peter Zijlstra
	on Tue, 17 Apr 2007 09:10:57 +0200)
Subject: Re: [PATCH 11/12] mm: per device dirty threshold
References: <20070417071046.318415445@chello.nl> <20070417071703.959920360@chello.nl>
Message-Id: <E1Heakt-0006jg-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 19 Apr 2007 19:49:15 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +static inline unsigned long bdi_stat_delta(void)
> +{
> +#ifdef CONFIG_SMP
> +	return NR_CPUS * FBC_BATCH;

Shouln't this be multiplied by the number of counters to sum?  I.e. 3
if dirty and unstable are separate, and 2 if they are not.

Miklos
