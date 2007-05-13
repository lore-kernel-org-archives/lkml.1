Return-Path: <linux-kernel-owner+w=401wt.eu-S1758796AbXEMK5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758796AbXEMK5o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 06:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757421AbXEMK5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 06:57:36 -0400
Received: from n10.bullet.re3.yahoo.com ([68.142.237.123]:39494 "HELO
	n10.bullet.re3.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757358AbXEMK5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 06:57:35 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 971288.70721.bm@rrr4.mail.re1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=bgeWFqoN2wZ8BLAgmRe8ElV3unTqhu+atonLOZ+6CeFNErLU9ODH2tawNhBUk/UasLdvGdjFj1En3mm83/kUBRljC76s6QlJQ6lR8VltSP5y9TU0j4Oh4GKKb/WtiNf1+1487S5dKfKS9pHWzOrpgb332DHmtStMdSRcv2qxGm4=;
X-YMail-OSG: YPjmoHUVM1mU5kYy2ueDbOzJ.cAIFrwSiBwAqyUihPLs2NPGutomd_XL8hNPhb6KEEA7K0QQ4fFwu4y9j4rHVke.7A--
Date: Sun, 13 May 2007 03:57:34 -0700 (PDT)
From: Tear <tarrqt@yahoo.com>
Subject: Re: Dell Optiplex GX240, ACPI and APIC
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070512103441.a21194fc.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <897169.90621.qm@web63615.mail.re1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sat, 12 May 2007 07:04:25 -0700 (PDT) Tear <tarrqt@yahoo.com> wrote:
> 
> > Summary: If ACPI is not enabled but APIC is,
> > then there is trouble on Dell Optiplex GX240.
> > If both are enabled or if both are disabled, then
> > everything is fine. The attached patch removes
> > Dell Optiplex GX240 from the ACPI blacklist.
> > 
> > ---
> > 
> > Hello,
> > 
> > I have a Dell Optiplex GX240 and when I boot Linux, ACPI
> > gets set up by only acpi=ht. dmesg shows the following line:
> > 
> >    DELL GX240 detected: force use of acpi=ht
> > 
> > Everything seemed to be fine. However, I discovered that
> > everything is not fine. The USB controller works so slowly
> > that copying a few (uncached) 1 megabyte large photos from
> > a USB-enabled digital camera takes many minutes instead of
> > a couple of seconds.
> > 
> > I am using Linux 2.6.21.1 on a Debian 4.0 ("Etch") system.
> > 
> > I thought that this might be related to ACPI. So I tried
> > to boot with _only_ "acpi=force" appended to the kernel
> > command line. Voila, the USB controller started to work
> > at full speed and copying photos from my digital camera
> > took only seconds.
> > 
> > I tested the system with "acpi=force" and could not find
> > anything which did not work. So, can we please remove
> > Dell Optiplex GX240 from the blacklist in
> > 
> > ..../arch/i386/kernel/acpi/boot.c
> > 
> > ? The attached patch does just that: It removes Dell
> > Optiplex GX240 from the ACPI blacklist.
> > 
> > I thought that this might be related to interrupts and
> > APIC as well. (Note that this is APIC, not ACPI.) I tried
> > booting with _only_ "noapic" and "nolapic" appended to the
> > command line. Again, the USB controller started to work
> > at full speed.
> > 
> > If removing Dell Optiplex GX240 from the ACPI blacklist
> > is not wanted/possible, then is there a way to disable
> > APIC and LAPIC (note that this is APIC not ACPI) by
> > default on Dell GX240 machines? (I.e. Can one patch
> > the kernel so that APIC and LAPIC isn't used on
> > these machines? - I know that I can use the noapic
> > and nolapic options on the kernel command line.)
> > 
> > Thank you for your attention.
> > 
> > - Tear
> > 
> > Note: Please include me in CC of your replies.
> > 
> > 
> > --- linux-2.6.21.1.orig/arch/i386/kernel/acpi/boot.c	2007-05-01 17:10:30.000000000 +0300
> > +++ linux-2.6.21.1/arch/i386/kernel/acpi/boot.c	2007-05-01 20:31:53.000000000 +0300
> > @@ -971,14 +971,6 @@
> >  	 },
> >  	{
> >  	 .callback = force_acpi_ht,
> > -	 .ident = "DELL GX240",
> > -	 .matches = {
> > -		     DMI_MATCH(DMI_BOARD_VENDOR, "Dell Computer Corporation"),
> > -		     DMI_MATCH(DMI_BOARD_NAME, "OptiPlex GX240"),
> > -		     },
> > -	 },
> > -	{
> > -	 .callback = force_acpi_ht,
> >  	 .ident = "HP VISUALIZE NT Workstation",
> >  	 .matches = {
> >  		     DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),
> > 
> 
> Thanks.  Let's cc the acpi list.
> 
> The origin of that blacklist entry appears to be lost in the mists of time.
> git-blame got tripped up by an intervening Lindent run and my gittiness
> is insufficient for tracking changes before that.
> 

Mr. Morton,

I have already sent a very similar e-mail to the linux-acpi
mailing list. Please see the following for that:

http://marc.info/?l=linux-acpi&m=117856470816834&w=2

I haven't received a reply and that is why sent this e-mail
to the linux-kernel mailing list.

I would be very pleased to see the removal of Dell Optiplex
GX240 from the ACPI blacklist.

Is there a blacklist for APIC? (Note that this is APIC,
not ACPI.)

Thank you.

Tear



       
____________________________________________________________________________________Boardwalk for $500? In 2007? Ha! Play Monopoly Here and Now (it's updated for today's economy) at Yahoo! Games.
http://get.games.yahoo.com/proddesc?gamekey=monopolyherenow  

