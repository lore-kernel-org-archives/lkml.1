Return-Path: <linux-kernel-owner+w=401wt.eu-S1757372AbYBRHsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372AbYBRHsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 02:48:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754097AbYBRHsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 02:48:07 -0500
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:5103 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989AbYBRHsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 02:48:06 -0500
X-Greylist: delayed 2064 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Feb 2008 02:48:05 EST
Date: Mon, 18 Feb 2008 08:18:47 +0100
From: Krzysztof Helt <krzysztof.h1@poczta.fm>
To: linux-fbdev-devel@lists.sourceforge.net
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, avorontsov@ru.mvista.com,
       linuxppc-dev@ozlabs.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, adaplas@gmail.com
Subject: Re: [Linux-fbdev-devel] [PATCH 1/2] fb: add support for foreign
 endianness
Message-Id: <20080218081847.e9e65f2f.krzysztof.h1@poczta.fm>
In-Reply-To: <Pine.LNX.4.64.0802171030330.6848@anakin>
References: <20080205154432.GA8749@localhost.localdomain>
	<20080214224942.a0cb6218.akpm@linux-foundation.org>
	<20080215164542.GB16810@localhost.localdomain>
	<Pine.LNX.4.64.0802171030330.6848@anakin>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-EMID: 70e2b138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Feb 2008 10:44:32 +0100 (CET)
Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> On Fri, 15 Feb 2008, Anton Vorontsov wrote:
> > On Thu, Feb 14, 2008 at 10:49:42PM -0800, Andrew Morton wrote:
> > > On Tue, 5 Feb 2008 18:44:32 +0300 Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> > > Actually...  should CONFIG_FB_FOREIGN_ENDIAN exist, or should this feature
> > > be permanently enabled?
> > 
(...)
> 
> The notion of `FOREIGN_ENDIAN' is relative, as it depends on the
> architecture you're compiling for.
> 
> Suppose you have a PCI graphics card with a frame buffer that's always
> big endian. When compiling for a big endian platform, the driver won't
> depend on FB_FOREIGN_ENDIAN. When compiling for a little endian
> platform, it will.
> 
> Shouldn't we add LITTLE_ENDIAN and BIG_ENDIAN Kconfig vars first, just
> like we have 64BIT?
> 

I disagree here. The FOREIGN_ENDIAN is enough. It is determined only by
graphics chip endianess and CPU (arch) endianess.
I know two fb drivers which use endianess information (pm2fb and s3c2410fb).
Both resolve endianess at driver level. Actually, both handle it by setting special
bits so the graphics chip itself reorder bytes to transform foreign endianess. 
I understand that this patch is for chips which cannot reorder bytes by themselves.

So the FOREIGN_ENDIANESS flag should be set by the driver if it is needed
(if the graphics chip is BE and CPU is LE a simple #ifdef will add the flag).

> 
> I'd like to handle this in Kconfig (cfr. above).
> 

Again, it is possible. It is enough to put one rule which enables
the FOREIGN_ENDIAN if the architecture endianess is "foreign"
for the driver. The advantage here is that it  can be set only
for drivers which need it (as some driver can handle it without
this code). It should be hidden option set only internally if needed
(no user selectable).

I tested this patch on the s3c2410fb with disabled byte order
corrections by the graphics chip itself. It worked for 8-bit depth
but not for 16-bit depth (pixel position seemed ok but wrong tux'
colors). I will investigate. The s3c2410fb is BE and the kernel
was arm LE.

I would like to extend this patch to fb depths below 8-bit. The
s3c2410fb cannot handle this correctly with LE kernel.

Kind regards,
Krzysztof

----------------------------------------------------------------------
Masz ostatnia szanse !
Sprawdz >>> http://link.interia.pl/f1d02  

