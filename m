Return-Path: <linux-kernel-owner+w=401wt.eu-S1752339AbXBYLIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339AbXBYLIP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 06:08:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752341AbXBYLIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 06:08:07 -0500
Received: from py-out-1112.google.com ([64.233.166.181]:38307 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbXBYLID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 06:08:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=XwDkaUq29l4gJpQYdLxGfPrPIRdAZetw4zg7eKkLexqd3SCTQfdlMIMiHRSlZI/14AHdtu1fCWejGgBdz97h2sD3DHDdNVXjR7czjTZPfNbQSWxNGk+QWkzKgU0ih8gGSvxDuil6c0CHgBJVz2cPz5aO2dB1vCLL4kl/HB/xPls=
Subject: Re: [Linux-fbdev-devel] [PATCH] nvidiafb: allow ignoring EDID info
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Cc: James Simmons <jsimmons@infradead.org>, Luca Tettamanti <kronos@people.it>,
       linux-fbdev-devel@lists.sourceforge.net, Andrew Morton <akpm@osdl.org>,
       Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <cb7bb73a0702250226k53369655vc9c4e5a71c337a8c@mail.gmail.com>
References: <ephv35$4i3$1@sea.gmane.org> <1172153358.4306.17.camel@daplas>
	 <cb7bb73a0702220755y3eb2e5b1r8e7908ae0c1720c9@mail.gmail.com>
	 <1172161290.4198.12.camel@daplas>
	 <cb7bb73a0702221108r161441ebt61886ce67746f389@mail.gmail.com>
	 <1172187249.4279.7.camel@daplas>
	 <cb7bb73a0702230534o4e2c7e9frd5f2b05accf18c05@mail.gmail.com>
	 <1172300694.4109.50.camel@daplas>
	 <cb7bb73a0702240116g33a9b5bv2e3668a536a70938@mail.gmail.com>
	 <1172351769.4415.5.camel@daplas>
	 <cb7bb73a0702250226k53369655vc9c4e5a71c337a8c@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 25 Feb 2007 19:10:25 +0800
Message-Id: <1172401825.6187.2.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-02-25 at 11:26 +0100, Giuseppe Bilotta wrote:
> On 2/24/07, Antonino A. Daplas <adaplas@gmail.com> wrote:
> > On Sat, 2007-02-24 at 10:16 +0100, Giuseppe Bilotta wrote:
> > >
> > > Keep in mind that setting nvidiafb to totally ignore the EDID (either
> > > by not compiling in EDID support or by using e.g. the ignoreedid patch
> > > I had proposed) the snow effect is extremely reduced,
> >
> > I did not know that, just scanned the entire thread. Try this patch, it
> > makes use of fb_ddc_read*() which I believe has extra steps to prevent
> > display corruption.  It also incorporates Luca's i2c fix.
> 
> Applied. No noticeable difference, in the sense that the EDID debug
> output is still the same and so is the snow effect.
> 

Here's a temporary workaround:

In drivers/video/nvidia/nv_i2c.c:nvidia_probe_i2c_connector(),comment
this out:

	if (par->chan[conn - 1].par)
		edid = fb_ddc_read(&par->chan[conn - 1].adapter);

and make sure CONFIG_FIRMWARE_EDID=y.

Tony

