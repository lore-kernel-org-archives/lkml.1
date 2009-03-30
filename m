Return-Path: <linux-kernel-owner+w=401wt.eu-S1756558AbZC3SiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558AbZC3SiY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 14:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbZC3SiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 14:38:14 -0400
Received: from gw.goop.org ([64.81.55.164]:57455 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752745AbZC3SiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 14:38:14 -0400
Message-ID: <49D11184.3060002@goop.org>
Date: Mon, 30 Mar 2009 11:37:56 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>, akpm@osdl.org,
       nickpiggin@yahoo.com.au, frankeh@watson.ibm.com,
       virtualization@lists.osdl.org, riel@redhat.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, hugh@veritas.com
Subject: Re: [patch 0/6] Guest page hinting version 7.
References: <20090327150905.819861420@de.ibm.com>	<1238195024.8286.562.camel@nimitz>  <20090329161253.3faffdeb@skybase> <1238428495.8286.638.camel@nimitz>
In-Reply-To: <1238428495.8286.638.camel@nimitz>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> It also occurs to me that the hypervisor could be doing a lot of this
> internally.  This whole scheme is about telling the hypervisor about
> pages that we (the kernel) know we can regenerate.  The hypervisor
> should know a lot of that information, too.  We ask it to populate a
> page with stuff from virtual I/O devices or write a page out to those
> devices.  The page remains volatile until something from the guest
> writes to it.  The hypervisor could keep a record of how to recreate the
> page as long as it remains volatile and clean.
>   

That potentially pushes a lot of complexity elsewhere.  If you have 
multiple paths to a storage device, or a cluster store shared between 
multiple machines, then the underlying storage can change making the 
guest's copies of those blocks unbacked.  Obviously the host/hypervisor 
could deal with that, but it would be a pile of new mechanisms which 
don't necessarily exist (for example, it would have to be an active 
participant in a distributed locking scheme for a shared block device 
rather than just passing it all through to the guest to handle).

That said, people have been looking at tracking block IO to work out 
when it might be useful to try and share pages between guests under Xen.

    J
