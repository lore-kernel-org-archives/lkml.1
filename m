Return-Path: <linux-kernel-owner+w=401wt.eu-S1753482AbYDREe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482AbYDREe7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 00:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751019AbYDREes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 00:34:48 -0400
Received: from ozlabs.org ([203.10.76.45]:55903 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750965AbYDREer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 00:34:47 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: netdev@vger.kernel.org
Subject: [PATCH 0/5] High-speed tun receive and xmit
Date: Fri, 18 Apr 2008 14:33:48 +1000
User-Agent: KMail/1.9.9
Cc: Max Krasnyansky <maxk@qualcomm.com>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804181433.48488.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kvm (and lguest!) want to get more speed out of the tun device.  We already 
have an ABI for guest<->host comms, called virtio_ring; extending tun to 
understand this (with its async nature and batching) make for an efficient 
network.

But moreover: the same things that make virtio a good guest<->host transport 
make it appealing as a userspace<->kernel transport.  So rather than do 
something just for tun, we create a /dev/vring.  We could do a system call, 
but /dev/vring is sufficient.  It is a nice, simple format for normal tun 
usage too.

We do need a small (backwards-compatible) extension to the ring format if 
we're going to do this however, since we didn't previously expose the 
consumer's view of the producer (and vice verse) in the ring because the 
other end doesn't need to see it.  However, it means that a middleman (as the 
kvm or lguest launcher process now becomes) cannot save and restore all the 
ring state.

Cheers,
Rusty.
