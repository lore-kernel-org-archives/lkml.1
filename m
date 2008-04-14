Return-Path: <linux-kernel-owner+w=401wt.eu-S1764240AbYDNRxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764240AbYDNRxW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 13:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756718AbYDNRxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 13:53:14 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50274 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755702AbYDNRxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 13:53:13 -0400
Date: Mon, 14 Apr 2008 10:53:12 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc8-mm2: IP: [<ffffffff802868f9>] __kmalloc+0x69/0x110
In-Reply-To: <84144f020804140901p1c076fd2q73e3effe7cd96da3@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0804141050550.6296@schroedinger.engr.sgi.com>
References: <20080410203354.f0a6f464.akpm@linux-foundation.org> 
 <20080413204422.GA5136@martell.zuzino.mipt.ru>
 <84144f020804140901p1c076fd2q73e3effe7cd96da3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2008, Pekka Enberg wrote:

> >  Code: 48 89 45 d0 9c 41 5d fa e8 f5 a5 fc ff 65 8b 04 25 24 00 00 00 48 98 4c 8b bc c3 c8 00 00 00 4d 8b 27 4d 85 e4 74 7a 41 8b 47 14 <49> 8b 04 c4 49 89 07 41 f7 c5 00 02 00 00 75 37 41 55 9d e8 bf
> >  RIP  [<ffffffff802868f9>] __kmalloc+0x69/0x110
> >   RSP <ffff81017cba9c68>
> >  CR2: 0000000500000500
> 
> Looks like freelist corruption where c->freelist is 0x0000000500000500
> and c->offset is zero... Christoph?

c->offset is zero is okay. Could be a object freepointer corruption 
because the first word of the object is overwritten after free. You 
need to run with slub_debug on the commandline or CONFIG_SLUB_DEBUG_ON to 
debug this.

Anyone know what the possible meaning of 0x0000000500000500 is? I do not 
see anything in poison.h.

