Return-Path: <linux-kernel-owner+w=401wt.eu-S1161510AbXBHHuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161510AbXBHHuK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 02:50:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161451AbXBHHuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 02:50:10 -0500
Received: from ns2.suse.de ([195.135.220.15]:49370 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161510AbXBHHuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 02:50:09 -0500
From: Andi Kleen <ak@suse.de>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [BUG][PATCH] fix mempolcy's check on a system with memory-less-node take2
Date: Thu, 8 Feb 2007 08:49:41 +0100
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>, clameter@sgi.com,
       Andrew Morton <akpm@osdl.org>, GOTO <y-goto@jp.fujitsu.com>
References: <20070208110606.ebf668d3.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070208110606.ebf668d3.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702080849.42167.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> This panic(hang) was found by a numa test-set on a system with 3 nodes, where
> node(2) was memory-less-node.

I still think it's the wrong fix -- just get rid of the memory less node.
I expect you'll likely run into more problems with that setup anyways.

>  static struct mempolicy *mpol_new(int mode, nodemask_t *nodes)
>  {
>  	struct mempolicy *policy;
> +	void  *val;

Using void * here is nasty when it's a zonelist pointer.

-Andi
