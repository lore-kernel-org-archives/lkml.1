Return-Path: <linux-kernel-owner+w=401wt.eu-S1752548AbZKKJYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548AbZKKJYX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 04:24:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752228AbZKKJYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 04:24:22 -0500
Received: from mail2.shareable.org ([80.68.89.115]:34286 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbZKKJYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 04:24:21 -0500
Date: Wed, 11 Nov 2009 09:24:09 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Anthony Liguori <aliguori@us.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, agl@linux.vnet.ibm.com,
       Rusty Russell <rusty@rustcorp.com.au>, qemu-devel@nongnu.org,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [Qemu-devel] Re: virtio: Add memory statistics reporting to the balloon driver
Message-ID: <20091111092409.GA24646@shareable.org>
References: <1257782838.2835.5.camel@aglitke> <1257784326.2835.16.camel@aglitke> <200911101312.02650.rusty@rustcorp.com.au> <4AF97A5E.1070801@codemonkey.ws> <4AF97C1A.2080609@redhat.com> <4AF97F93.2080707@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF97F93.2080707@us.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori wrote:
> Avi Kivity wrote:
> >On 11/10/2009 04:36 PM, Anthony Liguori wrote:
> >>
> >>>A stats vq might solve this more cleanly?
> >>
> >>actual and target are both really just stats.  Had we implemented 
> >>those with a vq, I'd be inclined to agree with you but since they're 
> >>implemented in the config space, it seems natural to extend the 
> >>config space with other stats.
> >>
> >
> >There is in fact a difference; actual and target are very rarely 
> >updated, while the stats are updated very often.  Using a vq means a 
> >constant number of exits per batch instead of one exit per statistic.  
> >If the vq is host-driven, it also allows the host to control the 
> >update frequency dynamically (i.e. stop polling when there is no 
> >memory pressure).
> 
> I'm not terribly opposed to using a vq for this.  I would expect the 
> stat update interval to be rather long (10s probably) but a vq works 
> just as well.

If there's no memory pressure and no guest activity, you probably want
the stat update to be as rare as possible to avoid wakeups.  Save
power on laptops, that sort of thing.

If there's a host user interested in the state ("qemutop?"), you may
want updates more often than 10s.

-- Jamie
