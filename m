Return-Path: <linux-kernel-owner+w=401wt.eu-S1754731AbZFUWZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbZFUWZp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 18:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751784AbZFUWZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 18:25:36 -0400
Received: from gate.crashing.org ([63.228.1.57]:53997 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373AbZFUWZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 18:25:35 -0400
Subject: Re: Badness on the Warp
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Frans Pop <elendil@planet.nl>, Sean MacLennan <smaclennan@pikatech.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       David Gibson <david@gibson.dropbear.id.au>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <84144f020906210320n2984807dw2d4b4fb38afd22cf@mail.gmail.com>
References: <20090620154824.72b5cd50@lappy.seanm.ca>
	 <200906202256.46073.elendil@planet.nl>
	 <20090620194250.5a3e826f@lappy.seanm.ca>
	 <200906210628.35553.elendil@planet.nl>
	 <84144f020906210320n2984807dw2d4b4fb38afd22cf@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 22 Jun 2009 08:25:04 +1000
Message-Id: <1245623104.16880.26.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-06-21 at 13:20 +0300, Pekka Enberg wrote:
> The WARN_ON() is there to let us know that someone is doing a bootmem
> allocation but the slab allocator is already up. So the proper fix
> here is to use kmalloc() directly in the call-site that triggers this
> WARN_ON. I'm cc'ing Ben as he has been taking care of the fall-out
> from my patches on ppc.
> 
Right, our interrupt controllers need those fixes, they are low
on my priority list since it's a reasonably harmless warning and I'm
still chasing some actual breakage (though maybe not directly related to
your patches).

Kumar already submitted a couple, Frans, feel free to beat me
at converting UIC (just use kmalloc directly in there instead
of alloc_bootmem).

Cheers,
Ben.


