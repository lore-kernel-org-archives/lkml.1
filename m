Return-Path: <linux-kernel-owner+w=401wt.eu-S1760329AbXENWsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760329AbXENWsw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 18:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756258AbXENWsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 18:48:45 -0400
Received: from gate.crashing.org ([63.228.1.57]:36140 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754113AbXENWso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 18:48:44 -0400
Subject: Re: [PATCH] pcmcia: ppc64 needs 64-bit ioaddr_t
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Olof Johansson <olof@lixom.net>, linuxppc-dev@ozlabs.org,
       linux-pcmcia@lists.infradead.org, paulus@samba.org,
       linux-kernel@vger.kernel.org,
       Dominik Brodowski <linux@dominikbrodowski.net>
In-Reply-To: <20070514150802.b9120e9f.akpm@linux-foundation.org>
References: <20070512143105.GA12890@lixom.net>
	 <20070514150802.b9120e9f.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 15 May 2007 08:47:04 +1000
Message-Id: <1179182824.32247.131.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-14 at 15:08 -0700, Andrew Morton wrote:
> 
> Well that's some pretty sad code you've found there.  The kernel
> surely has
> some appropriate type to use here without us having to invent a new
> one. 
> But I suspect if we were to rationalise things in there it will get
> messy.

There is more sad stuff involved with drivers assuming IO ports fit in
int. A proper fix for 2.6.23 will be the rework of PIO allocation I'm
doing. A temporary fix for 2.6.22 would be for Olof to use
reserve_phb_iospace() to make sure his PIO gets in the low 31 bits. We
need to add a spinlock to it though.

Ben.


