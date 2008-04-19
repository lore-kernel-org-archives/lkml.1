Return-Path: <linux-kernel-owner+w=401wt.eu-S1758328AbYDSHEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758328AbYDSHEU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 03:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751146AbYDSHEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 03:04:10 -0400
Received: from gate.crashing.org ([63.228.1.57]:34444 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778AbYDSHEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 03:04:09 -0400
Subject: Re: 2.6.25-rc8-mm1 panic in rpaphp_register_slot()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Alex Chiang <achiang@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, pbadari@us.ibm.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080419063807.GB12987@ldl.fc.hp.com>
References: <20080404180518.GA12642@ldl.fc.hp.com>
	 <1207340371.5916.23.camel@badari-desktop>
	 <20080404224227.GA31436@ldl.fc.hp.com>
	 <1207352128.5916.26.camel@badari-desktop>
	 <20080407234255.GA22514@ldl.fc.hp.com>
	 <20080416031712.GB3333@ldl.fc.hp.com> <1208331916.6958.270.camel@pasglop>
	 <20080416171127.GA18290@ldl.fc.hp.com>
	 <20080416130343.a82702f0.akpm@linux-foundation.org>
	 <1208384185.6958.304.camel@pasglop>  <20080419063807.GB12987@ldl.fc.hp.com>
Content-Type: text/plain
Date: Sat, 19 Apr 2008 17:03:46 +1000
Message-Id: <1208588626.6958.446.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-04-19 at 00:38 -0600, Alex Chiang wrote:
> So I'm not sure how much we can use of your slot infrastructure, I'll
> have
> > to look, I suspect it can cover some cases but not all of them.
> 
> *poke*
> 
> Any update on this?
> 
> Anything I can do to help?

Not yet no. I've looked a bit, but ran out of time, I'll look more this
week-end or next week. I'm also trying to figure out who in IBM is
responsible for that hotplug stuff so they can get involved too.

BTW. How would you do if the answer was we simply can't declare hotplug
"slots" ? ie. if I end up finding out (which is what I think will
happen) that there is simply no way for us to know in advance any
concept of "slot" with a devfn for hotplug ?

Basically, when doing hotplug, the hypervisor sends us new bits of
device-tree with things potentially ranging from host bridges, P2P
bridges to devices, but I'm not certain at this stage we can know in
advance where they'll hook up (in fact, for PHBs, we can't for sure) and
thus even if we end up supporting hotplug of actual slots, we don't even
know in advance the devfn where devices will appear. It's all hidden
from us by the hypervisor.

How would that fit in your infrastructure ? Can we just disable usage of
your slots abstraction in our case ?

Cheers,
Ben.


