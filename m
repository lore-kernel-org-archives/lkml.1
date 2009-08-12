Return-Path: <linux-kernel-owner+w=401wt.eu-S1752309AbZHLNIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309AbZHLNIw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 09:08:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752221AbZHLNIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 09:08:52 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39381 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438AbZHLNIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 09:08:50 -0400
Date: Wed, 12 Aug 2009 16:06:12 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Gregory Haskins <gregory.haskins@gmail.com>, netdev@vger.kernel.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>, hpa@zytor.com,
       Patrick Mullaney <pmullaney@novell.com>
Subject: Re: [PATCHv2 0/2] vhost: a kernel-level virtio server
Message-ID: <20090812130612.GC29200@redhat.com>
References: <20090811212743.GA26309@redhat.com> <20090812120541.GA29158@redhat.com> <4A82B87B.4010208@gmail.com> <200908121452.01802.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908121452.01802.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 02:52:01PM +0200, Arnd Bergmann wrote:
> On Wednesday 12 August 2009, Gregory Haskins wrote:
> > >> Are you saying SRIOV is a requirement, and I can either program the
> > >> SRIOV adapter with a mac or use promis?  Or are you saying I can use
> > >> SRIOV+programmed mac OR a regular nic + promisc (with a perf penalty).
> > > 
> > > SRIOV is not a requirement. And you can also use a dedicated
> > > nic+programmed mac if you are so inclined.
> > 
> > Makes sense.  Got it.
> > 
> > I was going to add guest-to-guest to the test matrix, but I assume that
> > is not supported with vhost unless you have something like a VEPA
> > enabled bridge?
> > 
> 
> If I understand it correctly, you can at least connect a veth pair
> to a bridge, right? Something like
> 
>            veth0 - veth1 - vhost - guest 1 
> eth0 - br0-|
>            veth2 - veth3 - vhost - guest 2
>           
> It's a bit more complicated than it need to be, but should work fine.
> 
> 	Arnd <><

Heh, you don't need a bridge in this picture:

guest 1 - vhost - veth0 - veth1 - vhost guest 2

