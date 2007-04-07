Return-Path: <linux-kernel-owner+w=401wt.eu-S965736AbXDGKOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965736AbXDGKOd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 06:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965739AbXDGKOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 06:14:33 -0400
Received: from max.feld.cvut.cz ([147.32.192.36]:38775 "EHLO max.feld.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965736AbXDGKOc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 06:14:32 -0400
From: CIJOML <cijoml@volny.cz>
To: "Markus Rechberger" <mrechberger@gmail.com>
Subject: Re: kernel OOPSes when changing DVB-T adapter in 2.6.21-rc3
Date: Sat, 7 Apr 2007 12:14:12 +0200
User-Agent: KMail/1.9.5
Cc: "Oliver Neukum" <oneukum@suse.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <200703091641.54249.cijoml@volny.cz> <200703161025.44681.oneukum@suse.de> <d9def9db0704061258v47d4cf5dwaac39625e8d00150@mail.gmail.com>
In-Reply-To: <d9def9db0704061258v47d4cf5dwaac39625e8d00150@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200704071214.13210.cijoml@volny.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I can confirm this fixes problem.
Please include into 2.6.21

Michal

Dne pátek 06 duben 2007 21:58 Markus Rechberger napsal(a):
> I committed a patch which fixes this issue:
>
> http://mcentral.de/hg/~mrec/v4l-dvb-stable/
>
> That problem got caused by releasing data structures which are still
> in use when the device gets unplugged. These patches delay the
> deallocation of the data till the last user releases its reference to
> the dvb nodes.
>
> This patch got tested with devices which use the dvb-usb framework as
> well as em28xx based dvb devices.
>
> Markus
>
> On 3/16/07, Oliver Neukum <oneukum@suse.de> wrote:
> > Am Freitag, 16. März 2007 10:13 schrieb CIJOML:
> > > Hi,
> > >
> > > looks like more general problem with 2.6.21-rc3. This happens when I
> >
> > remove my
> >
> > > PCMCIA USB2.0/IEEE1384 adapter from slot:
> >
> > Yes, the more important it is to know whether -rc2 works.
> > And please report this as a generic sysfs failure to lkml.
> >
> > 	Regards
> > 		Oliver
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> > in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
