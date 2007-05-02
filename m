Return-Path: <linux-kernel-owner+w=401wt.eu-S2993051AbXEBMBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993051AbXEBMBi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 08:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993054AbXEBMBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 08:01:38 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:57511 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993051AbXEBMBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 08:01:37 -0400
Date: Wed, 2 May 2007 17:30:51 +0530
From: Dipankar Sarma <dipankar@in.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: rusty@rustcorp.com.au, torvalds@osdl.org, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: Race between RCU and rmmod
Message-ID: <20070502120051.GA13349@in.ibm.com>
Reply-To: dipankar@in.ibm.com
References: <30958.1178106624@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30958.1178106624@redhat.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2007 at 12:50:24PM +0100, David Howells wrote:
> 
> Hi Dipankar, Rusty,
> 
> I seem to have found a race between RCU and rmmod.  What I see appears to be
> an RCU destructor function that has a call pending but lives in a module, gets
> deleted before the RCU callback is processed:
> 
> RIP: 0010:[<ffffffff880329b7>]  [<ffffffff880329b7>]
> 
> I think that rmmod needs to clear the RCU destructor queue, probably inside of
> __try_stop_module().

This is why we have rcu_barrier() although the corresponding documentation
patch seems to have got dropped. Modules that use RCU must call
rcu_barrier() in their cleanup routine.

Thanks
Dipankar
