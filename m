Return-Path: <linux-kernel-owner+w=401wt.eu-S1767178AbXEBSsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767178AbXEBSsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 14:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767200AbXEBSsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 14:48:19 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45789 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767196AbXEBSsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 14:48:18 -0400
Date: Wed, 2 May 2007 11:47:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: dipankar@in.ibm.com
Cc: David Howells <dhowells@redhat.com>, rusty@rustcorp.com.au,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Race between RCU and rmmod
Message-Id: <20070502114751.db7ab5d1.akpm@linux-foundation.org>
In-Reply-To: <20070502120051.GA13349@in.ibm.com>
References: <30958.1178106624@redhat.com>
	<20070502120051.GA13349@in.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2007 17:30:51 +0530
Dipankar Sarma <dipankar@in.ibm.com> wrote:

> On Wed, May 02, 2007 at 12:50:24PM +0100, David Howells wrote:
> > 
> > Hi Dipankar, Rusty,
> > 
> > I seem to have found a race between RCU and rmmod.  What I see appears to be
> > an RCU destructor function that has a call pending but lives in a module, gets
> > deleted before the RCU callback is processed:
> > 
> > RIP: 0010:[<ffffffff880329b7>]  [<ffffffff880329b7>]
> > 
> > I think that rmmod needs to clear the RCU destructor queue, probably inside of
> > __try_stop_module().
> 
> This is why we have rcu_barrier() although the corresponding documentation
> patch seems to have got dropped. Modules that use RCU must call
> rcu_barrier() in their cleanup routine.
> 

hm, I never knew that.

akpm:/usr/src/linux-2.6.21> grep -r rcu_ drivers | wc -l
182
akpm:/usr/src/linux-2.6.21> grep -r rcu_barrier drivers | wc -l 
0

For a start we should undrop that documentation patch, please.
