Return-Path: <linux-kernel-owner+w=401wt.eu-S1758541AbXGMLqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758541AbXGMLqO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 07:46:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755171AbXGMLp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 07:45:59 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:4866 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755009AbXGMLp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 07:45:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=SMosy2dbCDYWZR1lFmbVOSdm5K7j3nMTCVoWhQhK8lxQzkkvXGFkzmhf0tvGsEYoPr/31Wi75CQSXRp9Pr4Bdd2RpnqbekPBgLNSLB2eI8b7CZ4nmuVyA5vK2WB3T3b5uGqOvGrvbxfnWjUW/2526dPzmg4MycDS2ed7j7XE1HA=
Subject: Re: [patch 2/4] fbdev: Add fb_append_extra_logo()
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
       James Simmons <jsimmons@infradead.org>,
       linux-fbdev-devel@lists.sourceforge.net, cbe-oss-dev@ozlabs.org,
       linux-kernel@vger.kernel.org,
       Geoff Levand <geoffrey.levand@am.sony.com>
In-Reply-To: <Pine.LNX.4.62.0707130855360.15603@pademelon.sonytel.be>
References: <20070710122702.765654000@pademelon.sonytel.be>
	 <20070710123540.678435000@pademelon.sonytel.be>
	 <1184285757.4566.11.camel@daplas>
	 <Pine.LNX.4.62.0707130855360.15603@pademelon.sonytel.be>
Content-Type: text/plain
Date: Fri, 13 Jul 2007 19:45:34 +0800
Message-Id: <1184327134.4702.6.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-13 at 08:56 +0200, Geert Uytterhoeven wrote:
> On Fri, 13 Jul 2007, Antonino A. Daplas wrote:
> > On Tue, 2007-07-10 at 14:27 +0200, Geert Uytterhoeven wrote:
> > > --- a/drivers/video/fbmem.c
> > > +++ b/drivers/video/fbmem.c
> > > @@ -318,6 +318,13 @@ static struct logo_data {
> > >  	const struct linux_logo *logo;
> > >  } fb_logo __read_mostly;
> > >  
> > > +#define FB_LOGO_EX_NUM_MAX 10
> > > +static struct logo_data_extra {
> > > +	const struct linux_logo *logo;
> > > +	unsigned int n;
> > > +} fb_logo_ex[FB_LOGO_EX_NUM_MAX];
> > > +static unsigned int fb_logo_ex_num;
> > > +
> > >  static void fb_rotate_logo_ud(const u8 *in, u8 *out, u32 width, u32 height)
> > >  {
> > >  	u32 size = width * height, i;
> > > @@ -411,10 +418,22 @@ static void fb_do_show_logo(struct fb_in
> > >  	}
> > >  }
> > >  
> > > +#ifdef CONFIG_FB
> > 
> > The #ifdef is redundant.
> 
> IIRC, it's needed for the CONFIG_FB=m case.

What would happen if CONFIG_FB=m? (We already have a patch that prevents
logo drawing if the driver or fbcon is modular)

Tony


