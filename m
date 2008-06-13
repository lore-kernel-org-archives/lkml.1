Return-Path: <linux-kernel-owner+w=401wt.eu-S1758429AbYFMLC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758429AbYFMLC7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 07:02:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754282AbYFMLCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 07:02:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47886 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753914AbYFMLCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 07:02:51 -0400
Date: Fri, 13 Jun 2008 13:02:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [PATCH] cputopology: Always define CPU topology information
	[5th try]
Message-ID: <20080613110236.GA9867@elte.hu>
References: <20080604154454.GD11300@solarflare.com> <20080604214715.bbebe325.akpm@linux-foundation.org> <20080605120829.GI11300@solarflare.com> <20080605092831.a77d164d.akpm@linux-foundation.org> <20080605163714.GO11300@solarflare.com> <20080613051654.GC21586@elte.hu> <20080613101539.GV11300@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080613101539.GV11300@solarflare.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.3
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ben Hutchings <bhutchings@solarflare.com> wrote:

> > > This patch:
> > > 
> > > - Adds default definitions of the 4 topology macros to <linux/topology.h>
> > > - Changes drivers/base/topology.c to use the topology macros unconditionally
> > > - Updates documentation accordingly
> > 
> > applied to tip/core/topology - thanks Ben.
> 
> Unfortunately you lost the first paragraph of the commit message, then 
> created a second commit (difference between 4th and 5th versions) with 
> your own commit message and me as the author.  Maybe it's nitpicking 
> but I would prefer to have strictly accurate metadata in the commit 
> log.

that's OK, see the delta patch below, it's rather trivial. It's better 
to do these small delta patches where each change stands on its own than 
to review a more complex combo patch. (Suggest me any other commit 
metadata for this delta if you prefer, we can still change it.)

	Ingo

-------------->
commit 131b943ae643b1ad6febd67cdbb31d955706ecf4
Author: Ben Hutchings <bhutchings@solarflare.com>
Date:   Thu Jun 5 17:37:15 2008 +0100

    cputopology: always define CPU topology information, clean up
    
    simplify drivers/base/topology.c a bit.
    
    Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/drivers/base/topology.c b/drivers/base/topology.c
index 24d29a9..f0cb270 100644
--- a/drivers/base/topology.c
+++ b/drivers/base/topology.c
@@ -59,16 +59,14 @@ static ssize_t show_cpumap(int type, cpumask_t *mask, char *buf)
 static inline ssize_t show_##name(struct sys_device *dev, char *buf)	\
 {									\
 	unsigned int cpu = dev->id;					\
-	cpumask_t siblings = topology_##name(cpu);			\
-	return show_cpumap(0, &siblings, buf);				\
+	return show_cpumap(0, &(topology_##name(cpu)), buf);		\
 }
 
 #define define_siblings_show_list(name)					\
 static inline ssize_t show_##name##_list(struct sys_device *dev, char *buf) \
 {									\
 	unsigned int cpu = dev->id;					\
-	cpumask_t siblings = topology_##name(cpu);			\
-	return show_cpumap(1, &siblings, buf);				\
+	return show_cpumap(1, &(topology_##name(cpu)), buf);		\
 }
 
 #define define_siblings_show_func(name)		\
