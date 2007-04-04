Return-Path: <linux-kernel-owner+w=401wt.eu-S1752856AbXDDQR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856AbXDDQR1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 12:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753368AbXDDQR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 12:17:27 -0400
Received: from terminus.zytor.com ([192.83.249.54]:35728 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856AbXDDQR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 12:17:26 -0400
Message-ID: <4613CF6A.2090407@zytor.com>
Date: Wed, 04 Apr 2007 09:16:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, David Miller <davem@davemloft.net>,
       dwmw2@infradead.org, paulus@samba.org, alan@lxorguk.ukuu.org.uk,
       flar@allandria.com, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
References: <1175663999.2932.8.camel@shinybook.infradead.org> <17939.15726.114059.679277@cargo.ozlabs.ibm.com> <1175666635.2932.17.camel@shinybook.infradead.org> <20070404.011208.120446173.davem@davemloft.net> <20070404083803.GA13134@flint.arm.linux.org.uk> <20070404122154.GF31973@thunk.org>
In-Reply-To: <20070404122154.GF31973@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> 
> The other thing I would probably do if I were to do it all over again
> is allow serial devices to be named independent of /dev/ttySx
> interface, these days probably using /sysfs, so that you could easily
> query to figure out what serial controllers/cards were on the system,
> and assign specific controllers/ports to specific /dev/ttySx devices.
> We could also provide a registration system to allow on-line
> configuration of non-probeable serial cards attached to primitive
> buses that don't alllow probing, such as the ISA bus, although perhaps
> that's much less important in this day and age.
> 

One option would be to move the 8250-based serial ports, to, say, 
/dev/ttyN* (for National Semiconductors -- the best I could come up 
with) and redefine /dev/ttyS* as a serial port multiplexer which maps in 
all the types, for the ones that really want dynamic mapping.

Then the ones who want static mapping can still have them.  This would 
presumably work with early remapping in open(), similar to the way ptmx 
is done.

Of course, now you have the potential of aliasing, again, which tends to 
cause all kinds of headaches w.r.t. locking.  From that perspective, it 
would be better if udev made symlinks, and we made the kernel use some 
sort of discovery syntax for console= (say, "console=serial0" to hunt 
down the "first" serial port for some definition thereof.)

	-hpa
