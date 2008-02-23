Return-Path: <linux-kernel-owner+w=401wt.eu-S934961AbYBWAyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934961AbYBWAyT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 19:54:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763809AbYBWAnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 19:43:45 -0500
Received: from wr-out-0506.google.com ([64.233.184.227]:42059 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936920AbYBWAnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 19:43:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Z8hUhEazIkT35FjvfbeL18z8mxSrkrBFw/XmRISygmTtYrUiOx7bIsdERSsLTkxiC9HYun0/ZDBb4lWzRByIA+GvZmkQzpkA3JRktJGL0qS+yND5WJTvTaYzBSaNnDlJHm764/tYoMk3QiprwfS8wekrDpzu+hh5p+IKkLJXPjM=
Message-ID: <9810cff90802221643g7d993af4k33f29fb4a4663407@mail.gmail.com>
Date: Fri, 22 Feb 2008 16:43:40 -0800
From: "Bill Huey (hui)" <bill.huey@gmail.com>
To: gregory.haskins@gmail.com
Subject: Re: [PATCH [RT] 11/14] optimize the !printk fastpath through the lock acquisition
Cc: "Pavel Machek" <pavel@ucw.cz>, "Gregory Haskins" <ghaskins@novell.com>,
       mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       rostedt@goodmis.org, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org, kevin@hilman.org, cminyard@mvista.com,
       dsingleton@mvista.com, dwalker@mvista.com, npiggin@suse.de,
       dsaxena@plexity.net, ak@suse.de, gregkh@suse.de, sdietrich@novell.com,
       pmorreale@novell.com, mkohari@novell.com
In-Reply-To: <47BF4AC5.7070507@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080221152504.4804.8724.stgit@novell1.haskins.net>
	 <20080221152722.4804.77478.stgit@novell1.haskins.net>
	 <20080222191837.GE6060@ucw.cz> <47BF4AC5.7070507@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2008 at 2:20 PM, Gregory Haskins
<gregory.haskins.ml@gmail.com> wrote:
>  Agreed, but it's still correct afaict.  I added an extra might_sleep()
>  to a path that really might sleep.  I should have mentioned that in the
>  header.
>
>  In any case, its moot.  Andi indicated this patch is probably a no-op so
>  I was considering dropping it on the v2 pass.

The might_sleep is annotation and well as a conditional preemption
point for the regular kernel. You might want to do a schedule check
there, but it's the wrong function if memory serves me correctly. It's
reserved for things that actually are design to sleep. The rt_spin*()
function are really a method of preserving BKL semantics across real
schedule() calls. You'd have to use something else instead for that
purpose like cond_reschedule() instead.

bill
