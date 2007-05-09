Return-Path: <linux-kernel-owner+w=401wt.eu-S969400AbXEIDrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969400AbXEIDrr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 23:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967367AbXEIDrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 23:47:40 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:32342 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755591AbXEIDrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 23:47:39 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=n7IOXKgRsggN6EIhS3AGY/dKjGmCjMddfc4Co6vdI2GvZW7ZZmWf6hWSkfE9cMGPzferWLdf3jpIs5FiF/t5rv59Xsozm9yGwrG++xpnuNVpY5u2eEDeEpzM5fOpww08U60BMSnbjlZjkQsBJxxRwbQx/Ghl0IO51l2hPuBEKmI=  ;
X-YMail-OSG: CLvlgZIVM1mviXQumtNxlix4u3CpemWRdMmLouGgb47SAOID01k8e1mXgl5AM8xY1arUO.8tsQ--
Message-ID: <4641443C.7090007@yahoo.com.au>
Date: Wed, 09 May 2007 13:47:08 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
CC: Matt Mackall <mpm@selenic.com>, David Miller <davem@davemloft.net>,
       clameter@sgi.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: + fix-spellings-of-slab-allocator-section-in-init-kconfig.patch
 added to -mm tree
References: <Pine.LNX.4.64.0705081746500.16914@schroedinger.engr.sgi.com> <20070509012725.GZ11115@waste.org> <Pine.LNX.4.64.0705081828300.17376@schroedinger.engr.sgi.com> <20070508.185141.85412154.davem@davemloft.net> <46412BB5.1060605@yahoo.com.au> <20070509025634.GC11115@waste.org> <46413D6A.6000502@yahoo.com.au>
In-Reply-To: <46413D6A.6000502@yahoo.com.au>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:

> +static void kmem_rcu_free(struct rcu_head *head)
> +{
> +	struct slob_rcu *slob_rcu = (struct slob_rcu *)head;
> +	void *b = (void *)slob_rcu - slob_rcu->c->size;

No, I forgot that c->size includes the size of struct slob_rcu here.
Will send updated patch which is tested and includes SOB.

> +
> +	__kmem_cache_free(b, slob_rcu->c);
> +}

-- 
SUSE Labs, Novell Inc.
