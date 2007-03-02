Return-Path: <linux-kernel-owner+w=401wt.eu-S2992718AbXCBXHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992718AbXCBXHI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 18:07:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992720AbXCBXHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 18:07:07 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:27735 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992718AbXCBXHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 18:07:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=EwkBNSmISahdvb55jyCX3y/NxH0/ntBt4R9KDyGVZknQx8YmFqTSKlYHTXAXIsrZVWcPQd5OY5R/dy+xIbFnWin1m04+O+BYMRA2jRmm8wnmX9S+5d8rAUNtHJ3+NSy11aHGw24bQKJB6ckQLmTI8GqiP0iBxeYOPJFJ/7o1hfE=
Message-ID: <45E8ADB3.1010308@googlemail.com>
Date: Sat, 03 Mar 2007 00:05:23 +0100
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH -mm] char/epca.c remove unused function (was: Re: 2.6.21-rc2-mm1)
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>
In-Reply-To: <20070302030026.5eef0c92.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton napisał(a):
> Temporarily at
> 
>   http://userweb.kernel.org/~akpm/2.6.21-rc2-mm1/
> 

Please consider this patch for inclusion in >= 2.6.22.

"drivers/char/epca.c:2741: warning: 'get_termio' defined but not used"

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

--- linux-mm/drivers/char/epca.c	2007-03-02 15:15:59.000000000 +0100
+++ linux-work/drivers/char/epca.c	2007-03-02 18:30:27.000000000 +0100
@@ -209,7 +209,6 @@ static void digi_send_break(struct chann
 static void setup_empty_event(struct tty_struct *tty, struct channel *ch);
 void epca_setup(char *, int *);

-static int get_termio(struct tty_struct *, struct termio __user *);
 static int pc_write(struct tty_struct *, const unsigned char *, int);
 static int pc_init(void);
 static int init_PCI(void);
@@ -2362,15 +2361,6 @@ static int pc_ioctl(struct tty_struct *t

 	switch (cmd)
 	{ /* Begin switch cmd */
-
-#if 0	/* Handled by calling layer properly */
-		case TCGETS:
-			if (copy_to_user(argp, tty->termios, sizeof(struct ktermios)))
-				return -EFAULT;
-			return 0;
-		case TCGETA:
-			return get_termio(tty, argp);
-#endif
 		case TCSBRK:	/* SVID version: non-zero arg --> no break */
 			retval = tty_check_change(tty);
 			if (retval)
@@ -2735,13 +2725,6 @@ static void setup_empty_event(struct tty
 	memoff(ch);
 } /* End setup_empty_event */

-/* --------------------- Begin get_termio ----------------------- */
-
-static int get_termio(struct tty_struct * tty, struct termio __user * termio)
-{ /* Begin get_termio */
-	return kernel_termios_to_user_termio(termio, tty->termios);
-} /* End get_termio */
-
 /* ---------------------- Begin epca_setup  -------------------------- */
 void epca_setup(char *str, int *ints)
 { /* Begin epca_setup */

