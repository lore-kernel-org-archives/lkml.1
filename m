Return-Path: <linux-kernel-owner+w=401wt.eu-S1752066AbZHLMl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066AbZHLMl4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 08:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752008AbZHLMlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 08:41:55 -0400
Received: from ozlabs.org ([203.10.76.45]:34388 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982AbZHLMly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 08:41:54 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH] fix memory leak in virtio_net
Date: Wed, 12 Aug 2009 22:11:53 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-14-generic; KDE/4.2.2; i686; ; )
Cc: Shirley Ma <mashirle@us.ibm.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <1249934708.7400.10.camel@localhost.localdomain> <4A815B9A.3060205@redhat.com>
In-Reply-To: <4A815B9A.3060205@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908122211.53890.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Aug 2009 09:22:58 pm Avi Kivity wrote:
> (copying Rusty, the virtio maintainer)
> 
> On 08/10/2009 11:05 PM, Shirley Ma wrote:
> > Whild reading virtio code, I found some memory leak in removing
> > virtio_net.
> >
> > In virtnet_remove, only skb has been freed not the pages in skb
> > frags. Here is the patch to fix this, please review it.

Nope, kfree_skb() frees the frags.

It needs to, otherwise we leak on every received packet!

Cheers,
Rusty.
