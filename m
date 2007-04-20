Return-Path: <linux-kernel-owner+w=401wt.eu-S1161258AbXDSX5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161258AbXDSX5u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 19:57:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030829AbXDSX5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 19:57:49 -0400
Received: from mail-in-08.arcor-online.net ([151.189.21.48]:40631 "EHLO
	mail-in-08.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161280AbXDSX5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 19:57:30 -0400
Subject: Re: [linux-dvb] Re: [video4linux-cvs] [hg:v4l-dvb] Add support for
	Opera S1- DVB-USB
From: hermann pitton <hermann-pitton@arcor.de>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Markus Rechberger <mrechberger@gmail.com>,
       Michael Krufky <mkrufky@linuxtv.org>, linux-dvb@linuxtv.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <4627FE4D.8010204@gmail.com>
References: <E1HeXiw-0001Ct-0o@www.linuxtv.org>
	 <4627858A.6060209@linuxtv.org>	 <4627B959.8070601@freenet.de>
	 <4627D407.10105@linuxtv.org>
	 <1177015513.6002.40.camel@matwk009568.brasiltelecom.intra.corp>
	 <4627D74A.4090304@gmail.com> <1177019927.3166.8.camel@pc06.localdom.local>
	 <4627F076.4050105@gmail.com>
	 <d9def9db0704191547l49358b74l9d81304f537fe6d6@mail.gmail.com>
	 <4627F283.6030009@gmail.com> <1177024610.4513.9.camel@pc06.localdom.local>
	 <4627F90A.40307@gmail.com> <1177025724.4513.16.camel@pc06.localdom.local>
	 <4627FE4D.8010204@gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Fri, 20 Apr 2007 02:00:52 +0200
Message-Id: <1177027252.4513.19.camel@pc06.localdom.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 (2.6.3-2.fc5) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 20.04.2007, 03:42 +0400 schrieb Manu Abraham:
> hermann pitton wrote:
> > Am Freitag, den 20.04.2007, 03:19 +0400 schrieb Manu Abraham:
> >> hermann pitton wrote:
> >>> Am Freitag, den 20.04.2007, 02:51 +0400 schrieb Manu Abraham:
> >>>> Markus Rechberger wrote:
> >>>>> On 4/20/07, Manu Abraham <abraham.manu@gmail.com> wrote:
> >>>>>> hermann pitton wrote:
> >>>>>>> Am Freitag, den 20.04.2007, 00:55 +0400 schrieb Manu Abraham:
> >>>>>>>> Mauro Carvalho Chehab wrote:
> >>>>>>>>> Em Qui, 2007-04-19 às 16:41 -0400, Michael Krufky escreveu:
> >>>>>>>>>> Marco Gittler wrote:
> >>>>>>>>>>> this patch has applied the hints from mkrufky (dvb_attach,
> >>>>>>>>>>> firmware-naming)
> >>>>>>>>>>> and also one working rewrite of the i2c addresses stuff to fit the
> >>>>>>>>>>> kernel i2c reqs.
> >>>>>>>>>>>
> >>>>>>>>>>> Signed-off-by: Marco Gittler<g.marco@freenet.de>
> >>>>>>>>>>> diff -r c8b73ec18b42 linux/drivers/media/dvb/dvb-usb/opera1.c
> >>>>>>>>>>> --- a/linux/drivers/media/dvb/dvb-usb/opera1.c    Thu Apr 19
> >>>>>> 12:04:50
> >>>>>> 2007 -0300
> >>>>>>>>>>> +++ b/linux/drivers/media/dvb/dvb-usb/opera1.c    Thu Apr 19
> >>>>>> 20:38:01
> >>>>>> 2007 +0200
> >>>>>>>>>>> @@ -25,6 +25,13 @@
> >>>>>>>>>>>  #define REG_20_SYMBOLRATE_BYTE1 0x20
> >>>>>>>>>>>  #define REG_21_SYMBOLRATE_BYTE2 0x21
> >>>>>>>>>>>
> >>>>>>>>>>> +#define ADDR_C0_TUNER (0xc0>>1)
> >>>>>>>>>>> +#define ADDR_D0_PLL (0xd0>>1)
> >>>>>>>>>>>
> >>>>>>>>>> I don't like these two #define's.  These i2c addresses need only be
> >>>>>>>>>> specified once, in the config structs / frontendfoo_attach calls for
> >>>>>> the
> >>>>>>>>>> tuner / demod.
> >>>>>>>>>>
> >>>>>>>>>> Better to just put them in as constants like all of the other dvb
> >>>>>> drivers.
> >>>>>>>>> I prefer the way it is. We should really avoid having magic numbers
> >>>>>>>>> inside the code. The alias here helps to know that 0x60 is tuner
> >>>>>> addres
> >>>>>>>>> and 0x68 the pll.
> >>>>>>>> Following a project's coding styles and conventions is "respecting" a
> >>>>>>>> project
> >>>>>>>>
> >>>>>>>> Manu
> >>>>>>>>
> >>>>>>> Hi,
> >>>>>>>
> >>>>>>> the other natural place for this should be the LKML to get more _good_
> >>>>>>> arguments, instead of hanging soon in some "respect" stuff again.
> >>>>>> DVB drivers generally have device addresses such as tuner_addresses and
> >>>>>> demod_adresses defined in a config struct least to prevent them from
> >>>>>> being global, wherever the header is included, since the very same
> >>>>>> device can have multiple addresses and so on, which are non-probable
> >>>>>> since being behind a repeater which is switched by a demod (private) and
> >>>>>> hence.
> >>>>>>
> >>>>>> Those are some of the reasons to follow a certain coding
> >>>>>> style/conventions. They are _not_ for fun.
> >>>>>>
> >>>>> cat *priv.h says something else too...
> >>>>> there are also many global register defines in DVB drivers, they just
> >>>>> don't include the register value in the define name.
> >>>> *_priv.h from what i understand means private .. i don't know what you
> >>>> make out from that.
> >>>>
> >>>>
> >>>> HTH,
> >>>> Manu
> >>> ;)
> >>>
> >>> That means that I had to post the actual headers to every single tester
> >> If you use a private header as a public header, of course yes. But that
> >> is not what private explicitly means.
> >> It _is_ indeed wrong to use a private header as a public header _even_
> >> for workarounds.
> >>
> >> HTH,
> >> Manu
> > 
> > Forget it.
> > 
> > That is as wrong as older Fedora distros were shipping v4l2 apps like
> > tvtime, but only providing v4l1 headers on the user level.
> > 
> 
> I don't know about Fedora shipping v4l2 apps.  Forgive my ignorance. But
> it is really hopeless to include a private header for a device into
> another device. Anyway not talking about V4L1/2/n headers, but about DVB
> device (demod/tuner) private headers being included publicly. Private
> means private, i don't understand how the notion comes around that a
> private header is a public header.
> 
> It is _not_ named private for no reason.
> 

The GPL was also not named GPL for no reason.

HTH,
Hermann


