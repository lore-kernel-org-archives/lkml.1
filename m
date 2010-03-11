Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758597Ab0CKWay (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 17:30:54 -0500
Received: from one.firstfloor.org ([213.235.205.2]:38977 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279Ab0CKWax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 17:30:53 -0500
Date: Thu, 11 Mar 2010 23:30:48 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Mel Gorman <mel@csn.ul.ie>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: mmotm 2010-03-09-19-15: Lot of scheduling while atomic warnings related to RCU
Message-ID: <20100311223048.GI20695@one.firstfloor.org>
References: <201003100342.o2A3gKvA022440@imap1.linux-foundation.org> <20100310195745.GP4883@csn.ul.ie> <20100310203242.GC3770@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100310203242.GC3770@hmsreliant.think-freely.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> a/lib/kobject_uevent.c~sysctl-fix-up-remaining-references-to-uevent_helper-fix
> +++ a/lib/kobject_uevent.c
> @@ -273,10 +273,11 @@ int kobject_uevent_env(struct kobject *k
>  #endif
> 
>         /* call uevent_helper, usually only enabled during early boot */
> +       rcu_read_lock();
>         helper = rcu_dereference(uevent_helper);
>         if (helper[0])
>                 retval = uevent_call_helper(subsystem, env);
> -
> +       rcu_read_unlock();
>  exit:

The data actually has to be copied, there's a helper for this in rcustring.
I'll try to send a patch later.

> loads/unloads while changing uevent_helper.  Anywho, should be easy to fix,
> Mel, can you modify the code to copy helper to a private variable, then unlock
> the rcu read side prior to calling uevent_call_helper?  I imagine that would be

Yes, except rcustring already has a helper for that :)

-Andi
