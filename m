Return-Path: <linux-kernel-owner+w=401wt.eu-S1754316AbZLROpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316AbZLROpi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 09:45:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753780AbZLROph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 09:45:37 -0500
Received: from mtagate6.uk.ibm.com ([194.196.100.166]:56166 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbZLROpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 09:45:36 -0500
Date: Fri, 18 Dec 2009 15:45:33 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       paulmck@linux.vnet.ibm.com, a.p.zijlstra@chello.nl,
       cl@linux-foundation.org
Subject: Re: [2.6.33-rc1] slab: possible recursive locking detected
Message-ID: <20091218144533.GA19392@osiris.boeblingen.de.ibm.com>
References: <20091218115843.GB7728@osiris.boeblingen.de.ibm.com>
 <1261141094.5014.11.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261141094.5014.11.camel@penberg-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 18, 2009 at 02:58:13PM +0200, Pekka Enberg wrote:
> Hi Heiko,
> 
> On Fri, 2009-12-18 at 12:58 +0100, Heiko Carstens wrote:
> > Just got this with CONFIG_SLAB:
> > 
> > =============================================
> > [ INFO: possible recursive locking detected ]
> > 2.6.33-rc1-dirty #23
> > ---------------------------------------------
> > events/5/20 is trying to acquire lock:
> >  (&(&parent->list_lock)->rlock){..-...}, at: [<00000000000ee898>] cache_flusharray+0x3c/0x12c
> > 
> > but task is already holding lock:
> >  (&(&parent->list_lock)->rlock){..-...}, at: [<00000000000eee52>] drain_array+0x52/0x100
[...]
>
> Thanks for the report! Does reverting the following commit make the
> warning go away?
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=ce79ddc8e2376a9a93c7d42daf89bfcbb9187e62

Yes, with that one reverted the warning is away.
