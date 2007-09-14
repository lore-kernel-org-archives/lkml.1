Return-Path: <linux-kernel-owner+w=401wt.eu-S1757547AbXINQvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547AbXINQvc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 12:51:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755289AbXINQvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 12:51:15 -0400
Received: from lixom.net ([66.141.50.11]:60447 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755160AbXINQvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 12:51:13 -0400
Date: Fri, 14 Sep 2007 11:52:33 -0500
From: Olof Johansson <olof@lixom.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org, hch@lst.de,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] pcmcia: Convert io_req_t to use kio_addr_t
Message-ID: <20070914165233.GA3045@lixom.net>
References: <20070905142742.GA1760@lixom.net> <20070914034854.1658a9cf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070914034854.1658a9cf.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2007 at 03:48:54AM -0700, Andrew Morton wrote:
> On Wed, 5 Sep 2007 09:27:43 -0500 Olof Johansson <olof@lixom.net> wrote:
> 
> > Convert the io_req_t members to kio_addr_t, to allow use on machines with
> > more than 16 bits worth of IO port address space (ppc64 in this case,
> > but it applies to others as well).
> 
> drivers/usb/host/sl811_cs.c: In function 'sl811_cs_config':
> drivers/usb/host/sl811_cs.c:263: warning: format '%04x' expects type 'unsigned int', but argument 2 has type 'kio_addr_t'
> drivers/usb/host/sl811_cs.c:263: warning: format '%04x' expects type 'unsigned int', but argument 3 has type 'long unsigned int'
> 
> That's not just a cosmetic thing - the printk can print junk and if there's
> a %s in the control string after the %x's, printk() will crash.
> 
> I don't know how many instances of this are in the tree, but they'll all
> need to be found and fixed.

A crap, I completely forgot to check drivers/, and my default builds
don't contain many of them. My bad.

I'll do a full pass and review all references to the changed variables. So
far I've only noticed printk stuff, but I'm not done. There's a fair
amount lot of places where they're cast into ints instead of longs,
but that's a whole other ball of wax (and shouldn't cause regressions
like the printk ones could).


-Olof
