Return-Path: <linux-kernel-owner+w=401wt.eu-S1032059AbXEHUQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032059AbXEHUQs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 16:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968245AbXEHUQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 16:16:46 -0400
Received: from smtp104.plus.mail.re2.yahoo.com ([206.190.53.29]:25592 "HELO
	smtp104.plus.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S964974AbXEHUQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 16:16:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=xoeSlPVknfbf6PaKW7GogmrwwsABvwpWkPT9dTevCLgC/KuOrQYfy97+Kx/yotQ3vbkKAOJvM8AdmoO12mz+elyx5C22h+gTIaxxXe85XjZc75/GwqqoBY2VR2cFBrTcNoJxe5AAO0Y/5lr2qwLcUdAVWtlExPuwQFXkrE+1YQ4=  ;
X-YMail-OSG: q91qh58VM1mqM2IQvoO7U1p66V.Osb5X9EY95c_J6zGWSm94wbF_1j8dr5H3V7xPme4XmcPdWtXjU0WwB0iq7FnXM3pU8okzJ29vTtBk6m0w18drm89G4m.S9NBT0Wqi9kjRXuzN9UUzXA--
Date: Tue, 8 May 2007 22:16:38 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/macintosh: remove default y from Kconfig (was: Re: 2.6.21-mm1)
Message-ID: <20070508201638.GA5666@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
References: <20070505014955.8f3990b5.akpm@linux-foundation.org> <20070507103519.GA4725@gollum.tnic> <Pine.LNX.4.61.0705081028440.17280@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.61.0705081028440.17280@yvahk01.tjqt.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 10:33:22AM +0200, Jan Engelhardt wrote:
> 
> On May 7 2007 12:35, Borislav Petkov wrote:
> >
> >I don't think I need macintosh drivers for my x86 arch selected in by default,
> >  do I?
> 
> For new config variables that were introduced, I set them to 'default y'
> so when upgrading from an older .config, it does not deselect the drivers
> _inside_ the new menuconfig. People who have CONFIG_MAC_EMUMOUSEBTN=y
> will magically get it set to =n because MACINTOSH_DRIVERS is not y.
I had a similar suspicion that something else requires the default=y things ...

> Whether you need macintosh on i386... oh well, ask someone who knows.
> Fact is, that at least SUSE has CONFIG_MAC_EMUMOUSEBTN=y but I
> wonder wtf for.

Well, this is clearly wrong since it is only for a mac, single-button, mouse,
IMHO.  Look for CONFIG_MAC_EMUMOUSEBTN in drivers/char/keyboard.c

> >Index: trees/linux-mm/drivers/macintosh/Kconfig
> >===================================================================
> >--- linux-mm.orig/drivers/macintosh/Kconfig
> >+++ linux-mm/drivers/macintosh/Kconfig
> >@@ -2,7 +2,6 @@
> > menuconfig MACINTOSH_DRIVERS
> > 	bool "Macintosh device drivers"
> > 	depends on PPC || MAC || X86
> >-	default y
> 
> How about
> 	default y if PPC || MAC
> then?

sounds good, here we go:

-----
From: Borislav Petkov <bbpetkov@yahoo.de>

Do not select macintosh drivers by default.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>

--
Index: linux-mm/drivers/macintosh/Kconfig
===================================================================
--- linux-mm/drivers/macintosh/Kconfig.orig
+++ linux-mm/drivers/macintosh/Kconfig
@@ -2,7 +2,7 @@
 menuconfig MACINTOSH_DRIVERS
 	bool "Macintosh device drivers"
 	depends on PPC || MAC || X86
-	default y
+	default y if PPC || MAC

 if MACINTOSH_DRIVERS

-- 
Regards/Gruﬂ,
    Boris.
