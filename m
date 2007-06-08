Return-Path: <linux-kernel-owner+w=401wt.eu-S966428AbXFHAFB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966428AbXFHAFB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 20:05:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750968AbXFHAEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 20:04:50 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:56767 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753644AbXFHAEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 20:04:49 -0400
Date: Fri, 8 Jun 2007 02:04:55 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: jcm@jonmasters.org, Jan Engelhardt <jengelh@computergmbh.de>,
       Jesper Juhl <jesper.juhl@gmail.com>, Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@osdl.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.03
Message-ID: <20070608000455.GW5500@stusta.de>
References: <0a25fd03117c678f17006c5fcefaaed0@pinky> <9a8748490706060205y1fc8e354p4af7426fd76dd816@mail.gmail.com> <Pine.LNX.4.64.0706071622280.8762@fbirervta.pbzchgretzou.qr> <20070607193413.GR5500@stusta.de> <20070607232248.332edee8@the-village.bc.nu> <20070607232152.GU5500@stusta.de> <20070608004117.57868755@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070608004117.57868755@the-village.bc.nu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2007 at 12:41:17AM +0100, Alan Cox wrote:
> > I added a MODULE_AUTHOR("J. Ørsted <jorsted@foobar.com>") into the "raw" 
> > module:
> > 
> > # echo $LANG
> > C
> > # modinfo --version
> > module-init-tools version 3.3-pre11
> > # modinfo raw
> > filename:       /lib/modules/2.6.21.2/kernel/drivers/char/raw.ko
> > author:         J. Ã
> >                     ^ the cursor hangs here
> 
> "Mummy if I deliberately shoot myself in the head it hurts"
> 
> Distro's don't ship in C locale and haven't for years. And the worst case
> effect you can engineer by trying is to display some slightly odd symbols

If it would only display some slightly odd symbols I wouldn't complain.

The problem is that the second byte is interpreted as a control code.

Is there any trick to get the shell working again in this situation?
The cursor hangs, and I've not yet found a trick to do anything in this
xterm again (except for killing it from another xterm).

> (And incidentially since the Linux fs has been defined to be utf-8 for
> naming for many years you'll find the same problem using "ls")

No, "ls" can handle it perfectly:

# echo $LANG
C
# ls
??rsted
# 

Or:

$ echo $LANG
en_US
$ ls    
Ã?rsted
$ 

Different from the lsmod example, the cursor doesn't hang and the shell 
is usable after this command.

The difference is that "ls" expects and handles such issues while 
"lsmod" (and most likely also other userspace working with kernel 
output) does not yet handle it resulting in problems if bytes are 
wrongly interpreted as control codes.

> > - get module-init-tools fixed and
> > - document that 2.6.23 (or whichever will be the first kernel to support 
> >   UTF-8 in MODULE_AUTHOR) will require updated module-init-tools.
> 
> "Require" is a rather strong word for a print formatting issue specific
> to obscure setups.

See obove, it's not only "print formatting", it's "kills my shell".

> Alan

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

