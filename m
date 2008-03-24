Return-Path: <linux-kernel-owner+w=401wt.eu-S1754078AbYCXUHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078AbYCXUHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 16:07:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850AbYCXUG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 16:06:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55497 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751679AbYCXUG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 16:06:58 -0400
Date: Mon, 24 Mar 2008 13:04:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, greg@kroah.com,
       randy.dunlap@oracle.com
Subject: Re: [patch 2/5] infrastructure to debug (dynamic) objects
Message-Id: <20080324130454.ced60108.akpm@linux-foundation.org>
In-Reply-To: <20080321200321.650649403@linutronix.de>
References: <20080321200300.310393657@linutronix.de>
	<20080321200321.650649403@linutronix.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2008 20:26:18 -0000
Thomas Gleixner <tglx@linutronix.de> wrote:

> The debugobjects core code keeps track of operations on static and
> dynamic objects by inserting them into a hashed list and sanity
> checking them on object operations and provides additional checks
> whenever kernel memory is freed.

Prime candidates for conversion to this interface are locks: spinlocks,
rwlocks, mutexes, etc.

a) it'd be interesting to get that done, as a proof-of-usefulness thing.

b) but this code internally uses spinlocks.  Will it explode?

also list_heads and hlists.  But

a) that might be a bit redundant against the custome debugging which lists
   already have and

b) this code uses lists and hlists internally?
