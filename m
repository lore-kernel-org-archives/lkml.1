Return-Path: <linux-kernel-owner+w=401wt.eu-S1757971AbXGWQCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971AbXGWQCn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 12:02:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759026AbXGWQCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 12:02:24 -0400
Received: from smtp113.plus.mail.re1.yahoo.com ([69.147.102.76]:25803 "HELO
	smtp113.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758554AbXGWQCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 12:02:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=nOGeOcfVUH8dJ4cJWoy4IxuQ7ekWbRtl6XKzZATI3Mu30MP7LHiQQ1TrU/NqU+8ntsAlgGVygGnRiah+15doCXHBu+vmhWYxO4p5VOUJcRgkgqMr1/SxxVVn0DaJy4FPi9trC/Ug1YqNEibgYDTlI3sfPSUd9Zrk58eQxGXu9/A=  ;
X-YMail-OSG: 1gYNYrcVM1lxoRu4Z0jpRnPH7cCYwGEIQC6wjsGSiLLQKkYCLLT0wqhyh6MD_ZaEOgWqR648lw--
Date: Mon, 23 Jul 2007 18:01:46 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Adrian Bunk <bunk@stusta.de>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [PATCH] usb/atm: fix Kconfig garbage
Message-ID: <20070723160145.GB8525@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
References: <20070723065604.GA8525@gollum.tnic> <20070723115329.GH26212@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070723115329.GH26212@stusta.de>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2007 at 01:53:30PM +0200, Adrian Bunk wrote:
> On Mon, Jul 23, 2007 at 08:56:04AM +0200, Borislav Petkov wrote:
> > Hi there,
> > 
> > I don't know whether this is the proper Kconfig-way to fix this but it works ok here.
> > 
> > ----
> > When entered, the menu point "USB DSL modem support" in menuconfig, path [Device Drivers->USB
> > Support] shows no entries but "^@" instead. The following fixes it.
> > 
> > Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
> > 
> > --
> > --- linux-2.6.23-rc1/drivers/usb/atm/Kconfig.orig	2007-07-23 08:27:29.000000000 +0200
> > +++ linux-2.6.23-rc1/drivers/usb/atm/Kconfig	2007-07-23 08:50:55.000000000 +0200
> > @@ -7,7 +7,8 @@ menu "USB DSL modem support"
> >  
> >  config USB_ATM
> >  	tristate "USB DSL modem support"
> > -	depends on USB && ATM
> > +	depends on USB
> > +	select ATM
> >  	select CRC32
> >  	default n
> >  	help
> 
> This would break the compilation with CONFIG_NET=n.

Aha, so the logic behind it is that this submenu should be displayed in kconfig only if ATM 
is selected. Ok, I get it, thanks.

-- 
Regards/Gruﬂ,
    Boris.
