Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab0CFSRq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 13:17:46 -0500
Received: from bob75-7-88-160-5-175.fbx.proxad.net ([88.160.5.175]:55536 "EHLO
	cerbere.dyndns.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970Ab0CFSRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 13:17:44 -0500
From: Samir Bellabes <sam@synack.fr>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       netfilter-devel@vger.kernel.org, hadi@cyberus.ca, kaber@trash.net,
       zbr@ioremap.net, nhorman@tuxdriver.com, root@localdomain.pl,
       linux-security-module@vger.kernel.org
Subject: Re: [RFC v2 00/10] snet: Security for NETwork syscalls
References: <1267561394-13626-1-git-send-email-sam@synack.fr>
	<201003030156.o231udx1023055@www262.sakura.ne.jp>
Date: Sat, 06 Mar 2010 19:17:42 +0100
In-Reply-To: <201003030156.o231udx1023055@www262.sakura.ne.jp> (Tetsuo Handa's
	message of "Wed, 03 Mar 2010 10:56:39 +0900")
Message-ID: <m2aaulqpq1.fsf@ssh.synack.fr>
User-Agent: Gnus/5.110003 (No Gnus v0.3) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> writes:

> Regarding [RFC v2 05/10] snet: introduce snet_event
> +static rwlock_t snet_evh_lock = __RW_LOCK_UNLOCKED();
>
> You can use "static DEFINE_RWLOCK(snet_evh_lock);".
>
> +int snet_event_is_registered(const enum snet_syscall syscall, const u8 protocol)
>
> Maybe rcu_read_lock() is better than rw spinlock because this function is
> frequently called.

here is the patch.
thank you Tetsuo

>From 34715d4d900aee2d3759e3008313b65dc2f130fd Mon Sep 17 00:00:00 2001
From: Samir Bellabes <sam@synack.fr>
Date: Sat, 6 Mar 2010 15:44:42 +0100
Subject: [PATCH 1/3] snet: use proper rwlock_t declaration

Noticed by Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

Signed-off-by: Samir Bellabes <sam@synack.fr>
---
 security/snet/snet_event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/security/snet/snet_event.c b/security/snet/snet_event.c
index 9e3f7d2..5f708d0 100644
--- a/security/snet/snet_event.c
+++ b/security/snet/snet_event.c
@@ -9,7 +9,7 @@
 #include "snet_utils.h"
 
 static struct list_head *snet_evh;
-static rwlock_t snet_evh_lock = __RW_LOCK_UNLOCKED();
+static DEFINE_RWLOCK(snet_evh_lock);
 
 struct snet_event_entry {
 	struct list_head list;
-- 
1.6.3.3

