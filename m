Return-Path: <linux-kernel-owner+w=401wt.eu-S1754501AbZHLQjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbZHLQjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 12:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753896AbZHLQjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 12:39:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53898 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753725AbZHLQjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 12:39:17 -0400
Date: Wed, 12 Aug 2009 19:37:37 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <gregory.haskins@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>, hpa@zytor.com,
       Patrick Mullaney <pmullaney@novell.com>
Subject: Re: [PATCHv2 0/2] vhost: a kernel-level virtio server
Message-ID: <20090812163737.GA29903@redhat.com>
References: <20090811212743.GA26309@redhat.com> <200908121452.01802.arnd@arndb.de> <20090812130612.GC29200@redhat.com> <200908121540.44928.arnd@arndb.de> <4A82C8F1.4030703@gmail.com> <20090812140224.GA29345@redhat.com> <4A82EA37.3010902@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A82EA37.3010902@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 12:13:43PM -0400, Gregory Haskins wrote:
> Michael S. Tsirkin wrote:
> > On Wed, Aug 12, 2009 at 09:51:45AM -0400, Gregory Haskins wrote:
> >> Arnd Bergmann wrote:
> >>> On Wednesday 12 August 2009, Michael S. Tsirkin wrote:
> >>>>> If I understand it correctly, you can at least connect a veth pair
> >>>>> to a bridge, right? Something like
> >>>>>
> >>>>>            veth0 - veth1 - vhost - guest 1 
> >>>>> eth0 - br0-|
> >>>>>            veth2 - veth3 - vhost - guest 2
> >>>>>            
> >>>> Heh, you don't need a bridge in this picture:
> >>>>
> >>>> guest 1 - vhost - veth0 - veth1 - vhost guest 2
> >>> Sure, but the setup I described is the one that I would expect
> >>> to see in practice because it gives you external connectivity.
> >>>
> >>> Measuring two guests communicating over a veth pair is
> >>> interesting for finding the bottlenecks, but of little
> >>> practical relevance.
> >>>
> >>> 	Arnd <><
> >> Yeah, this would be the config I would be interested in.
> > 
> > Hmm, this wouldn't be the config to use for the benchmark though: there
> > are just too many variables.  If you want both guest to guest and guest
> > to host, create 2 nics in the guest.
> > 
> > Here's one way to do this:
> > 
> > 	-net nic,model=virtio,vlan=0 -net user,vlan=0
> > 	-net nic,vlan=1,model=virtio,vhost=veth0
> > 	-redir tcp:8022::22
> > 
> > 	-net nic,model=virtio,vlan=0 -net user,vlan=0
> > 	 -net nic,vlan=1,model=virtio,vhost=veth1
> > 	-redir tcp:8023::22
> > 
> > In guests, for simplicity, configure eth1 and eth0
> > to use separate subnets.
> 
> I can try to do a few variations, but what I am interested is in
> performance in a real-world L2 configuration.  This would generally mean
>  all hosts (virtual or physical) in the same L2 domain.
> 
> If I get a chance, though, I will try to also wire them up in isolation
> as another data point.
> 
> Regards,
> -Greg
> 
> 

Or patch macvlan to support guest to guest:
http://markmail.org/message/sjy74g57qsvdo2wh
That patch needs to be updated to support guest to guest multiast,
but it seems functional enough for your purposes.

-- 
MST
