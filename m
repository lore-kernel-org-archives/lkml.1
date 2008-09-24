Return-Path: <linux-kernel-owner+w=401wt.eu-S1755255AbYIXUsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255AbYIXUsp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 16:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754953AbYIXUsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 16:48:01 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:37532 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754850AbYIXUr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 16:47:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=UcMMpqx8koQ8+Faj1bGxtSUfbC1SZMm/CGIbvEuCSbAfzSXp/LufFofgdNNTAhne3Mv7LLMTkziJ4iK4clzJWF7LUfqNYS0eXVZADyOzlKILk8EbTsRBinybfOi4EuuC4zEG8oH5yOIaA2NUq2/PlOhCgvThweurPu2FyjEn6hQ=  ;
X-YMail-OSG: i9.JdloVM1lHVqezOWcDvOthoQDlG8LsDftzSqq5gZvlRJvJYB8vyQUqbhBTl0dH6QwAiWxc09xhhbC8kTYs39P1ZJ_4FHkLX7.J8AE_sf1tHh9GENNXPhz5ggmDdYMkzzk-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] usb: add Freescale QE/CPM USB peripheral controller driver
Date: Wed, 24 Sep 2008 13:10:02 -0700
User-Agent: KMail/1.9.9
Cc: linuxppc-dev@ozlabs.org, Li Yang <leoli@freescale.com>, greg@kroah.com,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1219916613-28827-1-git-send-email-leoli@freescale.com> <200808281704.20999.arnd@arndb.de>
In-Reply-To: <200808281704.20999.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200809241310.03171.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 August 2008, Arnd Bergmann wrote:
> > +/*-------------------------------------------------------------------------
> > +     Gadget driver register and unregister.
> > + --------------------------------------------------------------------------*/
> > +int usb_gadget_register_driver(struct usb_gadget_driver *driver)
> > +EXPORT_SYMBOL(usb_gadget_register_driver);
> > +
> > +int usb_gadget_unregister_driver(struct usb_gadget_driver *driver)
> > +EXPORT_SYMBOL(usb_gadget_unregister_driver);
> 
> Not addressing this driver in particular, but the USB gadget layer in
> general: This is a horrible interface, since every gadget driver exports
> the same symbols, 

Bad terminology.  Gadget drivers are what sit on TOP of peripheral
controller drivers ... only peripheral controller drivers touch the
actual hardware registers.  They export an abstract "gadget" interface.

Gadget drivers are what talk *to* that abstract interface.


> you can never build a kernel that includes more than 
> one gadget driver. Even if the drivers are all built as modules, simply
> loading one of them prevents loading another one.

That's never been a particular requirement.  Systems won't get
USB branding if they have more than one USB peripheral (upstream)
port.  Supporting more than one type of controller hardware is
at best a pretty esoteric configuration.

If you really want to see such stuff ... -ENOPATCH.  :)

- Dave

