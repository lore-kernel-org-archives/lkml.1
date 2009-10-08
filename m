Return-Path: <linux-kernel-owner+w=401wt.eu-S1757979AbZJHMkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979AbZJHMkk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 08:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757687AbZJHMkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 08:40:39 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:35654 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757595AbZJHMkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 08:40:39 -0400
Subject: Re: [2.6.32-rc3 kmemleak] WARNING: at kernel/lockdep.c:3161
	check_flags+0xbe/0x180()
From: Catalin Marinas <catalin.marinas@arm.com>
To: paulmck@linux.vnet.ibm.com
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20091007155142.GB6743@linux.vnet.ibm.com>
References: <200910050315.n953FCD9030264@www262.sakura.ne.jp>
	 <20091007155142.GB6743@linux.vnet.ibm.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Thu, 08 Oct 2009 13:39:56 +0100
Message-Id: <1255005596.6715.2.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Oct 2009 12:39:57.0286 (UTC) FILETIME=[716AF060:01CA4814]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-07 at 08:51 -0700, Paul E. McKenney wrote:
> On Mon, Oct 05, 2009 at 12:15:12PM +0900, Tetsuo Handa wrote:
> > --- linux-2.6.32-rc3.orig/mm/kmemleak.c
> > +++ linux-2.6.32-rc3/mm/kmemleak.c
> > @@ -833,7 +833,7 @@ static void early_alloc(struct early_log
> >  	 */
> >  	rcu_read_lock();
> >  	object = create_object((unsigned long)log->ptr, log->size,
> > -			       log->min_count, GFP_KERNEL);
> > +			       log->min_count, GFP_ATOMIC);
> 
> Won't we need to check for object==NULL?

Yes, we need. Thanks.

-- 
Catalin

