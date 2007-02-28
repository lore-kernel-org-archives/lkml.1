Return-Path: <linux-kernel-owner+w=401wt.eu-S932267AbXB1Vd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267AbXB1Vd1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 16:33:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932274AbXB1Vd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 16:33:26 -0500
Received: from py-out-1112.google.com ([64.233.166.183]:62974 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932267AbXB1Vd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 16:33:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=N6WdIxk1f2vtxo0hDYAfBks5e7hPAtXl25qRKxi715I+3CHypGhEdfYk9NJCCviGdX91VcQvoKesCJGh0BvTd6Opl8H6RCevU6+lMnBIP/G4xybukTSBC7uOzMJH1m3Omyb2pHqxJksP0yT8xPg85jUKXsL2yvaHgJ7EuoQgg+k=
Subject: Re: [PATCH] fbdev driver for S3 Trio/Virge, updated
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: James Simmons <jsimmons@infradead.org>
Cc: Ondrej Zajicek <santiago@crfreenet.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       Jiri Slaby <jirislaby@gmail.com>
In-Reply-To: <Pine.LNX.4.64.0702281652290.14127@pentafluge.infradead.org>
References: <20070209193405.GB2637@localhost.localdomain>
	 <1172102733.4217.38.camel@daplas>
	 <Pine.LNX.4.64.0702220049320.17121@pentafluge.infradead.org>
	 <1172106505.4217.54.camel@daplas>
	 <Pine.LNX.4.64.0702281652290.14127@pentafluge.infradead.org>
Content-Type: text/plain
Date: Thu, 01 Mar 2007 05:35:28 +0800
Message-Id: <1172698528.21204.6.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-28 at 16:53 +0000, James Simmons wrote:
> > On Thu, 2007-02-22 at 00:53 +0000, James Simmons wrote:
> > > > > +/* image data is MSB-first, fb structure is MSB-first too */
> > > > > +static inline u32 expand_color(u32 c)
> > > > > +{
> > > > > +	return ((c & 1) | ((c & 2) << 7) | ((c & 4) << 14) | ((c & 8) << 21)) * 0xFF;
> > > > > +}
> > > > > +
> > > > > +/* s3fb_iplan_imageblit silently assumes that almost everything is 8-pixel aligned */
> > > > 
> > > > Hmn, same thing with vga16fb... Perhaps we should bring back the
> > > > fontwidth flag of 2.2 and 2.4 kernels.
> > > 
> > > Ug no. It is possible to get 12,6 bit width fonts working with vga 
> > > interleaved planes. I got it paritally working but never got back to it.
> > > Its in my queue of this to do. Now that I finished the display class I 
> > > need to get around to makeing drm/fbdev work together :-)
> > > 
> > 
> > Of course, not fontwidth exactly, but to allow the driver to specify the
> > alignment of the blit engine, in this case 8 pixels. I do believe X also
> > has similar functionality to compensate for the limitation of the
> > hardware.
> 
> Isn't scan_align in pixmap for this? Or do we need more.

No, scan_align is how much to pad each line, and it's up to the engine
to discard the padding.  In this case, the hardware does not allow
padding and must be given data in exact multiples. For example, vesafb
can accept 4x4 fonts padded to 8x4, but vga16fb will not be able to draw
4x4 fonts properly.

Tony

