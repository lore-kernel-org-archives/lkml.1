Return-Path: <linux-kernel-owner+w=401wt.eu-S1753854AbZHMOmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbZHMOmw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 10:42:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbZHMOmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 10:42:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38703 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752175AbZHMOmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 10:42:50 -0400
Date: Thu, 13 Aug 2009 17:41:30 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
       "Ira W. Snyder" <iws@ovro.caltech.edu>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [PATCH 2/2] vhost_net: a kernel-level virtio server
Message-ID: <20090813144129.GB5080@redhat.com>
References: <cover.1249930169.git.mst@redhat.com> <20090813060615.GC3029@redhat.com> <200908131538.44465.arnd@arndb.de> <200908131548.35199.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908131548.35199.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 03:48:35PM +0200, Arnd Bergmann wrote:
> On Thursday 13 August 2009, Arnd Bergmann wrote:
> > Unfortunately, this also implies that you could no longer simply use the
> > packet socket interface as you do currently, as I realized only now.
> > This obviously has a significant impact on your user space interface.
> 
> Also, if we do the copy in the transport, it definitely means that we
> can't get to zero-copy RX/TX from guest space any more. The current
> vhost_net driver doesn't do that yet, but could be extended in the
> same way that I'm hoping to do it for macvtap.
> 
> 	Arnd <><

The best way to do this IMO would be to add zero copy support to raw
sockets, vhost will then get it basically for free.

-- 
MST
