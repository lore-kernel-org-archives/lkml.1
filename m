Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489Ab0BWNAB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 08:00:01 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:64357 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373Ab0BWM77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 07:59:59 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH tip/core/rcu 0/21] v6 add lockdep-based diagnostics to rcu_dereference()
Date: Tue, 23 Feb 2010 13:59:07 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com
References: <20100223010435.GA666@linux.vnet.ibm.com>
In-Reply-To: <20100223010435.GA666@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002231359.07910.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/p6GCPhuHcRBFRbMEzTVo7OYVxADFnwR11he9
 vbs/5E4oBEWYLmhIEYrXMqHtSM5wywKDGUgLzS4Lb55B6cooq3
 mtZTXRFXpEKKq6ffE1k2g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 February 2010, Paul E. McKenney wrote:
> This patch series adds lockdep-based checking to the rcu_dereference()
> primitive in order to flag misuses of RCU.

While I haven't looked much at this series, I've been thinking about
adding static diagnostics for rcu_dereference misuse, in the form of
an __rcu address space qualifier for pointers. Such a patch would
obviously conflict with this series, so I'd wait for yours to go
in first, but maybe you like the idea enough to do it yourself ;-).

The observation is that all accesses to an RCU protected pointer
are either through rcu_dereference, rcu_assign_pointer or one of their
variants. so it should be possible to add a new address space like we
have for __iomem, __user and soon __percpu and have sparse check that
we use RCU consistently on pointers that need it.

	Arnd
