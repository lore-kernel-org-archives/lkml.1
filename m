Return-Path: <linux-kernel-owner+w=401wt.eu-S1756086AbXG1R70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086AbXG1R70 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 13:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751486AbXG1R7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 13:59:19 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:20046 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbXG1R7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 13:59:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=b/A3S1RBIzXvvk3QSFDunASXjJ4AUZRAZcQrBjN2ULnGemZzB3rNu/yuuvDoPtYQ1XTTH0pIPZexH9rLvmFRJOpGUKgLxVMuFusQt3lJs2WrFpFkHwCBeRU0rJm0uLamQnzey4ZRIZOG9xTM88Cwdq13fsypdRA0548vfW0VlA0=
Message-ID: <8b67d60707281059te706d4agc7923291021a0ffe@mail.gmail.com>
Date: Sat, 28 Jul 2007 18:59:17 +0100
From: "Adrian McMenamin" <lkmladrian@gmail.com>
To: "Ondrej Zajicek" <santiago@crfreenet.org>, linux-kernel@vger.kernel.org,
       "Antonino A. Daplas" <adaplas@gmail.com>, lethal@linux-sh.org
Subject: Re: [PATCH] Framebuffer: Fix 16bpp colour output in Dreamcast pvr2fb
In-Reply-To: <20070728171226.GA7247@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8b67d60707280751k76539f06t9a0feb67f2acdcb0@mail.gmail.com>
	 <20070728171226.GA7247@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/07/07, Ondrej Zajicek <santiago@crfreenet.org> wrote:
> On Sat, Jul 28, 2007 at 03:51:38PM +0100, Adrian McMenamin wrote:
> > Tony,
> >
> > This patch - on top of your others - fixes the colour output for 16bpp
> > RGB565 output in the Dreamcast - it was a simple out by one error in
> > the bit shift.
>
> > @@ -330,27 +331,28 @@ static int pvr2fb_setcolreg(unsigned int regno, unsigned int red,
> >           case 16: /* RGB 565 */
> >               tmp =  (red   & 0xf800)       |
> >                     ((green & 0xfc00) >> 5) |
> > -                   ((blue  & 0xf800) >> 11);
> > +                   ((blue  & 0xf800) >> 10);
>
> This mixes lsb of green with msb of blue. If you want RGB 565,
> then >> 11 is correct. If you want RGB 555, green should
> be anded with 0xf800.
>
You are, of course, quite right, which makes it all the more the
strange that it appeared to fix the problem. Back to the drawing board
then.
