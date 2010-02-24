Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095Ab0BXUii (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 15:38:38 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:64483 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757984Ab0BXUig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 15:38:36 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 07/10] module: __rcu annotations
Date: Wed, 24 Feb 2010 21:26:09 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: paulmck@linux.vnet.ibm.com,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com
References: <20100223180127.GF6700@linux.vnet.ibm.com> <1267041846-10469-8-git-send-email-arnd@arndb.de> <20100224201354.GA3399@core2>
In-Reply-To: <20100224201354.GA3399@core2>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002242126.09994.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/hJhuUZ1uBARGbuvg0pIJnUAXuoHPZ6vBBSL/
 yVwPuN1kgCPgx90bQKyFlrP0wzrtsudt16CNWedIzKTcKTnkZ2
 v8trJNooYXB3GF7WETAmA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 February 2010, Alexey Dobriyan wrote:
> On Wed, Feb 24, 2010 at 09:04:03PM +0100, Arnd Bergmann wrote:
> > @@ -360,10 +360,12 @@ struct module *find_module(const char *name)
> >  {
> >       struct module *mod;
> >  
> > -     list_for_each_entry(mod, &modules, list) {
> > +     rcu_read_lock();
> > +     list_for_each_entry_rcu(mod, &modules, list) {
> >               if (strcmp(mod->name, name) == 0)
> >                       return mod;
> >       }
> > +     rcu_read_unlock();
> >       return NULL;
> >  }
> >  EXPORT_SYMBOL_GPL(find_module);
> 
> modules list is under module_mutex, nothing should be done here.

Ok, this is a significant limitation of the list rcu annotation
then, it's not possible to pass the same list into list_for_each_entry
and list_for_each_entry_rcu with the way I changed the rcu list
definition. I would be possible to do a __list_for_each_entry_rcu
macro that takes an rcu_list_head but does not actually use
rcu_dereference, but I'm not sure if that's good enough.

	Arnd

