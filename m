Return-Path: <linux-kernel-owner+w=401wt.eu-S932466AbYEUAr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932466AbYEUAr1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 20:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756064AbYEUArT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 20:47:19 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41600 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbYEUArT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 20:47:19 -0400
Date: Wed, 21 May 2008 01:47:17 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Al Viro <viro@ftp.linux.org.uk>, mchehab@infradead.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] dvb-usb: unaligned
Message-ID: <20080521004717.GE28946@ZenIV.linux.org.uk>
References: <E1JycGL-0004x6-SF@ZenIV.linux.org.uk> <1211330566.5915.230.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1211330566.5915.230.camel@brick>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 05:42:46PM -0700, Harvey Harrison wrote:
> On Wed, 2008-05-21 at 01:33 +0100, Al Viro wrote:
> > Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> > ---
> >  drivers/media/dvb/dvb-usb/dvb-usb-firmware.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-firmware.c b/drivers/media/dvb/dvb-usb/dvb-usb-firmware.c
> > index e1112e3..733a7ff 100644
> > --- a/drivers/media/dvb/dvb-usb/dvb-usb-firmware.c
> > +++ b/drivers/media/dvb/dvb-usb/dvb-usb-firmware.c
> > @@ -127,7 +127,7 @@ int dvb_usb_get_hexline(const struct firmware *fw, struct hexline *hx,
> >  	if ((*pos + hx->len + 4) >= fw->size)
> >  		return -EINVAL;
> >  
> > -	hx->addr = le16_to_cpu( *((u16 *) &b[1]) );
> > +	hx->addr = b[1] | (b[2] << 8);
> 
> ???hx->addr = get_unaligned_le16(&b[1]);

Again, what's the benefit?  Having a function doesn't mean that we need
to use it religiously - if it doesn't make things more clear...
