Return-Path: <linux-kernel-owner+w=401wt.eu-S1752136AbZHZRAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136AbZHZRAO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 13:00:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbZHZRAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 13:00:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882AbZHZRAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 13:00:12 -0400
Date: Wed, 26 Aug 2009 19:56:55 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       linux-mm@kvack.org, akpm@linux-foundation.org, hpa@zytor.com,
       gregory.haskins@gmail.com
Subject: Re: [PATCHv4 2/2] vhost_net: a kernel-level virtio server
Message-ID: <20090826165655.GA23632@redhat.com>
References: <cover.1250693417.git.mst@redhat.com> <20090819150309.GC4236@redhat.com> <200908252140.41295.rusty@rustcorp.com.au> <20090825131634.GA13949@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090825131634.GA13949@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 04:16:34PM +0300, Michael S. Tsirkin wrote:
> > > +	/* If they don't want an interrupt, don't send one, unless empty. */
> > > +	if ((flags & VRING_AVAIL_F_NO_INTERRUPT) && vq->inflight)
> > > +		return;
> > 
> > And I wouldn't support notify on empty at all, TBH.
> 
> If I don't, virtio net in guest uses a timer, which might be expensive.
> Will need to check what this does.
> 
> >  It should
> > definitely be conditional on the guest accepting the NOTIFY_ON_EMPTY
> > feature.

lguest does not do it this way though, do it?
