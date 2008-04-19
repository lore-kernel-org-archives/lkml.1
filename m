Return-Path: <linux-kernel-owner+w=401wt.eu-S1761525AbYDSQqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761525AbYDSQqU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 12:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754288AbYDSQqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 12:46:06 -0400
Received: from ozlabs.org ([203.10.76.45]:34282 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752804AbYDSQqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 12:46:04 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [PATCH 2/5] /dev/vring: simple userspace-kernel ringbuffer interface.
Date: Sun, 20 Apr 2008 02:45:59 +1000
User-Agent: KMail/1.9.9
Cc: netdev@vger.kernel.org, Max Krasnyansky <maxk@qualcomm.com>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <200804181433.48488.rusty@rustcorp.com.au> <200804200205.31508.rusty@rustcorp.com.au> <20080419163322.GA17089@2ka.mipt.ru>
In-Reply-To: <20080419163322.GA17089@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804200246.00282.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 20 April 2008 02:33:22 Evgeniy Polyakov wrote:
> On Sun, Apr 20, 2008 at 02:05:31AM +1000, Rusty Russell 
(rusty@rustcorp.com.au) wrote:
> > There are two reasons not to grab the lock.  It turns out that if we
> > tried to lock here, we'd deadlock, since the callbacks are called under
> > the lock. Secondly, it's possible to implement an atomic
> > vring_used_buffer variant, which could fail: this would avoid using the
> > thread most of the time.
>
> Yep, I decided that too. But it limits its usage to tun only or any
> other system where only single thread picks up results, so no generic
> userspace ring buffers?

I don't think so, it just externalizes the locking.  The mutex protects the 
attaching and detaching of the ops structure, some other lock or code 
protects simultenous kernel ring accesses.

Cheers,
Rusty.
