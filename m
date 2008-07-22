Return-Path: <linux-kernel-owner+w=401wt.eu-S1755585AbYGVIlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585AbYGVIlc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 04:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753554AbYGVIlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 04:41:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54722 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753341AbYGVIlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 04:41:17 -0400
Date: Tue, 22 Jul 2008 01:40:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "xemul@openvz.org" <xemul@openvz.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2][-mm][resend] res_counter limit change support ebusy
Message-Id: <20080722014043.92272350.akpm@linux-foundation.org>
In-Reply-To: <20080714171154.e1cc9943.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080714171154.e1cc9943.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2008 17:11:54 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> +static inline int res_counter_set_limit(struct res_counter *cnt,
> +	unsigned long long limit)
> +{
> +	unsigned long flags;
> +	int ret = -EBUSY;
> +
> +	spin_lock_irqsave(&cnt->lock, flags);
> +	if (cnt->usage < limit) {
> +		cnt->limit = limit;
> +		ret = 0;
> +	}
> +	spin_unlock_irqrestore(&cnt->lock, flags);
> +	return ret;
> +}

Need I say it?  This function is waaaaaay too large to be inlined.
