Return-Path: <linux-kernel-owner+w=401wt.eu-S1760681AbZIQD7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760681AbZIQD7j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 23:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760668AbZIQD7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 23:59:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760663AbZIQD7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 23:59:37 -0400
Date: Thu, 17 Sep 2009 06:57:17 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <gregory.haskins@gmail.com>
Cc: Avi Kivity <avi@redhat.com>, "Ira W. Snyder" <iws@ovro.caltech.edu>,
       netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       linux-mm@kvack.org, akpm@linux-foundation.org, hpa@zytor.com,
       Rusty Russell <rusty@rustcorp.com.au>, s.hetze@linux-ag.com,
       alacrityvm-devel@lists.sourceforge.net
Subject: Re: [PATCHv5 3/3] vhost_net: a kernel-level virtio server
Message-ID: <20090917035717.GB3088@redhat.com>
References: <4AAF8A03.5020806@redhat.com> <4AAF909F.9080306@gmail.com> <4AAF95D1.1080600@redhat.com> <4AAF9BAF.3030109@gmail.com> <4AAFACB5.9050808@redhat.com> <4AAFF437.7060100@gmail.com> <4AB0A070.1050400@redhat.com> <4AB0CFA5.6040104@gmail.com> <4AB0E2A2.3080409@redhat.com> <4AB0F1EF.5050102@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AB0F1EF.5050102@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 10:10:55AM -0400, Gregory Haskins wrote:
> > There is no role reversal.
> 
> So if I have virtio-blk driver running on the x86 and vhost-blk device
> running on the ppc board, I can use the ppc board as a block-device.
> What if I really wanted to go the other way?

It seems ppc is the only one that can initiate DMA to an arbitrary
address, so you can't do this really, or you can by tunneling each
request back to ppc, or doing an extra data copy, but it's unlikely to
work well.

The limitation comes from hardware, not from the API we use.
