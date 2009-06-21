Return-Path: <linux-kernel-owner+w=401wt.eu-S1754217AbZFUKSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbZFUKSl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 06:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752763AbZFUKS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 06:18:27 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:61398 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239AbZFUKS0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 06:18:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=d2JlSNV03BIgC9nU7J2unJiog9rDBNcm4RJuIAlYxPKPAChiCZmpIV43c6M+PspDSN
         EUBeBIwvhKycB0dL+t39FYsWTGS8/VwKVJZ71Gcpe0Zby31SkCBgT+gaozV7MEE2DPxC
         +EaziHFm7fc2DjIAz8DiOR6b6mKZ/5tdqYRBI=
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "Dmitry Eremin-Solenikov" <dbaryshkov@gmail.com>
Subject: Re: [PATCH 1/6] crc-itu-t: add bit-reversed calculation
Date: Sun, 21 Jun 2009 12:18:25 +0200
User-Agent: KMail/1.9.10
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
       davem@davemloft.net, Stephen Rothwell <sfr@canb.auug.org.au>,
       Sergey Lapin <slapin@ossfans.org>,
       Darren Salt <linux@youmustbejoking.demon.co.uk>
References: <1244021629-18409-1-git-send-email-dbaryshkov@gmail.com> <1244033004.21215.4.camel@deadeye> <20090621082921.GA12749@doriath.ww600.siemens.net>
In-Reply-To: <20090621082921.GA12749@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200906211218.25709.IvDoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[non-HTML reply, sorry about that]

On Sunday 21 June 2009, Dmitry Eremin-Solenikov wrote:
> Hi,
> 
> 
> On Wed, Jun 03, 2009 at 01:43:24PM +0100, Ben Hutchings wrote:
> > On Wed, 2009-06-03 at 13:33 +0400, Dmitry Eremin-Solenikov wrote:
> > [...] 
> > > +/**
> > > + * crc_itu_t_bitreversed - Compute the CRC-ITU-T for the data buffer;
> > > + * the buffer content is assumed to be bit-reversed
> > [...]
> > 
> > This short description spills onto two lines which is invalid and breaks
> > the generation of docs.  Sorry to point this out after recommending the
> > patch to you.
> > 
> > I've changed the description to "crc_itu_t_bitreversed - Compute the
> > CRC-ITU-T for a bit-reversed data buffer" all on one line.
> 
> Just another not w.r.t. this patch: one should add 'select BITREVERSE'
> to this Kconfig entry, as it depends on bitreversing stuff.

What also might be interesting,  have you checked the crc-ccitt algorithm?
I had come across a crc_itu_t with bitreverse implementation in the past as
well, and I could simplify the implementation by using crc-ccit and only call
bitreverse on the last output. So something like:

u16 crc = crc_ccitt(~0, data, len);
u16 crc_itu_t = swab16(crc);

Instead of bitreverse for every step, only a single  byteswap was needed.
You need to check if this indeed works for your driver, but this would
reduce the number of times bitrev is called, and also prevents the BITREV
dependency for the crc implementation.

Ivo
