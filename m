Return-Path: <linux-kernel-owner+w=401wt.eu-S1757461AbXJDH6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461AbXJDH6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 03:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753265AbXJDH6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 03:58:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35841 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752164AbXJDH6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 03:58:08 -0400
Date: Thu, 4 Oct 2007 09:57:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, maneesh@linux.vnet.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>
Subject: Re: [RFC/PATCH -v2] Add sysfs control to modify a user's cpu share
Message-ID: <20071004075750.GD9176@elte.hu>
References: <20070925131717.GM26289@linux.vnet.ibm.com> <1190725693.13716.10.camel@Homer.simpson.net> <20070925132528.GN26289@linux.vnet.ibm.com> <1190726682.11260.1.camel@Homer.simpson.net> <20070925140559.GB26310@linux.vnet.ibm.com> <20070925143755.GA15594@elte.hu> <20070926210737.GA8663@elte.hu> <20071001140454.GA19439@linux.vnet.ibm.com> <20071001144402.GA3505@elte.hu> <20071003171029.GA5423@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071003171029.GA5423@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:

> Hi Ingo,
> 
> Can you please drop commit b1add858a10cece3a68b2d8cb9e7350843700a58 (last
> version of this patch) and try this instead?

> Changelog since v1:
> 1. Added a mutex to serialize directory creation/destruction for a user in
>    sysfs
> 2. Added a spinlock in the task_group structure to serialize writes to
>    tg->shares.
> 3. Removed /proc/root_user_cpu_shares.
> 4. Added Documentation about the group scheduler.

thanks - I have added this to the queue.

i'm wondering about the following: could not (yet) existing UIDs be made 
configurable too? I.e. if i do this in a bootup script:

  echo 2048 > /sys/kernel/uids/500/cpu_share

this should just work too, regardless of there not being any UID 500 
tasks yet. Likewise, once configured, the /sys/kernel/uids/* directories 
(with the settings in them) should probably not go away either.

	Ingo
