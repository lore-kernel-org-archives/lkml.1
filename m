Return-Path: <linux-kernel-owner+w=401wt.eu-S1755347AbYJVO6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347AbYJVO6H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 10:58:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752437AbYJVO5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 10:57:50 -0400
Received: from relay1.sgi.com ([192.48.171.29]:51547 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752055AbYJVO5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 10:57:49 -0400
Date: Wed, 22 Oct 2008 09:57:48 -0500
From: Russ Anderson <rja@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3] x86: Add UV reserved page bios call
Message-ID: <20081022145748.GC201004@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20081021200128.GE32545@sgi.com> <20081022062338.GE651@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081022062338.GE651@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 08:23:38AM +0200, Ingo Molnar wrote:
> 
> * Russ Anderson <rja@sgi.com> wrote:
> 
> > Add UV bios call to get the address of the reserved page.
> 
> > +	UV_BIOS_GET_PARTITION_ADDR
> 
> > +	BIOS_STATUS_MORE_PASSES		=  1,
> 
> what is the "reserved page"?
> 
> And why is it called "PARTITION_ADDR" in the enum?

The reserved page has partitioning configuration information.
This call returns a pointer (physical addr) to the reserved page.

As some background, a large SGI UV system can be run as multiple
smaller systems (each smaller system is refered to as a partition).
For example, a two rack system can be run as two one rack partitions.
Each partition has a unique linux kernel (just like a stand alone system).
The reserve page is a way of sharing configuration information about 
the other partitions in a partitioned system.  The UV hardware allows
memory to memory transfers between partitions using the GRU (Global
Reference Unit).  SGI Altix hardware has similar functionality (though
the hardware specifics are different).

This is used by the xp driver (drivers/misc/sgi-xp/xpc_uv.c).
Dean Nelson submitted a patch yesterday that uses this bios call.

http://marc.info/?l=linux-kernel&m=122462448719656&w=2

-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
