Return-Path: <linux-kernel-owner+w=401wt.eu-S1753080AbZK3SpI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080AbZK3SpI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 13:45:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbZK3SpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 13:45:07 -0500
Received: from waste.org ([173.11.57.241]:44236 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596AbZK3SpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 13:45:07 -0500
Subject: Re: [PATCH 1/2] hw_random: core updates to allow more efficient
 drivers
From: Matt Mackall <mpm@selenic.com>
To: Ian Molton <ian.molton@collabora.co.uk>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
In-Reply-To: <4B139E3D.1020905@collabora.co.uk>
References: <1259177252.2858.17.camel@calx>
	 <1259195127-20086-2-git-send-email-ian.molton@collabora.co.uk>
	 <1259197403.2858.88.camel@calx> <200911282035.26847.rusty@rustcorp.com.au>
	 <4B139E3D.1020905@collabora.co.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Nov 2009 12:44:16 -0600
Message-ID: <1259606656.29740.48.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-30 at 10:28 +0000, Ian Molton wrote:
> Rusty Russell wrote:
> 
> > And might as well just #defube RNG_BUFFSIZE SMP_CACHE_BYTES (or use
> > SMP_CACHE_BYTES here and sizeof() elsewhere).
> 
> This can lead to a rather small (4 byte) buffer on some systems, however
> I don't know if in practice a tiny buffer or a big one would be better
> for performance on those machines. I guess if its a problem someone can
> patch the code to allocate a minimum of (say) 16 bytes in future...

Hmmm, I think this was bad advice from Rusty.

The goal is to size and align the buffer so that we know it will always
work. Thus 64 bytes (always big enough but not so big that anyone will
complain) and cache aligned (makes stupid things like Via Padlock happy
-on Vias-). 

Rusty's suggestion could easily have us in trouble if some driver wants
to hand us a mere 64 bits on an architecture with 4-byte cache alignment
but is otherwise perfectly happy with 64-bit stores. 

-- 
http://selenic.com : development and support for Mercurial and Linux


