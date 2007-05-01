Return-Path: <linux-kernel-owner+w=401wt.eu-S1031682AbXEAMMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031682AbXEAMMN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 08:12:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031686AbXEAMMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 08:12:13 -0400
Received: from wx-out-0506.google.com ([66.249.82.228]:4776 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031682AbXEAMML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 08:12:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=BRPrI9ipb9H90kusH+6r7vnMHTacXi3l0/i23bTo5ZBWsYwqUpzMYCpDTsZ8PXgdLnac1LY19SP33aCxr4bGdIWDBj9mi3QMAZUvAO5ED4TuX8AJTrUrVgnsn2TKsfzlX9DAaKPNYCquOvNIetntqY/kK564H0mZoTJxHXs3b40=
Subject: Re: console font limits
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Albert Cahalan <acahalan@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, aeb@cwi.nl, hpa@zytor.com
In-Reply-To: <Pine.LNX.4.64.0705011347300.27246@anakin>
References: <787b0d920704302109r352e6653wc71a0638cbfbdcce@mail.gmail.com>
	 <Pine.LNX.4.64.0705011347300.27246@anakin>
Content-Type: text/plain
Date: Tue, 01 May 2007 20:11:56 +0800
Message-Id: <1178021516.4372.62.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-01 at 13:49 +0200, Geert Uytterhoeven wrote:
> On Tue, 1 May 2007, Albert Cahalan wrote:
> > I'm having problems with a font I just created. It's a rather big one,
> > intended for a framebuffer console in UTF-8 mode. The strace program
> > reports that /bin/setfont fails on a KDFONTOP ioctl with EINVAL.
> > In reading the kernel code, I find this:
> > 
> > vt.c:static int con_font_set(struct vc_data *vc, struct console_font_op *op)
> > vt.c-{
> > vt.c-   struct console_font font;
> > vt.c-   int rc = -EINVAL;
> > vt.c-   int size;
> > vt.c-
> > vt.c-   if (vc->vc_mode != KD_TEXT)
> > vt.c-           return -EINVAL;
> > vt.c-   if (!op->data)
> > vt.c-           return -EINVAL;
> > vt.c-   if (op->charcount > 512)
> > vt.c-           return -EINVAL;
> > 
> > Ouch. Why is the old VGA limit being applied to the framebuffer console?
> > Could this just get removed? I dearly hope we aren't still storing the
> > framebuffer data as two bytes per character+attribute pair.
> 
> The shadow screen (accessed using scr_*()) still uses the old VGA
> format.

And this will entail a lot of work to change (Is it worth it to rework
the code and remove the limitation?). The linux-console project
(http://linuxconsole.sourceforge.net/) might have , but I don't know its
current status.

Tony


