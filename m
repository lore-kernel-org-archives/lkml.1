Return-Path: <linux-kernel-owner+w=401wt.eu-S934033AbYEBK40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934033AbYEBK40 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 06:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763056AbYEBK4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 06:56:03 -0400
Received: from ozlabs.org ([203.10.76.45]:40060 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762688AbYEBK4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 06:56:01 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mark McLoughlin <markmc@redhat.com>
Subject: Re: [PATCH] virtio_net: free transmit skbs in a timer
Date: Fri, 2 May 2008 20:55:25 +1000
User-Agent: KMail/1.9.9
Cc: Anthony Liguori <aliguori@us.ibm.com>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <1209565906-9019-1-git-send-email-markmc@redhat.com>
In-Reply-To: <1209565906-9019-1-git-send-email-markmc@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805022055.25870.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 May 2008 00:31:46 Mark McLoughlin wrote:
> virtio_net currently only frees old transmit skbs just
> before queueing new ones. If the queue is full, it then
> enables interrupts and waits for notification that more
> work has been performed.

Hi Mark,

   This patch is fine, but it's better to do it from skb_xmit_done().  Of 
course, this is usually called from an interrupt handler, so it's not 
entirely trivial: we can't free the skbs there.

   A softirq is probably the answer here, but AFAICT that's old fashioned.  
Not sure what the right way of doing this is now...

Rusty.
