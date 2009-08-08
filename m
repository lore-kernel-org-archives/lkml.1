Return-Path: <linux-kernel-owner+w=401wt.eu-S1753256AbZHHXVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbZHHXVz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 19:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753133AbZHHXVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 19:21:55 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:48967 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753131AbZHHXVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 19:21:54 -0400
Date: Sat, 8 Aug 2009 16:21:53 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de
Subject: Re: [tip:core/rcu] rcu: Add second diagnostic check for a possible
	CPU-hotplug race
Message-ID: <20090808232153.GA6866@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090806012645.GA24800@linux.vnet.ibm.com> <tip-0d84abdae6740ee5290a7a523ee35916f65e16ec@git.kernel.org> <20090808150103.GA27573@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090808150103.GA27573@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 08, 2009 at 05:01:03PM +0200, Ingo Molnar wrote:
> 
> * tip-bot for Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > Commit-ID:  0d84abdae6740ee5290a7a523ee35916f65e16ec
> > Gitweb:     http://git.kernel.org/tip/0d84abdae6740ee5290a7a523ee35916f65e16ec
> > Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > AuthorDate: Wed, 5 Aug 2009 18:26:45 -0700
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Sat, 8 Aug 2009 16:51:08 +0200
> > 
> > rcu: Add second diagnostic check for a possible CPU-hotplug race
> 
> hm, got this build failure in -tip testing:
> 
> kernel/rcupdate.c: In function ‘rcu_cpu_notified’:
> kernel/rcupdate.c:251: error: implicit declaration of function ‘cpu_notified’
> 
> with the config below.

Gah...  I didn't take !CONFIG_HOTPLUG_CPU into account.  Fix below.

							Thanx, Paul

------------------------------------------------------------------------

Fix build breakage in diagnostic patch.

Move cpu_notified() declaration out from under #ifdef.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 cpu.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index d9b3c18..1b1c30c 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -45,13 +45,13 @@ extern int sched_create_sysfs_power_savings_entries(struct sysdev_class *cls);
 extern void unregister_cpu(struct cpu *cpu);
 #endif
 struct notifier_block;
+extern int cpu_notified(int (*fn)(struct notifier_block *, unsigned long, void *));
 
 #ifdef CONFIG_SMP
 /* Need to know about CPUs going up/down? */
 #ifdef CONFIG_HOTPLUG_CPU
 extern int register_cpu_notifier(struct notifier_block *nb);
 extern void unregister_cpu_notifier(struct notifier_block *nb);
-extern int cpu_notified(int (*fn)(struct notifier_block *, unsigned long, void *));
 extern int raw_notifier_chain_is_registered(struct raw_notifier_head *nh,
 		int (*fn)(struct notifier_block *, unsigned long, void *));
 #else
