Return-Path: <linux-kernel-owner+w=401wt.eu-S1758582AbZKYKUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758582AbZKYKUU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 05:20:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758524AbZKYKUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 05:20:19 -0500
Received: from ozlabs.org ([203.10.76.45]:45056 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758420AbZKYKUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 05:20:18 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 1/1] Defer skb allocation for both mergeable buffers and big packets in virtio_net
Date: Wed, 25 Nov 2009 20:50:21 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
Cc: Shirley Ma <mashirle@us.ibm.com>, Eric Dumazet <eric.dumazet@gmail.com>,
       Avi Kivity <avi@redhat.com>, netdev@vger.kernel.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Hollis Blanchard <hollisb@us.ibm.com>
References: <1258697745.7416.20.camel@localhost.localdomain> <200911251042.06368.rusty@rustcorp.com.au> <20091125091530.GA6357@redhat.com>
In-Reply-To: <20091125091530.GA6357@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911252050.21907.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Nov 2009 07:45:30 pm Michael S. Tsirkin wrote:
> Hmm, is it really worth it to save a header copy if it's linear?  We are
> going to access it anyway, and it fits into one cacheline nicely.  On
> the other hand we have more code making life harder for compiler and
> processor.

Not sure: I think there would be many places where it would be useful.

We do a similar thing in the kernel to inspect non-linear packets, and
it's served us well.

Cheers,
Rusty.

