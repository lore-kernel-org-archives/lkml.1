Return-Path: <linux-kernel-owner+w=401wt.eu-S1753751AbYIPKkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751AbYIPKkg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 06:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbYIPKkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 06:40:25 -0400
Received: from smarthost01.mail.zen.net.uk ([212.23.3.140]:60260 "EHLO
	smarthost01.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751745AbYIPKkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 06:40:24 -0400
Subject: Re: LRO num of frags limit
From: Ben Hutchings <bhutchings@solarflare.com>
To: Eli Cohen <eli@dev.mellanox.co.il>
Cc: netdev@vger.kernel.org, themann@de.ibm.com, linux-kernel@vger.kernel.org
In-Reply-To: <20080916073632.GA25226@mtls03>
References: <20080916073632.GA25226@mtls03>
Content-Type: text/plain
Organization: Solarflare Communications
Date: Tue, 16 Sep 2008 11:40:17 +0100
Message-Id: <1221561617.3244.78.camel@achroite>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-Originating-Smarthost01-IP: [82.69.137.158]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-16 at 10:36 +0300, Eli Cohen wrote:
> Hi,
> 
> looking at the LRO code, at __lro_proc_segment(), it seems that the
> network driver can configure lro_mgr->max_aggr to any value it wants
> while the number of fragments aggregated must not exceed MAX_SKB_FRAGS

Correct.

> (since we only use a single SKB to aggregate fragments, allocated by
> lro_gen_skb()). Moreover, even if the driver does limit
> lro_mgr->max_aggr to MAX_SKB_FRAGS, it might still cause overflow
> since subsequent aggregations are done at lro_add_frags() which is
> called before checking whether we overflow.

So you must set max_aggr to
MAX_SKB_FRAGS - max number of frags added at once + 1.

> If the above observation is correct, I can send a patch.

I would be interested to see that, anyway.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

