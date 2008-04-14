Return-Path: <linux-kernel-owner+w=401wt.eu-S1765763AbYDNShL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765763AbYDNShL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 14:37:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764231AbYDNSg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 14:36:56 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:33496 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763576AbYDNSgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 14:36:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=GsmJP2G1ceE7I/bHPinFG0CZRRMPw4PS0j/qTEFsL77v3j9a8HPq5x0pBOHwilqwxR20Hn9fKPL/TZ8TCiDxZXL8VnEg1/7/TgkMtJC2ExyYR49sTjJnp5Auf2YYi2gPDQCSxCwEwQ1cRMHPNvwCTSviYnWbtTy4zh35xVHUhME=
Date: Mon, 14 Apr 2008 22:32:21 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc8-mm2: IP: [<ffffffff802868f9>] __kmalloc+0x69/0x110
Message-ID: <20080414183221.GA5234@martell.zuzino.mipt.ru>
References: <20080410203354.f0a6f464.akpm@linux-foundation.org> <20080413204422.GA5136@martell.zuzino.mipt.ru> <84144f020804140901p1c076fd2q73e3effe7cd96da3@mail.gmail.com> <Pine.LNX.4.64.0804141050550.6296@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804141050550.6296@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 10:53:12AM -0700, Christoph Lameter wrote:
> On Mon, 14 Apr 2008, Pekka Enberg wrote:
> 
> > >  Code: 48 89 45 d0 9c 41 5d fa e8 f5 a5 fc ff 65 8b 04 25 24 00 00 00 48 98 4c 8b bc c3 c8 00 00 00 4d 8b 27 4d 85 e4 74 7a 41 8b 47 14 <49> 8b 04 c4 49 89 07 41 f7 c5 00 02 00 00 75 37 41 55 9d e8 bf
> > >  RIP  [<ffffffff802868f9>] __kmalloc+0x69/0x110
> > >   RSP <ffff81017cba9c68>
> > >  CR2: 0000000500000500
> > 
> > Looks like freelist corruption where c->freelist is 0x0000000500000500
> > and c->offset is zero... Christoph?
> 
> c->offset is zero is okay. Could be a object freepointer corruption 
> because the first word of the object is overwritten after free. You 
> need to run with slub_debug on the commandline or CONFIG_SLUB_DEBUG_ON to 
> debug this.

Doh! I forgot SLUB debugging again. Apologies and let me reproduce some more.

> Anyone know what the possible meaning of 0x0000000500000500 is? I do not 
> see anything in poison.h.

