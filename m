Return-Path: <linux-kernel-owner+w=401wt.eu-S1755841AbZLUKuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841AbZLUKuR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 05:50:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754748AbZLUKuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 05:50:16 -0500
Received: from one.firstfloor.org ([213.235.205.2]:59034 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754616AbZLUKuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 05:50:15 -0500
Date: Mon, 21 Dec 2009 11:50:10 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: andi@firstfloor.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
       paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] [0/11] SYSCTL: Use RCU to avoid races with string
	sysctls
Message-ID: <20091221105010.GC25372@basil.fritz.box>
References: <b6fcc0a0912202357g269722f2ra2cb136396e8186e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6fcc0a0912202357g269722f2ra2cb136396e8186e@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 21, 2009 at 09:57:32AM +0200, Alexey Dobriyan wrote:
> > new = alloc_rcu_string(MAX_GLOBAL_SIZE, GFP_KERNEL);
> 
> I think adding failure mode is not right.
> We can get away with per-sysctl-string spinlock and not introduce yet
> another API.

You mean when running out of memory here?

When this runs out of memory the system will be not usable anyways
and on the last legs and likely in a deadly swap storm. 

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
