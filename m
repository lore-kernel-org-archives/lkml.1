Return-Path: <linux-kernel-owner+w=401wt.eu-S1759065AbXJDI4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759065AbXJDI4P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 04:56:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754254AbXJDI4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 04:56:00 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:28987 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939AbXJDIz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 04:55:59 -0400
Date: Thu, 4 Oct 2007 10:54:51 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, maneesh@linux.vnet.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>
Subject: Re: [RFC/PATCH -v2] Add sysfs control to modify a user's cpu share
Message-ID: <20071004085451.GA8108@osiris.boeblingen.de.ibm.com>
References: <1190725693.13716.10.camel@Homer.simpson.net> <20070925132528.GN26289@linux.vnet.ibm.com> <1190726682.11260.1.camel@Homer.simpson.net> <20070925140559.GB26310@linux.vnet.ibm.com> <20070925143755.GA15594@elte.hu> <20070926210737.GA8663@elte.hu> <20071001140454.GA19439@linux.vnet.ibm.com> <20071001144402.GA3505@elte.hu> <20071003171029.GA5423@linux.vnet.ibm.com> <20071004075750.GD9176@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071004075750.GD9176@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Changelog since v1:
> > 1. Added a mutex to serialize directory creation/destruction for a user in
> >    sysfs
> > 2. Added a spinlock in the task_group structure to serialize writes to
> >    tg->shares.
> > 3. Removed /proc/root_user_cpu_shares.
> > 4. Added Documentation about the group scheduler.
> 
> thanks - I have added this to the queue.
> 
> i'm wondering about the following: could not (yet) existing UIDs be made 
> configurable too? I.e. if i do this in a bootup script:
> 
>   echo 2048 > /sys/kernel/uids/500/cpu_share
> 
> this should just work too, regardless of there not being any UID 500 
> tasks yet. Likewise, once configured, the /sys/kernel/uids/* directories 
> (with the settings in them) should probably not go away either.

Shouldn't that be done via uevents? E.g. UID x gets added to the sysfs tree,
generates a uevent and a script then figures out the cpu_share and sets it.
That way you also don't need to keep the directories. No?
