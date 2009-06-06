Return-Path: <linux-kernel-owner+w=401wt.eu-S1755218AbZFFOz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbZFFOz2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 10:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753671AbZFFOzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 10:55:23 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39482 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753240AbZFFOzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 10:55:22 -0400
Date: Sat, 6 Jun 2009 15:56:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Grozdan <neutrino8@gmail.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: Kernel 2.6.30rc7 limits IDE to UDMA33
Message-ID: <20090606155636.18bc4f2e@lxorguk.ukuu.org.uk>
In-Reply-To: <4A29C163.3080706@gmail.com>
References: <c5bd819b0906021525l13ee9282j1fb270e141985f66@mail.gmail.com>
	<4A25F688.9000407@gmail.com>
	<c5bd819b0906030435w466368cbsd48be91a97597437@mail.gmail.com>
	<20090603131407.57c490ed@lxorguk.ukuu.org.uk>
	<c5bd819b0906030552w6f23185etb394f83c8b630e6@mail.gmail.com>
	<20090603140140.491a8ea8@lxorguk.ukuu.org.uk>
	<c5bd819b0906030639o5f9c34ffg500e132d3a0b5117@mail.gmail.com>
	<c5bd819b0906040750w75e0389cod2a03b89ce838d1b@mail.gmail.com>
	<20090605100505.41b3b818@lxorguk.ukuu.org.uk>
	<c5bd819b0906050335i4e813887sc8f4d901da86a1aa@mail.gmail.com>
	<20090605114245.175499e1@lxorguk.ukuu.org.uk>
	<4A29C163.3080706@gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I wouldn't rule out the possibility of a bug. The code in pata_via looks 
> a bit fishy, it reports a 40-wire cable if either the GTM data wasn't 
> present or valid, or if it reports a mode of UDMA2 or less. In the 
> former case it seems like ATA_CABLE_PATA_UNK would be the safer choice 
> since we really don't know, and we should then use drive-side detection, 
> rather than assuming a 40-wire cable by default..

Drive side detection doesn't work for many VIA boards, the neccessary
components are not included.

About the only other check I can think to try is to see if the BIOS
programmed modes > UDMA2 for either device. That has its own problems
(suspend-resume/hotplug/non-bios devices) which is why we currently don't
do it.

Alan
