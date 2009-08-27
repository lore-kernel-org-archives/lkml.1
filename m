Return-Path: <linux-kernel-owner+w=401wt.eu-S1752298AbZH0KMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298AbZH0KMi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 06:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752304AbZH0KMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 06:12:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752282AbZH0KMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 06:12:33 -0400
Date: Thu, 27 Aug 2009 13:10:26 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: virtualization@lists.linux-foundation.org,
       Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, hpa@zytor.com, mingo@elte.hu,
       akpm@linux-foundation.org
Subject: Re: [PATCHv4 2/2] vhost_net: a kernel-level virtio server
Message-ID: <20090827101026.GA8545@redhat.com>
References: <cover.1250693417.git.mst@redhat.com> <200908252140.41295.rusty@rustcorp.com.au> <20090825175016.GA15790@redhat.com> <200908261540.59900.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908261540.59900.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26, 2009 at 03:40:59PM +0200, Arnd Bergmann wrote:
> On Tuesday 25 August 2009, Michael S. Tsirkin wrote:
> > >  I'd like to avoid that here,
> > > though it's kind of ugly.  We'd need VHOST_GET_FEATURES (and ACK) to take a
> > > struct like:
> > > 
> > >       u32 feature_size;
> > >       u32 features[];
> 
> Hmm, variable length ioctl arguments, I'd rather not go there.
> The ioctl infrastructure already has a length argument encoded
> in the ioctl number. We can use that if we need more, e.g.
> 
> /* now */
> #define VHOST_GET_FEATURES     _IOR(VHOST_VIRTIO, 0x00, __u64)
> /*
>  * uncomment if we run out of feature bits:
> 
> struct vhost_get_features2 {
> 	__u64 bits[2];
> };
> #define VHOST_GET_FEATURES2     _IOR(VHOST_VIRTIO, 0x00, \
> 			struct  vhost_get_features2)
>  */


I thought so, too. Rusty, agree?

-- 
MST
