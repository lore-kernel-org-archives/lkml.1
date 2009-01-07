Return-Path: <linux-kernel-owner+w=401wt.eu-S1757264AbZAGGgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264AbZAGGgm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 01:36:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbZAGGg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 01:36:29 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:51641 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbZAGGg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 01:36:28 -0500
Message-Id: <200901070636.n076aFY0061512@www262.sakura.ne.jp>
Subject: Re: [TOMOYO #14 (mmotm 2008-12-30-16-05) 02/10] Singly linked list implementation.
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: jmorris@namei.org
Cc: akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Wed, 07 Jan 2009 15:36:15 +0900
References: <20090101050741.372438529@I-love.SAKURA.ne.jp> <20090101050939.802554261@I-love.SAKURA.ne.jp> <alpine.LRH.1.10.0901051926130.16049@tundra.namei.org> <200901060813.n068DI3Y023188@www262.sakura.ne.jp> <alpine.LRH.1.10.0901062008480.25091@tundra.namei.org>
In-Reply-To: <alpine.LRH.1.10.0901062008480.25091@tundra.namei.org>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 07012009 #1412118, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris wrote:
> > Not all structures listed below are used as singly linked list,
> > but many of them are used as singly linked list.
> 
> Can any of these be converted to your singly linked list implementation ?

Maybe, but will be few.

Regular singly linked list (which is known as "slist") implementation has
below characteristics.

 (1) Supports "add", "read" and "remove" operations.
 (2) Caller holds read lock when reading, and holds write lock when adding or
     removing.
 (3) Iteration method (for_each_*) needn't to call rcu_dereference() because
     caller holds locks as needed.

TOMOYO's singly linked list (which is named as "list1") implementation has
below characteristics.

 (1) Supports "add" and "read" operations.
 (2) Caller holds a lock when adding, but doesn't hold a lock when reading.
 (3) Iteration method (for_each_*) needs to call rcu_dereference() because
     caller doesn't hold a lock when reading.

I think it is not a good thing to rename "list1" to "slist".

Many of these in-tree singly linked list users need to use regular singly
linked list because they need to remove elements from their lists.
