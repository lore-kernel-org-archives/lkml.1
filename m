Return-Path: <linux-kernel-owner+w=401wt.eu-S1756670AbYACHg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670AbYACHg0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 02:36:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324AbYACHgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 02:36:18 -0500
Received: from smtp114.sbc.mail.mud.yahoo.com ([68.142.198.213]:27476 "HELO
	smtp114.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750770AbYACHgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 02:36:17 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=4RNN2Z4D0oXeMRfdqSU9vtkmYgDOJOeSwkKqYhl6HhrW7WNuurpihJR9eYhdxiwoUMg9TArKOUzM2lNv76igv8UjPFhjD5+2zoi6KzrWLA1wz11utRVupUx5BWmsDEgLyJNgwOdHiav53X+KrECfvPiViZZ3oMAFYKSL+esmXPA=  ;
X-YMail-OSG: p_78m_UVM1mAy36dMaDT7SAxVmapl6.L4zdLgUSSzRpm32Ya
From: David Brownell <david-b@pacbell.net>
To: "Bryan Wu" <cooloney.lkml@gmail.com>
Subject: Re: [linux-usb-devel] [PATCH] : Allow embedded developers USB options normally reserved for OTG
Date: Wed, 2 Jan 2008 23:36:09 -0800
User-Agent: KMail/1.9.6
Cc: "Robin Getz" <rgetz@blackfin.uclinux.org>,
       linux-usb-devel@lists.sourceforge.net, gregkh@suse.de,
       linux-kernel@vger.kernel.org
References: <200801020948.51310.rgetz@blackfin.uclinux.org> <200801021943.38716.david-b@pacbell.net> <386072610801022040ja4919bapa8a0712c1246c3f3@mail.gmail.com>
In-Reply-To: <386072610801022040ja4919bapa8a0712c1246c3f3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801022336.10355.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 January 2008, Bryan Wu wrote:
> B.T.W, 2 questions about the MUSB driver:
> 1. What's the plan for mainline merge of the whole MUSB driver? maybe
> I can cleanup current Blackfin ports to you guys.

It might as well merge in 2.6.25-early.  It'll be easier to integrate
patches that way.  Including your Blackfin port.  When I asked before,
nobody hugely objected to "one big patch".


> 2. Do you remember the PING issue I reported in OMAP list? How do you
> think of that?

Yes, something needs to be done.  EHCI might benefit from the same
kind of patch, to cope with ill-behaved usb thumb drives.


> > I have an idea: the USB_NAKLIMIT0 should be set to some value, when we
> > got NAK timeout interrupt, we can disable PING. When enumerating normal
> > USB stick, there is no NAK timeout, because PING is efficient for
> > handshaking. While problem USB stick will generate NAK timeout
> > interrupt, we disable PING for this kind of USB device enumeration.
 
That sounds much better than your original patch, which disabled it
always.  It might even be worth allocating a flag somewhere in the
usb_device structure to record when ep0 pings seem to misbehave.

- Dave


