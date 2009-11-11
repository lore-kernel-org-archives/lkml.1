Return-Path: <linux-kernel-owner+w=401wt.eu-S1756555AbZKKKMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555AbZKKKMl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 05:12:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753361AbZKKKMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 05:12:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356AbZKKKMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 05:12:39 -0500
Date: Wed, 11 Nov 2009 10:12:23 +0000
From: "Daniel P. Berrange" <berrange@redhat.com>
To: Jamie Lokier <jamie@shareable.org>
Cc: Anthony Liguori <aliguori@us.ibm.com>, agl@linux.vnet.ibm.com,
       qemu-devel@nongnu.org, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       Avi Kivity <avi@redhat.com>
Subject: Re: [Qemu-devel] Re: virtio: Add memory statistics reporting to the balloon driver
Message-ID: <20091111101223.GA22937@redhat.com>
Reply-To: "Daniel P. Berrange" <berrange@redhat.com>
References: <1257782838.2835.5.camel@aglitke> <1257784326.2835.16.camel@aglitke> <200911101312.02650.rusty@rustcorp.com.au> <4AF97A5E.1070801@codemonkey.ws> <4AF97C1A.2080609@redhat.com> <4AF97F93.2080707@us.ibm.com> <20091111092409.GA24646@shareable.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091111092409.GA24646@shareable.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 11, 2009 at 09:24:09AM +0000, Jamie Lokier wrote:
> Anthony Liguori wrote:
> > Avi Kivity wrote:
> > >On 11/10/2009 04:36 PM, Anthony Liguori wrote:
> > >>
> > >>>A stats vq might solve this more cleanly?
> > >>
> > >>actual and target are both really just stats.  Had we implemented 
> > >>those with a vq, I'd be inclined to agree with you but since they're 
> > >>implemented in the config space, it seems natural to extend the 
> > >>config space with other stats.
> > >>
> > >
> > >There is in fact a difference; actual and target are very rarely 
> > >updated, while the stats are updated very often.  Using a vq means a 
> > >constant number of exits per batch instead of one exit per statistic.  
> > >If the vq is host-driven, it also allows the host to control the 
> > >update frequency dynamically (i.e. stop polling when there is no 
> > >memory pressure).
> > 
> > I'm not terribly opposed to using a vq for this.  I would expect the 
> > stat update interval to be rather long (10s probably) but a vq works 
> > just as well.
> 
> If there's no memory pressure and no guest activity, you probably want
> the stat update to be as rare as possible to avoid wakeups.  Save
> power on laptops, that sort of thing.
> 
> If there's a host user interested in the state ("qemutop?"), you may
> want updates more often than 10s.

This all suggests that we should only update the stats from the guest
when something on the host actually asks for them by issuing the QEMU
monitor command. We don't want any kind of continuous polling of stats
at any frequency, if nothing is using these stats on the host.

Daniel
-- 
|: Red Hat, Engineering, London   -o-   http://people.redhat.com/berrange/ :|
|: http://libvirt.org  -o-  http://virt-manager.org  -o-  http://ovirt.org :|
|: http://autobuild.org       -o-         http://search.cpan.org/~danberr/ :|
|: GnuPG: 7D3B9505  -o-  F3C9 553F A1DA 4AC2 5648 23C1 B3DF F742 7D3B 9505 :|
