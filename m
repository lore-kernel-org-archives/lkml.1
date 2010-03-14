Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934051Ab0CNVXy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 17:23:54 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50220
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932349Ab0CNVXv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 17:23:51 -0400
Date: Sun, 14 Mar 2010 14:24:12 -0700 (PDT)
Message-Id: <20100314.142412.52181590.davem@davemloft.net>
To: geert@linux-m68k.org
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fbdev@vger.kernel.org
Subject: Re: [GIT]: Sparc
From: David Miller <davem@davemloft.net>
In-Reply-To: <10f740e81003140734p30959952ld4563d2b22d834af@mail.gmail.com>
References: <20100313.181754.107699673.davem@davemloft.net>
	<10f740e81003140734p30959952ld4563d2b22d834af@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Sun, 14 Mar 2010 15:34:03 +0100

> On Sun, Mar 14, 2010 at 03:17, David Miller <davem@davemloft.net> wrote:
>> David S. Miller (1):
>>      sparc64: Add very basic XVR-1000 framebuffer driver.
> 
> Have you ever looked into getting offb to work on sparc64?

Can't for several of these drivers.

For example, the svr500 comes up in some kind of striped plane mode so
we have to write every pixel to two planes of the frame buffer.

Also offb doesn't know the implied endianness of the framebuffer.  UPA
based framebuffers are typically big endian, whereas most (but not
all) PCI are little-endian.

I also intend to get these thing supporting accelerated at some
pointer.

offb looks like a big hack instead of something generic that
could support any framebuffer that adheres to the standard
openfirmware framebuffer device properties.  It's just using
a bunch of properties created internally by bootx.
