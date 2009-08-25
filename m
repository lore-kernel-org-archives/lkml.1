Return-Path: <linux-kernel-owner+w=401wt.eu-S1755521AbZHYRzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521AbZHYRzm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 13:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755485AbZHYRzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 13:55:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755329AbZHYRzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 13:55:40 -0400
Date: Tue, 25 Aug 2009 20:50:16 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       linux-mm@kvack.org, akpm@linux-foundation.org, hpa@zytor.com,
       gregory.haskins@gmail.com
Subject: Re: [PATCHv4 2/2] vhost_net: a kernel-level virtio server
Message-ID: <20090825175016.GA15790@redhat.com>
References: <cover.1250693417.git.mst@redhat.com> <20090819150309.GC4236@redhat.com> <200908252140.41295.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908252140.41295.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 09:40:40PM +0930, Rusty Russell wrote:
> > +	u32 __user *featurep = argp;
> > +	int __user *fdp = argp;
> > +	u32 features;
> > +	int fd, r;
> > +	switch (ioctl) {
> > +	case VHOST_NET_SET_SOCKET:
> > +		r = get_user(fd, fdp);
> > +		if (r < 0)
> > +			return r;
> > +		return vhost_net_set_socket(n, fd);
> > +	case VHOST_GET_FEATURES:
> > +		/* No features for now */
> > +		features = 0;
> > +		return put_user(features, featurep);
> 
> We may well get more than 32 feature bits, at least for virtio_net, which will
> force us to do some trickery in virtio_pci.

Unlike PCI, if we ever run out of bits we can just
add FEATURES_EXTENDED ioctl, no need for trickery.

>  I'd like to avoid that here,
> though it's kind of ugly.  We'd need VHOST_GET_FEATURES (and ACK) to take a
> struct like:
> 
> 	u32 feature_size;
> 	u32 features[];


Thinking about this proposal some more, how will the guest
determine the size to supply the GET_FEATURES ioctl?

Since we are a bit tight in 32 bit space already,
let's just use a 64 bit integer and be done with it?
Right?

-- 
MST
