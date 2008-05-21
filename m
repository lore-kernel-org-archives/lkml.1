Return-Path: <linux-kernel-owner+w=401wt.eu-S1762300AbYEUAxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762300AbYEUAxf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 20:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756699AbYEUAx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 20:53:27 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:44154 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755716AbYEUAx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 20:53:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=dedTjoJH5Ahj2kJ6I6a/dH6qIAyxuy/U5BLyEJ389a+GJysqrRA35YWRsDZuqTAVVlddgkcfjPoLIbs8B/VS2IxFNh6+XsCcmpcQMOupzbfjcRLtr8BkJIw6CH9A3VZzjzqg5hrwD8TBKfJLnZomsD4Fl0MslqUdtftBgDyBfqY=
Subject: Re: [PATCH] dvb-usb: unaligned
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Al Viro <viro@ftp.linux.org.uk>, mchehab@infradead.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
In-Reply-To: <20080521004717.GE28946@ZenIV.linux.org.uk>
References: <E1JycGL-0004x6-SF@ZenIV.linux.org.uk>
	 <1211330566.5915.230.camel@brick>
	 <20080521004717.GE28946@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Tue, 20 May 2008 17:53:23 -0700
Message-Id: <1211331203.5915.244.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-05-21 at 01:47 +0100, Al Viro wrote:
> On Tue, May 20, 2008 at 05:42:46PM -0700, Harvey Harrison wrote:
> > On Wed, 2008-05-21 at 01:33 +0100, Al Viro wrote:
> > > Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> > > ---
> > >  drivers/media/dvb/dvb-usb/dvb-usb-firmware.c |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-firmware.c b/drivers/media/dvb/dvb-usb/dvb-usb-firmware.c
> > > index e1112e3..733a7ff 100644
> > > --- a/drivers/media/dvb/dvb-usb/dvb-usb-firmware.c
> > > +++ b/drivers/media/dvb/dvb-usb/dvb-usb-firmware.c
> > > @@ -127,7 +127,7 @@ int dvb_usb_get_hexline(const struct firmware *fw, struct hexline *hx,
> > >  	if ((*pos + hx->len + 4) >= fw->size)
> > >  		return -EINVAL;
> > >  
> > > -	hx->addr = le16_to_cpu( *((u16 *) &b[1]) );
> > > +	hx->addr = b[1] | (b[2] << 8);
> > 
> > ???hx->addr = get_unaligned_le16(&b[1]);
> 
> Again, what's the benefit?  Having a function doesn't mean that we need
> to use it religiously - if it doesn't make things more clear...

Just curious, is gcc smart enough to just turn this into a 2-byte load
on x86 (little-endian with no particular alignment constraints).
Otherwise it would have a better chance at doing this using the helper
function.

You're right though, it is a small consideration.

Harvey



