Return-Path: <linux-kernel-owner+w=401wt.eu-S1756197AbYKEKta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197AbYKEKta (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 05:49:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752966AbYKEKtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 05:49:20 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:56166 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbYKEKtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 05:49:19 -0500
Subject: Re: [PATCH 1/3] block: add queue flag for paravirt frontend drivers
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org, jeremy@xensource.com
In-Reply-To: <20081105092016.GD21867@kernel.dk>
References: <1219754894.7235.44.camel@sebastian.kern.oss.ntt.co.jp>
	 <20080826143900.GM20055@kernel.dk>
	 <1219814047.18991.52.camel@sebastian.kern.oss.ntt.co.jp>
	 <1225100686.7370.79.camel@sebastian.kern.oss.ntt.co.jp>
	 <20081027125624.GA22217@kernel.dk> <4910D97E.2030203@goop.org>
	 <20081105092016.GD21867@kernel.dk>
Content-Type: text/plain; charset=utf-8
Organization: NTT Open Source Software Center
Date: Wed, 05 Nov 2008 19:49:17 +0900
Message-Id: <1225882157.16917.29.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-11-05 at 10:20 +0100, Jens Axboe wrote: 
> On Tue, Nov 04 2008, Jeremy Fitzhardinge wrote:
> > Jens Axboe wrote:
> > >On Mon, Oct 27 2008, Fernando Luis Vázquez Cao wrote:
> > >
> > >>As is the case with SSD devices, we do not want to idle in AS/CFQ when
> > >>the block device is a paravirt front-end driver. This patch adds a flag
> > >>(QUEUE_FLAG_VIRT) which should be used by front-end drivers such as
> > >>virtio_blk and xen-blkfront to indicate a paravirtualized device.
> > >>
> > >
> > >All three patches look fine, although we could just reuse
> > >QUEUE_FLAG_NONROT directly. But I agree it makes sense to make the
> > >distinction, so I've just applied 1-3.
> > >
> > 
> > I guess in theory you could imagine that the virtual device is mapped
> > directly onto a physical device, and the host OS does no scheduling, in
> > which case it would be appropriate for the guest do the work.  But I
> > think otherwise this makes sense.
> 
> For that specific case, it should just not set the flag.

When the virtual device is mapped directly onto a physical device the
host OS or the hypervisor could notify this fact to the guest using the
PCI configuration space (the bytes reserved for vendor-defined purposes
look like a good candidate to me). In such a case, on the guest side the
driver should just check the configuration space and set/unset the flag
accordingly.

The good thing about this approach is that it can be used with both
paravirt drivers and regular drivers (which is important for fully
virtualized guests).

I have just started to implement this idea but I would be great it you
let me know your take on this issue.

- Fernando

