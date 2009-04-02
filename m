Return-Path: <linux-kernel-owner+w=401wt.eu-S1754452AbZDBMNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452AbZDBMNn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 08:13:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbZDBMN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 08:13:29 -0400
Received: from ozlabs.org ([203.10.76.45]:38902 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748AbZDBMN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 08:13:28 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Gregory Haskins <ghaskins@novell.com>
Subject: Re: [RFC PATCH 00/17] virtual-bus
Date: Thu, 2 Apr 2009 22:43:19 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.2; i686; ; )
Cc: Avi Kivity <avi@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>,
       anthony@codemonkey.ws, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, agraf@suse.de, pmullaney@novell.com,
       pmorreale@novell.com, netdev@vger.kernel.org, kvm@vger.kernel.org
References: <20090402085253.GA29932@gondor.apana.org.au> <49D487A6.407@redhat.com> <49D49C1F.6030306@novell.com>
In-Reply-To: <49D49C1F.6030306@novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904022243.21088.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 April 2009 21:36:07 Gregory Haskins wrote:
> You do not need to know when the packet is copied (which I currently
> do).  You only need it for zero-copy (of which I would like to support,
> but as I understand it there are problems with the reliability of proper
> callback (i.e. skb->destructor).

But if you have a UP guest, there will *never* be another packet in the queue
at this point, since it wasn't running.

As Avi said, you can do the processing in another thread and go back to the
guest; lguest pre-virtio did a hacky "weak" wakeup to ensure the guest ran
again before the thread did for exactly this kind of reason.

While Avi's point about a "powerful enough userspace API" is probably valid,
I don't think it's going to happen.  It's almost certainly less code to put a
virtio_net server in the kernel, than it is to create such a powerful
interface (see vringfd & tap).  And that interface would have one user in
practice.

So, let's roll out a kernel virtio_net server.  Anyone?
Rusty.
