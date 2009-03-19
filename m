Return-Path: <linux-kernel-owner+w=401wt.eu-S1757456AbZCSAeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757456AbZCSAeO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 20:34:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754855AbZCSAdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 20:33:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57329 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754419AbZCSAds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 20:33:48 -0400
Subject: Re: [PATCH] ftrace: protect running nmi (V3)
From: Steven Rostedt <srostedt@redhat.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <49C0B411.30003@cn.fujitsu.com>
References: <49BE4BF7.6050407@cn.fujitsu.com>
	 <1237225372.3624.15.camel@localhost.localdomain>
	 <49BF9D8A.4070200@cn.fujitsu.com>  <49C0B411.30003@cn.fujitsu.com>
Content-Type: text/plain
Organization: Red Hat
Date: Wed, 18 Mar 2009 20:33:28 -0400
Message-Id: <1237422809.3624.39.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2009-03-18 at 16:42 +0800, Lai Jiangshan wrote:

>  
> +static void wait_for_nmi_and_set_mod_flag(void)
> +{
> +	if (!atomic_cmpxchg(&nmi_running, 0, MOD_CODE_WRITE_FLAG))
> +		rerurn;

You might want to compile check patches before sending. I'll look this
patch over in detail, and make the necessary fixes.

-- Steve

> +
> +	do {
> +		cpu_relax();
> +	} while (atomic_cmpxchg(&nmi_running, 0, MOD_CODE_WRITE_FLAG));
> +
> +	nmi_wait_count++;
> +}
> +

