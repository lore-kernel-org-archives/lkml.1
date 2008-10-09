Return-Path: <linux-kernel-owner+w=401wt.eu-S1759923AbYJIPgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759923AbYJIPgR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 11:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756080AbYJIPgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 11:36:06 -0400
Received: from sous-sol.org ([216.99.217.87]:48690 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753336AbYJIPgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 11:36:05 -0400
Date: Thu, 9 Oct 2008 08:35:46 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mark McLoughlin <markmc@redhat.com>, virtualization@lists.osdl.org,
       linux-kernel@vger.kernel.org, Herbert Xu <herbert.xu@redhat.com>
Subject: Re: [PATCH 2/2] virtio_net: Improve the recv buffer allocation
	scheme
Message-ID: <20081009153546.GA6912@sequoia.sous-sol.org>
References: <1223494499-18732-1-git-send-email-markmc@redhat.com> <1223494499-18732-2-git-send-email-markmc@redhat.com> <200810091155.59731.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810091155.59731.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rusty Russell (rusty@rustcorp.com.au) wrote:
> On Thursday 09 October 2008 06:34:59 Mark McLoughlin wrote:
> > From: Herbert Xu <herbert.xu@redhat.com>
> >
> > If segmentation offload is enabled by the host, we currently allocate
> > maximum sized packet buffers and pass them to the host. This uses up
> > 20 ring entries, allowing us to supply only 20 packet buffers to the
> > host with a 256 entry ring. This is a huge overhead when receiving
> > small packets, and is most keenly felt when receiving MTU sized
> > packets from off-host.
> 
> There are three approaches we should investigate before adding YA feature.  
> Obviously, we can simply increase the number of ring entries.

Tried that, it didn't help much.  I don't have my numbers handy, but
levelled off at about 512 and was a modest boost.  It's still wasteful
to preallocate like that on the off-chance it's a large packet.

thanks,
-chris
