Return-Path: <linux-kernel-owner+w=401wt.eu-S1760708AbZFWP46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760708AbZFWP46 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 11:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760083AbZFWP4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 11:56:35 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53236 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759965AbZFWP4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 11:56:34 -0400
Date: Tue, 23 Jun 2009 18:56:07 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       mtosatti@redhat.com, paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [PATCH] kvm: remove in_range from kvm_io_device
Message-ID: <20090623155607.GB21423@redhat.com>
References: <20090623150008.GA21059@redhat.com> <4A40F311.80105@novell.com> <20090623153144.GA21423@redhat.com> <4A40F879.3040408@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A40F879.3040408@novell.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 11:44:57AM -0400, Gregory Haskins wrote:
> >>  This proposed approach forces us into a
> >> potential O(256) algorithm in the hotpath (all MMIO/PIO exits will hit
> >> this, not just in-kernel users).  How would you address this?
> >>     
> >
> > Two ideas that come to mind:
> > - add addr/len fields to devices, use these to speed up lookup
> >   
> 
> Yep, thats what I was thinking as well.  We can have the top-level
> (group) be an rbtree on addr/len, and then walk the list of items at
> that address linearly using your read/write() approach.
> 
> 
> > - add a small cache that can be scanned first
> >   
> 
> Yep, I think we may want to do this anyway independent of the search alg.
> 
> > In both cases, you first do a fast lookup, ask the device whether
> > it wants the transaction, then resort to linear scan if not
> >   
> 
> -Greg
> 

Looks like we have a concensus then.

-- 
MST
