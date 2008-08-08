Return-Path: <linux-kernel-owner+w=401wt.eu-S1762213AbYHHW6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762213AbYHHW6d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 18:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754954AbYHHW60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 18:58:26 -0400
Received: from khc.piap.pl ([195.187.100.11]:45579 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753533AbYHHW6Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 18:58:25 -0400
To: Grant Coady <gcoady.lk@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] cleanup Serial ATA and Parallel ATA Kconfig
References: <alpine.LFD.1.10.0808081228450.11491@localhost.localdomain>
	<20080808172629.232bed01@lxorguk.ukuu.org.uk>
	<njhp94pr4ha1nfgmj11n662enalpd9663h@4ax.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sat, 09 Aug 2008 00:58:22 +0200
In-Reply-To: <njhp94pr4ha1nfgmj11n662enalpd9663h@4ax.com> (Grant Coady's message of "Sat\, 09 Aug 2008 08\:34\:40 +1000")
Message-ID: <m3sktfw1v5.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Coady <grant_lkml@dodo.com.au> writes:

>   ¦ ¦    --- Serial ATA (SATA) and Parallel ATA (PATA) drivers            ¦ ¦
>   ¦ ¦    <*>   AHCI SATA support                                          ¦ ¦
>   ¦ ¦    [*]   ATA ACPI Support                                           ¦ ¦
>   ¦ ¦    [ ]   SATA Port Multiplier support                               ¦ ¦
>   ¦ ¦    < >   Silicon Image 3124/3132 SATA support                       ¦ ¦
>   ¦ ¦    [*]   ATA SFF support                                            ¦ ¦
>   ¦ ¦            *** Serial ATA drivers ***                               ¦ ¦
>   ¦ ¦    < >     Initio 162x SATA support                                 ¦ ¦
>   ¦ ¦    < >     Intel ESB, ICH, PIIX3, PIIX4 PATA/SATA support           ¦ ¦

As noted, it's both PATA and SATA. People searching for PATA-only PIIX
support may have trouble locating it under SATA.

Why not remove ATA SFF support visual option (or leave it for optional
off-tree drivers only, if it makes sense) and SELECT it when any
driver using it is selected? I'm not sure that users know they need
SFF, or what's that.

I think I would also ask for PATA and for SATA first:

[*] PATA support
[*] SATA support
... PATA drivers if "PATA support" is selected
... SATA drivers if "SATA support" is selected
... PIIX is PATA and/or SATA support is selected

I guess all PATA and/or SATA drivers in a single sorted list (so PIIX
doesn't break ordering).
-- 
Krzysztof Halasa
