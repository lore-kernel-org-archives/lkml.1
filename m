Return-Path: <linux-kernel-owner+w=401wt.eu-S1752367AbXD1OLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367AbXD1OLv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 10:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752413AbXD1OLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 10:11:51 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:47777 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbXD1OLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 10:11:49 -0400
X-Originating-Ip: 74.109.98.66
Date: Sat, 28 Apr 2007 10:11:26 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: "Shan, Guo Wen (Gavin)" <gshan@alcatel-lucent.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: can a kmalloc be both GFP_ATOMIC and GFP_KERNEL at the same
 time?
In-Reply-To: <2AC135F730C4A045BAE4F1C1CB83FD4B03EF6F87@exch03.qd.lucent.com>
Message-ID: <Pine.LNX.4.64.0704281006380.25313@localhost.localdomain>
References: <2AC135F730C4A045BAE4F1C1CB83FD4B03EF6F87@exch03.qd.lucent.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Apr 2007, Shan, Guo Wen (Gavin) wrote:

>
> #define GFP_ATOMIC      (__GFP_HIGH)
> #define GFP_NOIO        (__GFP_WAIT)
> #define GFP_NOFS        (__GFP_WAIT | __GFP_IO)
> #define GFP_KERNEL      (__GFP_WAIT | __GFP_IO | __GFP_FS)
>
> -----Original Message-----
> From: Robert P. J. Day [mailto:rpjday@mindspring.com]
> Sent: Saturday, April 28, 2007 9:41 PM
> To: Linux Kernel Mailing List
> Subject: can a kmalloc be both GFP_ATOMIC and GFP_KERNEL at the same
> time?
>
>
>
>   i'd always assumed that the type flags of GFP_ATOMIC and GFP_KERNEL
> were mutually exclusive when it came to calling kmalloc(), at least
> based on everything i'd read.  so i'm not sure how to interpret the
> following:
>
> drivers/scsi/aic7xxx_old.c:  aic_dev = kmalloc(sizeof(struct aic_dev_data), GFP_ATOMIC | GFP_KERNEL);
> drivers/message/i2o/device.c:   resblk = kmalloc(buflen + 8, GFP_KERNEL | GFP_ATOMIC);
>
>   clarification?

oh, i'm *aware* of the definitions of those flags, but every single
source i've ever read has *strongly* suggested that you don't use
those two flags together so i was surprised to see those combinations.
(as an example, love's kernel book, p. 192, shows a table of valid
combinations of flags to use, but doesn't mention the one above.)

and, on the other hand, if they *are* legal to use together, i guess
i'm kind of surprised that there would be only two instances of it.

in any case, i'll just assume that the above is valid and i'll go back
to reading up on it until i convince myself.  thanks.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
