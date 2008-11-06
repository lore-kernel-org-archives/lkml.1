Return-Path: <linux-kernel-owner+w=401wt.eu-S1754358AbYKFMIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358AbYKFMIO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 07:08:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753709AbYKFMIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 07:08:05 -0500
Received: from fall-pradero.atl.sa.earthlink.net ([207.69.195.104]:50051 "EHLO
	fall-pradero.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753570AbYKFMIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 07:08:04 -0500
X-Greylist: delayed 932 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Nov 2008 07:08:04 EST
Message-ID: <4912DA63.6050909@earthlink.net>
Date: Thu, 06 Nov 2008 06:52:03 -0500
From: Robert Reif <reif@earthlink.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.17) Gecko/20080829 SeaMonkey/1.1.12
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "David S. Miller" <davem@davemloft.net>,
       LKML <linux-kernel@vger.kernel.org>,
       "William L. Irwin" <wli@holomorphy.com>, sparclinux@vger.kernel.org
Subject: Re: tty warning
References: <20081106152421.a9cf964f.sfr@canb.auug.org.au>
In-Reply-To: <20081106152421.a9cf964f.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi Alan,
>
> A sparc allmodconfig build gives these warnings:
>
> drivers/char/n_tty.c: In function 'n_tty_poll':
> drivers/char/n_tty.c:1592: warning: array subscript is above array bounds
> drivers/char/n_tty.c:1601: warning: array subscript is above array bounds
> drivers/char/n_tty.c: In function 'n_tty_read':
> drivers/char/n_tty.c:1306: warning: array subscript is above array bounds
> drivers/char/tty_ioctl.c: In function 'set_termios':
> drivers/char/tty_ioctl.c:574: warning: array subscript is above array bounds
> drivers/char/tty_ioctl.c:578: warning: array subscript is above array bounds
> drivers/char/tty_ioctl.c: In function 'tty_mode_ioctl':
> drivers/char/tty_ioctl.c:729: warning: array subscript is above array bounds
> drivers/char/tty_ioctl.c:963: warning: array subscript is above array bounds
> drivers/char/tty_ioctl.c:969: warning: array subscript is above array bounds
> drivers/char/tty_ioctl.c:618: warning: array subscript is above array bounds
> drivers/char/tty_ioctl.c:1007: warning: array subscript is above array bounds
> drivers/char/tty_ioctl.c:1015: warning: array subscript is above array bounds
>
> These are things like:
>
>                 termios->c_cc[VTIME] = 0;
>
> termios is a (struct ktermios *) which has "cc_t c_cc[NCCS];".  NCCS is
> 17 and VTIME is also 17.  I assume the intention is to actually fill in
> _x_cc[0], but why is it done this way and not more directly?
>
>   
There is a patch here that fixes it:  
http://marc.info/?l=linux-sparc&m=122048348932653&w=2
