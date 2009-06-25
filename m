Return-Path: <linux-kernel-owner+w=401wt.eu-S1756704AbZFYHiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704AbZFYHiR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 03:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752828AbZFYHiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 03:38:05 -0400
Received: from woodchuck.wormnet.eu ([77.75.105.223]:60494 "EHLO
	woodchuck.wormnet.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbZFYHiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 03:38:05 -0400
Date: Thu, 25 Jun 2009 08:38:05 +0100
From: Alexander Clouter <alex@digriz.org.uk>
To: david@lang.hm
Cc: linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: When does Linux drop UDP packets?
Message-ID: <20090625073805.GB2014@woodchuck>
References: <20090625050052.GA30594@gondor.apana.org.au> <alpine.DEB.1.10.0906242236400.28437@asgard.lang.hm> <20090625061348.GA31407@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090625061348.GA31407@gondor.apana.org.au>
Organization: diGriz
X-URL: http://www.digriz.org.uk/
X-JabberID: alex@digriz.org.uk
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

* Herbert Xu <herbert@gondor.apana.org.au> [2009-06-25 14:13:48+0800]:
> 
> On Wed, Jun 24, 2009 at 10:37:14PM -0700, david@lang.hm wrote:
> >
> > please explain more? how do they differ?
> 
> An IGMP-snooping switch will only forward multicast traffic to
> ports that have subscribed to that group.  Broadcast traffic
> on the otherhand is forwarded to all ports.
>
[directing over to David...]

The more intelligent switches actually peek at L3/L4 (even if it's just 
a L2 switch, like a Cisco 2950) to decode IGMP packets as they come out 
from the hosts.  The switch uses that to build up an Ethernet multicast 
routing table, in addition to it's usual unicast based one.

If you bought a managed switch in the past five years (ours from 8 years 
ago that we have just binned also supported it) it should support 
IGMP snooping.  Any one buying switches now needs to make sure they 
support IPv6 and MLD snooping...bearing in mind you are going to be 
lumbered with those switches for at least five years.

In addition and mentioned before, the NIC in hardware will also filter 
any multicast traffic that is un-needed if you are using el-cheapo 
switches; crime and punishment.  Broadcast traffic *always* spans the 
whole VLAN and *always* gets passed up to the OS to make decisions on 
whether to process the packet or not.

Now, when you roll back in the 'automaticness' of service discovery and 
other such things on the network...multicast is a very powerful tool.  
Just because it can be many<->many or one<->many does not mean it cannot 
be just as efficiently used to bootstrap one<->one communications.

Cheers

-- 
Alexander Clouter
.sigmonster says: Don't take life seriously, you'll never get out alive.
