Return-Path: <linux-kernel-owner+w=401wt.eu-S1756864AbYBIVvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864AbYBIVvR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 16:51:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753343AbYBIVvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 16:51:04 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:40157 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216AbYBIVvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 16:51:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=OdZz+trsYG4s1JBV2WsdV5Jb81nwPFIYmVOL7MUjCJw9zm5FjjU4dtg+Y+l4N8/g1h5JV2pT4bvl3uja0K4an6Q3m6svnzTHL3+vH3/E+PPTjKOW0e14FYl5tUbN0lYsq7wxpQoMZwZXy8ZOsxcqqZs1JhKmXIqyMGX8JvBlw9Y=
Message-ID: <2c0942db0802091351k6ceb2d28h9f9d5c0fb16e1484@mail.gmail.com>
Date: Sat, 9 Feb 2008 13:51:00 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Christoph Hellwig" <hch@infradead.org>
Subject: Re: [PATCH 1/8] kgdb: core API and gdb protocol handler
Cc: jason.wessel@windriver.com, linux-kernel@vger.kernel.org
In-Reply-To: <2c0942db0802091146v7b780b7dl4bd745caef900ae7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1202564114-18587-1-git-send-email-jason.wessel@windriver.com>
	 <1202564114-18587-2-git-send-email-jason.wessel@windriver.com>
	 <20080209172713.GD15568@infradead.org>
	 <2c0942db0802091146v7b780b7dl4bd745caef900ae7@mail.gmail.com>
X-Google-Sender-Auth: 0be1b841806901d1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/2/9 Ray Lee <ray-lk@madrabbit.org>:
> On Feb 9, 2008 9:27 AM, Christoph Hellwig <hch@infradead.org> wrote:
> > On Sat, Feb 09, 2008 at 07:35:07AM -0600, jason.wessel@windriver.com wrote:
> > > +#ifdef __BIG_ENDIAN
> > > +             *buf++ = hexchars[(tmp_s >> 12) & 0xf];
> > > +             *buf++ = hexchars[(tmp_s >> 8) & 0xf];
> > > +             *buf++ = hexchars[(tmp_s >> 4) & 0xf];
> > > +             *buf++ = hexchars[tmp_s & 0xf];
> > > +#else
> > > +             *buf++ = hexchars[(tmp_s >> 4) & 0xf];
> > > +             *buf++ = hexchars[tmp_s & 0xf];
> > > +             *buf++ = hexchars[(tmp_s >> 12) & 0xf];
> > > +             *buf++ = hexchars[(tmp_s >> 8) & 0xf];
> > > +#endif
> >
> > This is really ugly, but I don't really know a good way around it
> > either.
>
> void u32_to_hex(u32 val, unsigned char *buf)
> {
>          int i;
>
>          for (i=7; i>=0; i--) {
>                   buf[i] = hexchars[ val & 0x0f ];
>                   val >>= 4;
>          }
> }
>
>          u32_to_hex(tmp_s, buf);
>          buf += 8;
>

Sorry, rewrote what I thought I read, not what was there. I guess
you'd want it more along the lines of

   void u32_to_hex(u32 x, unsigned char *buf)
   {
          int i;
          int val = cpu_to_be32( x );

          for (i=7; ...
