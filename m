Return-Path: <linux-kernel-owner+w=401wt.eu-S1757760AbYDWKDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757760AbYDWKDU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 06:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757574AbYDWJ5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 05:57:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40080
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758243AbYDWJ5U convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 05:57:20 -0400
Date: Wed, 23 Apr 2008 02:57:21 -0700 (PDT)
Message-Id: <20080423.025721.50367920.davem@davemloft.net>
To: michel@tungstengraphics.com
Cc: benh@kernel.crashing.org, linux-fbdev-devel@lists.sourceforge.net,
       hollisb@us.ibm.com, adaplas@gmail.com, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, akpm@linux-foundation.org, dzu@denx.de
Subject: Re: [Linux-fbdev-devel] [PATCH 1/3] radeonfb: Fix 64 bits
 resources on 32 bits archs
From: David Miller <davem@davemloft.net>
In-Reply-To: <1208943127.5632.324.camel@thor.sulgenrain.local>
References: <480E0A54.9010203@linux.vnet.ibm.com>
	<1208902903.9640.138.camel@pasglop>
	<1208943127.5632.324.camel@thor.sulgenrain.local>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michel Dänzer <michel@tungstengraphics.com>
Date: Wed, 23 Apr 2008 11:32:07 +0200

> On Wed, 2008-04-23 at 08:21 +1000, Benjamin Herrenschmidt wrote:
> > On Tue, 2008-04-22 at 17:55 +0200, Christian Ehrhardt wrote:
> > > I wanted to ask if there are any known workarounds atm that would
> > > allow me to use my X11 for now?
> > 
> > X is doing a mmap of /dev/mem instead of /dev/fb ?
> > 
> > You can normally map the fb mapping /dev/fb and then map the registers
> > using /dev/fb at an offset beyond the framebuffer (fix->smem_len).
> > 
> > If X is using /dev/mem instead, then it's being stupid and needs to be
> > fixed...
> 
> It's up to the driver, and again, the current radeon driver doesn't use
> radeonfb at all anymore...

The only portable thing is for X to use the PCI sysfs mmap() stuff,
which current Xorg servers using libpciaccess do.

I know because I'm typing this from a sparc64 using a Radeon
with current Xorg :-)
