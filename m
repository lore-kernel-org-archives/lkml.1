Return-Path: <linux-kernel-owner+w=401wt.eu-S1754265AbXDSWrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265AbXDSWrh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 18:47:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754268AbXDSWrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 18:47:37 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:45128 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253AbXDSWrg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 18:47:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NFfGRn9JWCW6iWdi/rK3/TIsTlQYARj5VlFYaesisIc5oDWI3ibBRTx3UwQWqC3mHzFWEi//Drnb4HaqaAaU3zfSPxhFMqVEaOJ7G1Mk/h8D9jyKzzN9Z7HzLxIMWBn9krdvIAO+x6vcNcfvxcEofcGMro7b/FNuHzH/xqCFf9c=
Message-ID: <d9def9db0704191547l49358b74l9d81304f537fe6d6@mail.gmail.com>
Date: Fri, 20 Apr 2007 00:47:35 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Manu Abraham" <abraham.manu@gmail.com>
Subject: Re: [linux-dvb] Re: [video4linux-cvs] [hg:v4l-dvb] Add support for Opera S1- DVB-USB
Cc: "hermann pitton" <hermann-pitton@arcor.de>,
       "Michael Krufky" <mkrufky@linuxtv.org>, linux-dvb@linuxtv.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <4627F076.4050105@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <E1HeXiw-0001Ct-0o@www.linuxtv.org> <4627858A.6060209@linuxtv.org>
	 <4627B959.8070601@freenet.de> <4627D407.10105@linuxtv.org>
	 <1177015513.6002.40.camel@matwk009568.brasiltelecom.intra.corp>
	 <4627D74A.4090304@gmail.com>
	 <1177019927.3166.8.camel@pc06.localdom.local>
	 <4627F076.4050105@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/20/07, Manu Abraham <abraham.manu@gmail.com> wrote:
> hermann pitton wrote:
> > Am Freitag, den 20.04.2007, 00:55 +0400 schrieb Manu Abraham:
> >> Mauro Carvalho Chehab wrote:
> >>> Em Qui, 2007-04-19 às 16:41 -0400, Michael Krufky escreveu:
> >>>> Marco Gittler wrote:
> >>>>> this patch has applied the hints from mkrufky (dvb_attach,
> >>>>> firmware-naming)
> >>>>> and also one working rewrite of the i2c addresses stuff to fit the
> >>>>> kernel i2c reqs.
> >>>>>
> >>>>> Signed-off-by: Marco Gittler<g.marco@freenet.de>
> >>>>> diff -r c8b73ec18b42 linux/drivers/media/dvb/dvb-usb/opera1.c
> >>>>> --- a/linux/drivers/media/dvb/dvb-usb/opera1.c	Thu Apr 19 12:04:50
> 2007 -0300
> >>>>> +++ b/linux/drivers/media/dvb/dvb-usb/opera1.c	Thu Apr 19 20:38:01
> 2007 +0200
> >>>>> @@ -25,6 +25,13 @@
> >>>>>  #define REG_20_SYMBOLRATE_BYTE1 0x20
> >>>>>  #define REG_21_SYMBOLRATE_BYTE2 0x21
> >>>>>
> >>>>> +#define ADDR_C0_TUNER (0xc0>>1)
> >>>>> +#define ADDR_D0_PLL (0xd0>>1)
> >>>>>
> >>>> I don't like these two #define's.  These i2c addresses need only be
> >>>> specified once, in the config structs / frontendfoo_attach calls for
> the
> >>>> tuner / demod.
> >>>>
> >>>> Better to just put them in as constants like all of the other dvb
> drivers.
> >>> I prefer the way it is. We should really avoid having magic numbers
> >>> inside the code. The alias here helps to know that 0x60 is tuner addres
> >>> and 0x68 the pll.
> >>
> >> Following a project's coding styles and conventions is "respecting" a
> >> project
> >>
> >> Manu
> >>
> >
> > Hi,
> >
> > the other natural place for this should be the LKML to get more _good_
> > arguments, instead of hanging soon in some "respect" stuff again.
>
>
> DVB drivers generally have device addresses such as tuner_addresses and
> demod_adresses defined in a config struct least to prevent them from
> being global, wherever the header is included, since the very same
> device can have multiple addresses and so on, which are non-probable
> since being behind a repeater which is switched by a demod (private) and
> hence.
>
> Those are some of the reasons to follow a certain coding
> style/conventions. They are _not_ for fun.
>

cat *priv.h says something else too...
there are also many global register defines in DVB drivers, they just
don't include the register value in the define name.

Markus
