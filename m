Return-Path: <linux-kernel-owner+w=401wt.eu-S1753982AbYLVKRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbYLVKRo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 05:17:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751219AbYLVKRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 05:17:36 -0500
Received: from mx2.redhat.com ([66.187.237.31]:35866 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089AbYLVKRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 05:17:35 -0500
Subject: Re: [PATCH 2/3] virtio: indirect ring entries
 (VIRTIO_RING_F_INDIRECT_DESC)
From: Mark McLoughlin <markmc@redhat.com>
Reply-To: Mark McLoughlin <markmc@redhat.com>
To: Ingo Oeser <ioe-lkml@rameria.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@redhat.com>
In-Reply-To: <200812201238.07510.ioe-lkml@rameria.de>
References: <1229620222-22216-1-git-send-email-markmc@redhat.com>
	 <1229620222-22216-2-git-send-email-markmc@redhat.com>
	 <1229620222-22216-3-git-send-email-markmc@redhat.com>
	 <200812201238.07510.ioe-lkml@rameria.de>
Content-Type: text/plain
Date: Mon, 22 Dec 2008 10:17:21 +0000
Message-Id: <1229941041.19474.2.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Sat, 2008-12-20 at 12:38 +0100, Ingo Oeser wrote:
> Hi Mark,
> 
> On Thursday 18 December 2008, Mark McLoughlin wrote:
> > diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> > index 5777196..2330c4b 100644
> > --- a/drivers/virtio/virtio_ring.c
> > +++ b/drivers/virtio/virtio_ring.c
> > @@ -70,6 +73,55 @@ struct vring_virtqueue
> >  
> >  #define to_vvq(_vq) container_of(_vq, struct vring_virtqueue, vq)
> >  
> > +/* Set up an indirect table of descriptors and add it to the queue. */
> > +static int vring_add_indirect(struct vring_virtqueue *vq,
> > +			      struct scatterlist sg[],
> > +			      unsigned int out,
> > +			      unsigned int in)
> > +{
> > +	struct vring_desc *desc;
> > +	unsigned head;
> > +	int i;
> > +
> > +	desc = kmalloc((out + in) * sizeof(struct vring_desc), GFP_ATOMIC);
> 
> kmalloc() returns ZERO_SIZE_PTR, if (out + in) == 0

vring_add_buf() has:

  BUG_ON(out + in == 0)

I should just add that here too before the kmalloc() call.

Thanks,
Mark.

