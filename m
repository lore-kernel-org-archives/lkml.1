Return-Path: <linux-kernel-owner+w=401wt.eu-S1751726AbYDWJnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726AbYDWJnT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 05:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754781AbYDWJm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 05:42:59 -0400
Received: from gate.crashing.org ([63.228.1.57]:42213 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187AbYDWJm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 05:42:58 -0400
Subject: Re: [Linux-fbdev-devel] [PATCH 1/3] radeonfb: Fix 64 bits
	resources on 32 bits archs
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@tungstengraphics.com>
Cc: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
       linux-fbdev-devel@lists.sourceforge.net,
       Hollis Blanchard <hollisb@us.ibm.com>, adaplas@gmail.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Andrew Morton <akpm@linux-foundation.org>, Detlev Zundel <dzu@denx.de>,
       Wolfgang Denk <wd@denx.de>
In-Reply-To: <1208943127.5632.324.camel@thor.sulgenrain.local>
References: <20080422012723.BA9F2DE13F@ozlabs.org>
	 <480E0A54.9010203@linux.vnet.ibm.com>  <1208902903.9640.138.camel@pasglop>
	 <1208943127.5632.324.camel@thor.sulgenrain.local>
Content-Type: text/plain; charset=utf-8
Date: Wed, 23 Apr 2008 19:40:33 +1000
Message-Id: <1208943633.9060.26.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-04-23 at 11:32 +0200, Michel Dänzer wrote:
> > X is doing a mmap of /dev/mem instead of /dev/fb ?
> > 
> > You can normally map the fb mapping /dev/fb and then map the
> registers
> > using /dev/fb at an offset beyond the framebuffer (fix->smem_len).
> > 
> > If X is using /dev/mem instead, then it's being stupid and needs to
> be
> > fixed...
> 
> It's up to the driver, and again, the current radeon driver doesn't
> use
> radeonfb at all anymore...

Right. And I'm happy to go fix what remains, don't get me wrong here :-)
We all know how stupid legacy code can be !

I'll try to get some patches to expose a new version of the structure
sometimes in the upcoming week or two (we'll see what time permits) and
then see about fixing X drivers that need fixing, though hopefully with
pci-rework being upstream now, that shouldn't be many.

The main issue is directfb. I hope they'll catch up with the new ioctls.

Ben.


