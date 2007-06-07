Return-Path: <linux-kernel-owner+w=401wt.eu-S937326AbXFGXtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937326AbXFGXtR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 19:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764544AbXFGXtC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 19:49:02 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:56754 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763962AbXFGXtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 19:49:00 -0400
Date: Fri, 8 Jun 2007 01:49:06 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, jcm@jonmasters.org
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Jesper Juhl <jesper.juhl@gmail.com>, Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@osdl.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.03
Message-ID: <20070607234906.GV5500@stusta.de>
References: <0a25fd03117c678f17006c5fcefaaed0@pinky> <9a8748490706060205y1fc8e354p4af7426fd76dd816@mail.gmail.com> <Pine.LNX.4.64.0706071622280.8762@fbirervta.pbzchgretzou.qr> <20070607193413.GR5500@stusta.de> <20070607232248.332edee8@the-village.bc.nu> <20070607232152.GU5500@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070607232152.GU5500@stusta.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2007 at 01:21:52AM +0200, Adrian Bunk wrote:
>...
> I added a MODULE_AUTHOR("J. Ørsted <jorsted@foobar.com>") into the "raw" 
> module:
> 
> # echo $LANG
> C
> # modinfo --version
> module-init-tools version 3.3-pre11
> # modinfo raw
> filename:       /lib/modules/2.6.21.2/kernel/drivers/char/raw.ko
> author:         J. Ã
>                     ^ the cursor hangs here
>...

If anyone's wondering what's happening:

The UTF-8 representation of the character Ø consists of the two bytes
  0xC3 0x98

In the ISO/IEC 8859 encodings where every character is represented by 
one bytes this corresponds to two characters:

In ISO/IEC 8859-1 the byte 0xC3 represents the character Ã resulting in 
the (harmless) display of this wrong character.

But in all the ISO/IEC 8859 encodings, the byte 0x98 is the 
_control code_ "Start of String".

Therefore, if we want start using UTF-8 anywhere into the kernel, we 
must ensure that all applications correctly convert all characters 
if running in a non-UTF-8 environment.

I'm not sure that's worth the hassle.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

