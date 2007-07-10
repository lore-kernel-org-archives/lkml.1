Return-Path: <linux-kernel-owner+w=401wt.eu-S1757561AbXGJMH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561AbXGJMH6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 08:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753119AbXGJMHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 08:07:51 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:53386 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471AbXGJMHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 08:07:50 -0400
Message-ID: <46937691.5030409@fr.ibm.com>
Date: Tue, 10 Jul 2007 14:07:45 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Pavel Emelianov <xemul@openvz.org>
CC: sukadev@us.ibm.com, Andrew Morton <akpm@osdl.org>,
       Serge Hallyn <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kirill Korotaev <dev@openvz.org>
Subject: Re: [PATCH 4/16] Change data structures for pid namespaces
References: <468DF6F7.1010906@openvz.org> <468DF7AC.10302@openvz.org> <469299C5.1060402@fr.ibm.com> <20070710043250.GD15214@us.ibm.com> <46932F69.8020101@openvz.org>
In-Reply-To: <46932F69.8020101@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> | > +
>> | >  struct pid
>> | >  {
>> | >  	atomic_t count;
>> | > @@ -40,6 +40,8 @@ enum pid_type
>> | >  	/* lists of tasks that use this pid */
>> | >  	struct hlist_head tasks[PIDTYPE_MAX];
>> | >  	struct rcu_head rcu;
>> | > +	int level;
>> | > +	struct pid_number numbers[1];
>> | >  };
>> | > 
>> | >  extern struct pid init_struct_pid;
>> | > diff -upr linux-2.6.22-rc4-mm2.orig/include/linux/pid_namespace.h linux-2.6.22-rc4-mm2-2/include/linux/pid_namespace.h
>> | > --- linux-2.6.22-rc4-mm2.orig/include/linux/pid_namespace.h	2007-06-14 12:14:29.000000000 +0400
>> | > +++ linux-2.6.22-rc4-mm2-2/include/linux/pid_namespace.h	2007-07-04 19:00:39.000000000 +0400
>> | > @@ -16,7 +15,10 @@ struct pidmap {
>> | >  	struct kref kref;
>> | >  	struct pidmap pidmap[PIDMAP_ENTRIES];
>> | >  	int last_pid;
>> | > +	int level;
>> | >  	struct task_struct *child_reaper;
>> | > +	struct kmem_cache *pid_cachep;
>> | 
>> | so, that looks like a good idea to have the cache in the pidmap. could you 
>> | push that independently to see how it all fits together ?
>>
>> Yes. I like this idea too.
> 
> OK. I will collect the patches you Acked and send them to Andrew independently.

good thanks, 

however that part on the *pid_cachep will require some rework on your patchset.

C.
