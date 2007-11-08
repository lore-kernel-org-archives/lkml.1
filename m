Return-Path: <linux-kernel-owner+w=401wt.eu-S1759743AbXKHCUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759743AbXKHCUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 21:20:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753943AbXKHCUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 21:20:37 -0500
Received: from ozlabs.org ([203.10.76.45]:52821 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753453AbXKHCUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 21:20:37 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Anthony Liguori <aliguori@us.ibm.com>
Subject: Re: [PATCH] virtio config_ops refactoring
Date: Thu, 8 Nov 2007 13:20:35 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Dor Laor <dor.laor@qumranet.com>, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, lguest <lguest@ozlabs.org>
References: <4730A8F3.6020008@us.ibm.com> <200711071704.09752.rusty@rustcorp.com.au> <4731F64A.7080309@us.ibm.com>
In-Reply-To: <4731F64A.7080309@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711081320.35844.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 November 2007 04:30:50 Anthony Liguori wrote:
> I would prefer that the virtio API not expose a little endian standard.
> I'm currently converting config->get() ops to ioreadXX depending on the
> size which already does the endianness conversion for me so this just
> messes things up.  I think it's better to let the backend deal with
> endianness since it's trivial to handle for both the PCI backend and the
> lguest backend (lguest doesn't need to do any endianness conversion).

-ETOOMUCHMAGIC.  We should either expose all the XX interfaces (but this isn't 
a high-speed interface, so let's not) or not "sometimes" convert endianness.  
Getting surprises because a field happens to be packed into 4 bytes is 
counter-intuitive.

Since your most trivial implementation is to do a byte at a time, I don't 
think you have a good argument on that basis either.

Cheers,
Rusty.

