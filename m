Return-Path: <linux-kernel-owner+w=401wt.eu-S1758737AbZKYLnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758737AbZKYLnS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 06:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbZKYLnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 06:43:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19064 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869AbZKYLnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 06:43:17 -0500
Date: Wed, 25 Nov 2009 13:40:29 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Shirley Ma <mashirle@us.ibm.com>, Eric Dumazet <eric.dumazet@gmail.com>,
       Avi Kivity <avi@redhat.com>, netdev@vger.kernel.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Hollis Blanchard <hollisb@us.ibm.com>
Subject: Re: [PATCH 1/1] Defer skb allocation for both mergeable buffers
	and big packets in virtio_net
Message-ID: <20091125114029.GA9333@redhat.com>
References: <1258697745.7416.20.camel@localhost.localdomain> <200911251042.06368.rusty@rustcorp.com.au> <20091125091530.GA6357@redhat.com> <200911252050.21907.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911252050.21907.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 25, 2009 at 08:50:21PM +1030, Rusty Russell wrote:
> On Wed, 25 Nov 2009 07:45:30 pm Michael S. Tsirkin wrote:
> > Hmm, is it really worth it to save a header copy if it's linear?  We are
> > going to access it anyway, and it fits into one cacheline nicely.  On
> > the other hand we have more code making life harder for compiler and
> > processor.
> 
> Not sure: I think there would be many places where it would be useful.
> 
> We do a similar thing in the kernel to inspect non-linear packets, and
> it's served us well.

You mean this gives measureable speedup? Okay ...

> Cheers,
> Rusty.
