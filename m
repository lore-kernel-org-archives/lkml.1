Return-Path: <linux-kernel-owner+w=401wt.eu-S1756644AbYCXXWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644AbYCXXWp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 19:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755438AbYCXXWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 19:22:35 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:40587 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbYCXXWe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 19:22:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FUcnx3uVyN2gICdoxSWeOWD7e6hQg8q45dOYhIjavbZyoVS1DDUnlOCKjZfg1DTtbIZCK5H45+peE/HQeF064AbCmR1rsA6BKwSEtBkKqe/etqmJtdIv9cLcTIw9CSoNWnK095exq/XUoD6dTut8fzDfEwgg2EHhKlBI6WWNkhI=
Message-ID: <21d7e9970803241622v10b887a6p869535102b486279@mail.gmail.com>
Date: Tue, 25 Mar 2008 09:22:32 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Tilman Schmidt" <tilman@imap.cc>
Subject: Re: [2.6.25-rc6] possible regression: X server dying
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <47E82D68.5070305@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <47E82D68.5070305@imap.cc>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 8:38 AM, Tilman Schmidt <tilman@imap.cc> wrote:
> In the five days since I booted a 2.6.25-rc6 kernel on my development
>  machine, it has happened three times already that I came back to the
>  machine to find that the X server had exited, killing all applications
>  that still had a window open. This has never happened with previous
>  kernel versions (2.6.22.17, 2.6.24.3, 2.6.25-rc5), so I suspect some
>  relation to the latest rc kernel.
>
>  Syslog entries around the time of the crash (identical each time):
>
>  Mar 24 21:59:57 xenon kernel: [424469.161592] PM: Removing info for No
>  Bus:vcs7
>  Mar 24 21:59:57 xenon kernel: [424469.162591] PM: Removing info for No
>  Bus:vcsa7
>  Mar 24 21:59:57 xenon kernel: [424469.179556] uhci_hcd 0000:00:1d.1:
>  release dev 4 ep81-INT, period 8, phase 4, 93 us
>  Mar 24 21:59:57 xenon gconfd (ts-21705): Signal 15 erhalten,
>  ordungsgemäßes Herunterfahren
>  Mar 24 21:59:57 xenon gconfd (ts-21705): Beenden
>  Mar 24 21:59:57 xenon gdm[21341]: WARNING: gdm_slave_xioerror_handler:
>  Schwerwiegender X-Fehler - :0 wird neu gestartet
>  Mar 24 21:59:58 xenon kernel: [426716.212842] PM: Adding info for No
>  Bus:vcs7
>  Mar 24 21:59:58 xenon kernel: [426716.213300] PM: Adding info for No
>  Bus:vcsa7
>  Mar 24 21:59:58 xenon kernel: [426716.295997] PM: Removing info for No
>  Bus:vcs7
>  Mar 24 21:59:58 xenon kernel: [426716.296110] PM: Removing info for No
>  Bus:vcsa7
>  Mar 24 21:59:59 xenon kernel: [426716.434662] PM: Adding info for No
>  Bus:vcs7
>  Mar 24 21:59:59 xenon kernel: [426716.434742] PM: Adding info for No
>  Bus:vcsa7
>  Mar 24 22:00:00 xenon kernel: [426717.727427] uhci_hcd 0000:00:1d.1:
>  reserve dev 4 ep81-INT, period 8, phase 4, 93 us
>  Mar 24 22:00:00 xenon kernel: [424472.319521] uhci_hcd 0000:00:1d.1:
>  release dev 4 ep81-INT, period 8, phase 4, 93 us
>  Mar 24 22:00:00 xenon kernel: [426717.997926] uhci_hcd 0000:00:1d.1:
>  reserve dev 4 ep81-INT, period 8, phase 4, 93 us
>  Mar 24 22:00:02 xenon gconfd (root-15531): (Version 2.20.0) wird
>  gestartet, Prozesskennung 15531, Benutzer »root«
>  Mar 24 22:00:02 xenon gconfd (root-15531): Die Adresse
>  »xml:readonly:/etc/gconf/gconf.xml.mandatory« wurde an der Position 0 zu
>  einer nur lesbaren Konfigurationsquelle aufgelöst
>  Mar 24 22:00:02 xenon gconfd (root-15531): Die Adresse
>  »xml:readwrite:/root/.gconf« wurde an der Position 1 zu einer
>  schreibbaren Konfigurationsquelle aufgelöst
>  Mar 24 22:00:02 xenon gconfd (root-15531): Die Adresse
>  »xml:readonly:/etc/gconf/gconf.xml.defaults« wurde an der Position 2 zu
>  einer nur lesbaren Konfigurationsquelle aufgelöst
>  Mar 24 22:00:02 xenon gconfd (root-15531): Die Adresse
>  »xml:readonly:/etc/gconf/gconf.xml.schemas« wurde an der Position 3 zu
>  einer nur lesbaren Konfigurationsquelle aufgelöst
>  Mar 24 22:00:05 xenon kernel: [426722.904631] gtk-window-deco[15527]:
>  segfault at 4 ip b785c98a sp bfa4d160 error 4 in
>  libcairo.so.2.11.5[b7852000+7c000]
>
>  (The translation of the German error message from gdm is:
>  "Serious X error - restarting :0"
>  The German language messages from gconfd are probably not important,
>  as they appear identically during a regular X logout/login cycle.)
>
>  I'm at a loss where to start investigating this. Bisecting appears
>  impractical given the error happens about every other day with no
>  obvious triggering condition (except me being afk for a longer time.)
>
>  Configuration: Pentium D940, 2 GB RAM, Intel 965 chipset, Matrox
>  G550 PCIe graphics adapter, openSUSE 10.3 32 bit install.
>
>  Ideas?

anything in the X.org logfiles? does it happen with DRI off?

I don't think any of the DRM changes I made could cause this, so I'd
be looking towards something more generic..

Dave.

>
>  Thanks
>  Tilman
>
>
>
