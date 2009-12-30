Return-Path: <linux-kernel-owner+w=401wt.eu-S1751716AbZL3HPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716AbZL3HPU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 02:15:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750708AbZL3HPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 02:15:19 -0500
Received: from smtp.witbe.net ([81.88.96.48]:45514 "EHLO smtp.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750701AbZL3HPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 02:15:18 -0500
Date: Wed, 30 Dec 2009 08:13:55 +0100
From: Paul Rolland <rol@as2917.net>
To: Len Brown <lenb@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Matthew Garrett <mjg@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, rol@witbe.net
Subject: Re: -tip: origin tree boot crash
Message-ID: <20091230081355.7e135b2f@tux.DEF.witbe.net>
In-Reply-To: <alpine.LFD.2.00.0912300110080.15839@localhost.localdomain>
References: <alpine.LFD.2.00.0912241350510.11961@localhost.localdomain>
	<20091225102731.GA25513@elte.hu>
	<alpine.LFD.2.00.0912261504460.4089@localhost.localdomain>
	<alpine.LFD.2.00.0912262316530.14053@localhost.localdomain>
	<20091228094444.GG24690@elte.hu>
	<20091228120125.GA10911@elte.hu>
	<20091228160212.1f70d825@tux.DEF.witbe.net>
	<20091228175301.4e89aa65@tux.DEF.witbe.net>
	<alpine.LFD.2.00.0912300110080.15839@localhost.localdomain>
Organization: AS2917.net
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWsjH1VRjFydFciEg3a1tJxUEM6OCB1zdsDAAACcElEQVQ4jV2Tu3LcMAxFEY7SG/KQNYlY2685Zi1rmF5kQteBNcL/f0JAacfZDUscARePK9itY3Q4Qu5vplJKIFsrvI0t7Ii/8/nmQsERtgJpHAtiGW4ggylOAwhXTxPi0xfIcxDrZIc3qhMGD/kfKdwBExZrAf6l5PeC/Al7cAGfAGD+AgvL5yckcsxegVmG+QZRPgnYXnFUMAC8DLd6QZhAxj6dRo6vT/JNkmZQmPyDtoroMkD2VlaVgHsw2QrCAf1jPM+ou2Ju1j/G8+xINfZT+zGDPDjr7H/xnKewgi6SO4D7zloYoRDafSoogmirP0t9YIOJnN2ibDEKK6zDoSEjTIFXDcYYkwizoO/AjkATm3g+JVsSXPOCZIHwj7uBo2Bi97RMOoflJ4n3b3dvS2kVXDQupjvAk7zvaMEJlu0OJDFy4SsCusRbL95jRynY0LIA/rpyxCMkJ1ie+bWoEy+MG7pzDE3k8Z2C1a5eUdxmi0adGi2mdVjyUr2uvamrW9EeuLTCY84/AUjBj40LtqYbbM23vqolA2mpj5g03gparH45DqBgmsBK2hU0x662+QQLVYJLitxTnHB7yf0es4rraS/xqKW/hF1zPg9lOijpmtIBVrWKOQ6oTSkQjh3YtnarHQc0RrtS1XjtbQnScPrLeNKM6iS+6Qz6e9mVoPvaHHPU6eP5aKu1Ifd2QQvp6EA1bLaP3VREwewXY73xgLppBR2tg4LFg9lXzegHQlusWuxwogLCaswJ+qunQ2cyfuziX6B1p0E26nQazR3Qn2jQarRXVVZT9zP3uB5FV6pNjQG+u03ugbalEsEXqo7/AjAH60VpvOMvAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Len,

On Wed, 30 Dec 2009 01:14:48 -0500 (EST)
Len Brown <lenb@kernel.org> wrote:

> Thanks for the quick test/debug Paul,
> 
> > Fixed this completely with the following two patches on top of
> > 2.6.33-rc2 :
> > 
> > --- wmi.c.orig  2009-12-28 17:27:15.000000000 +0100
> > +++ wmi.c       2009-12-28 17:39:01.000000000 +0100
> > @@ -488,12 +488,13 @@
> >  {
> >         struct wmi_block *block;
> >         acpi_status status;
> > +       bool err;
> >  
> >         if (!guid || !handler)
> >                 return AE_BAD_PARAMETER;
> >  
> > -       find_guid(guid, &block);
> > -       if (!block)
> > +       err = find_guid(guid, &block);
> > +       if (!err)
> 
> Unfortunately, find_guid() returns 1 for success
> and 0 for failure, making this code look backwards.
> 
> I've applied this, but changed it to if (!find_guid())
> to be consistent with the other callers.

That's ok, thanks for reviewing !

> > --- dell-wmi.c.orig     2009-12-28 17:49:09.000000000 +0100
> > +++ dell-wmi.c  2009-12-28 17:41:36.000000000 +0100
> > @@ -343,7 +343,7 @@
> >                 printk(KERN_ERR
> >                         "dell-wmi: Unable to register notify handler -
> > %d\n", err);
> > -               return err;
> > +               return -err;
> 
> This change is not quite correct,
> but the correct fix is already in the acpi-test tree in the patch
> "dell-wmi: sys_init_module: 'dell_wmi'->init suspiciously returned 21,
> it should follow 0/-E convention"

Yes, Dmitry sent a mail indicating that yesterday. I must admit I've been
too fast with that part of my fix ,(

> I'll reply with both of the patches in a sec.
> Please let me know if they are sufficient to fix your system.

They are. You can add a :
Tested-by: Paul Rolland <rol@as2917.net>
for what it matters ;)

Paul
