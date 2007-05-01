Return-Path: <linux-kernel-owner+w=401wt.eu-S1030599AbXEALt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030599AbXEALt2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 07:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932184AbXEALt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 07:49:27 -0400
Received: from assei2bl6.telenet-ops.be ([195.130.133.69]:44283 "EHLO
	assei2bl6.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932247AbXEALt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 07:49:26 -0400
X-Greylist: delayed 10152 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 May 2007 07:49:26 EDT
Date: Tue, 1 May 2007 13:49:21 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Albert Cahalan <acahalan@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, aeb@cwi.nl, hpa@zytor.com
Subject: Re: console font limits
In-Reply-To: <787b0d920704302109r352e6653wc71a0638cbfbdcce@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0705011347300.27246@anakin>
References: <787b0d920704302109r352e6653wc71a0638cbfbdcce@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2007, Albert Cahalan wrote:
> I'm having problems with a font I just created. It's a rather big one,
> intended for a framebuffer console in UTF-8 mode. The strace program
> reports that /bin/setfont fails on a KDFONTOP ioctl with EINVAL.
> In reading the kernel code, I find this:
> 
> vt.c:static int con_font_set(struct vc_data *vc, struct console_font_op *op)
> vt.c-{
> vt.c-   struct console_font font;
> vt.c-   int rc = -EINVAL;
> vt.c-   int size;
> vt.c-
> vt.c-   if (vc->vc_mode != KD_TEXT)
> vt.c-           return -EINVAL;
> vt.c-   if (!op->data)
> vt.c-           return -EINVAL;
> vt.c-   if (op->charcount > 512)
> vt.c-           return -EINVAL;
> 
> Ouch. Why is the old VGA limit being applied to the framebuffer console?
> Could this just get removed? I dearly hope we aren't still storing the
> framebuffer data as two bytes per character+attribute pair.

The shadow screen (accessed using scr_*()) still uses the old VGA
format.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
