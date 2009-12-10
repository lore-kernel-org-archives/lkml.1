Return-Path: <linux-kernel-owner+w=401wt.eu-S1755674AbZLJBC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674AbZLJBC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 20:02:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752987AbZLJBCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 20:02:23 -0500
Received: from tundra.namei.org ([65.99.196.166]:57766 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889AbZLJBCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 20:02:23 -0500
Date: Thu, 10 Dec 2009 12:02:15 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: LKML <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] capabilities: Use RCU to protect task lookup in
 sys_capget
In-Reply-To: <alpine.LFD.2.00.0912091710420.3089@localhost.localdomain>
Message-ID: <alpine.LRH.2.00.0912101201590.19518@tundra.namei.org>
References: <alpine.LFD.2.00.0912091710420.3089@localhost.localdomain>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Dec 2009, Thomas Gleixner wrote:

> cap_get_target_pid() protects the task lookup with tasklist_lock.
> security_capget() is called under tasklist_lock as well but
> tasklist_lock does not protect anything there. The capabilities are
> protected by RCU already.
> 
> So tasklist_lock only protects the lookup and prevents the task going
> away, which can be done with rcu_read_lock() as well.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>


Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next


-- 
James Morris
<jmorris@namei.org>
