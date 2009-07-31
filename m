Return-Path: <linux-kernel-owner+w=401wt.eu-S1752349AbZGaPRC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349AbZGaPRC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 11:17:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbZGaPRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 11:17:00 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57543 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751621AbZGaPQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 11:16:59 -0400
Date: Fri, 31 Jul 2009 16:17:35 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ozan =?UTF-8?B?w4dhxJ9sYXlhbg==?= <ozan@pardus.org.tr>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [Bug #13471] Loading parport_pc kills the keyboard if ACPI is
 enabled
Message-ID: <20090731161735.6a94ad9c@lxorguk.ukuu.org.uk>
In-Reply-To: <4A7308E8.1000200@pardus.org.tr>
References: <DizPU9GBfHF.A.kgF.iWObKB@chimera>
	<H5-1lZIIeYK.A.dWH.9XObKB@chimera>
	<20090731151417.568094e5@lxorguk.ukuu.org.uk>
	<4A7308E8.1000200@pardus.org.tr>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

O> Finally, it seems that the problem is available with 2.6.28, so the starting
> point is still fuzzy to me. I remember that the keyboard was working OK with
> 2.6.29_rc7 but now it's not.
> 
> Maybe we should drop this report from the regression list."
> 
> 
> Monday I'll have access to the computer. I'll build and try to find the last working version.
> Meanwhile, I'd like to hear about your possible finding.

There have been few changes to parport_pc but one thing recent changed
the probe for SuperIO chips via low addresses and that could be
interfering.

commit e2434dc1c19412639dd047a4d4eff8ed0e5d0d50
Author: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
Date:   Mon Jun 22 16:51:49 2009 +0100

changed the behaviour slightly (hence asking about which release if it
was a recent breakage). Its also a code area with very few changes so if
you can find which one worked last, you should be able to transplant that
parport_pc into 2.6.current and see if its parport or acpi triggered
breakage.

Alan
