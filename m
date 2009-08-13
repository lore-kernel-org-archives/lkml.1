Return-Path: <linux-kernel-owner+w=401wt.eu-S1752082AbZHMGHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbZHMGHh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 02:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751204AbZHMGHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 02:07:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43357 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153AbZHMGHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 02:07:36 -0400
Date: Thu, 13 Aug 2009 09:06:15 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: virtualization@lists.linux-foundation.org,
       "Ira W. Snyder" <iws@ovro.caltech.edu>, netdev@vger.kernel.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] vhost_net: a kernel-level virtio server
Message-ID: <20090813060615.GC3029@redhat.com>
References: <cover.1249930169.git.mst@redhat.com> <200908121903.22325.arnd@arndb.de> <20090812172141.GA29966@redhat.com> <200908121959.47222.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908121959.47222.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 07:59:47PM +0200, Arnd Bergmann wrote:
> The trick is to swap the virtqueues instead. virtio-net is actually
> mostly symmetric in just the same way that the physical wires on a
> twisted pair ethernet are symmetric (I like how that analogy fits).

You need to really squint hard for it to look symmetric.

For example, for RX, virtio allocates an skb, puts a descriptor on a
ring and waits for host to fill it in. Host system can not do the same:
guest does not have access to host memory.

You can do a copy in transport to hide this fact, but it will kill
performance.

-- 
MST
