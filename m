Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758074Ab0BXUid (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 15:38:33 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:63669 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758051Ab0BXUib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 15:38:31 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH 01/10] rcu: define __rcu address space modifier for sparse
Date: Wed, 24 Feb 2010 21:22:38 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
References: <20100223180127.GF6700@linux.vnet.ibm.com> <1267041846-10469-2-git-send-email-arnd@arndb.de> <20100224201229.GA21067@Krystal>
In-Reply-To: <20100224201229.GA21067@Krystal>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002242122.39257.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/eJEhlju8olscsqI+Skcnm6qDRYZgnTSy5yDw
 TThEEssBW6H0stGdwRXcSiSbIWqq4wHfd759WuiwmTgDFOiC+7
 s+8IADh7cZp4gEyGivVqw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 February 2010, Mathieu Desnoyers wrote:
> > +/**
> > + * RCU_INIT_POINTER - initialize an RCU protected member
> > + * in a statically allocated data structure.
> > + */
> > +#define RCU_INIT_POINTER(p, v) \
> > +             p = (typeof(*v) __force __rcu *)(v)
> 
> Hrm, I'm not sure about this one. It would be better to something closer to
> list.h LIST_HEAD_INIT / LIST_HEAD / INIT_LIST_HEAD.  The first two are for
> static declaration/init, while the last one is for runtime init. I fear that
> your RCU_INIT_POINTER might be semantically confusing between static and dynamic
> initialization usual semantic.

I only had to use it in one place, INIT_STRUCT_PID (see patch 08/10), and
the approach of LIST_HEAD does not seem to work there. I'd certainly
prefer to write it in a way that cannot be used for dynamic initialization,
but could not think of one.

	Arnd

