Return-Path: <linux-kernel-owner+w=401wt.eu-S1761768AbYBVU3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761768AbYBVU3T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 15:29:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751812AbYBVU3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 15:29:04 -0500
Received: from smtp109.sbc.mail.mud.yahoo.com ([68.142.198.208]:44076 "HELO
	smtp109.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751714AbYBVU3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 15:29:03 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-Newman-Property:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=eSdf4DssMQifSKvcw0vCDHFJUnx6yWae3AgSMmto+AROhivwgs0KPGmADZuxIxsykr4ZQtvhl6FnZFjkifdCdjs6pDXE4vPsW/Jfdt8B9cHchsBaA38rvlIk8DMKGekzcEClAnz1RZi1+r/yDmG9tRCfC7nMOSNZ2VBqacZDrmI=  ;
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 22 Feb 2008 12:28:55 -0800
From: David Brownell <david-b@pacbell.net>
To: lg@opensource.wolfsonmicro.com, eric.y.miao@gmail.com
Subject: Re: [UPDATED v2][PATCH 0/6] regulator: voltage and current regulator 
 framework
Cc: linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, akpm@linux-foundation.org
References: <1203527326.4071.88.camel@localhost.localdomain>
 <20080221084128.GA4931@flint.arm.linux.org.uk>
 <1203611191.4071.186.camel@localhost.localdomain>
 <f17812d70802211922v49201af2re87629eba34bd9d4@mail.gmail.com>
 <1203683790.4071.262.camel@localhost.localdomain>
In-Reply-To: <1203683790.4071.262.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080222202855.2F1AD229B4D@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > For those PMIC that covers additional features, like
> >   - usb vbus detection (or pull-up/pull-down)
> >   - audio codec
> >   - touch screen
> >   - battery monitor/ fuel gauge
> >   - battery charger
> >   - possible many others

Certainly many others ... like MMC transceivers, high speed USB
transceivers, RTCs, and lots of other analog and "high voltage"
(more than 1.8V, say) circuits that should be offloaded from 
SOCs for systems built with 90nm (and smaller) processes.


> > How do you plan to handle them?
>
> The WM8350 and MC13783 are both multi feature PMIC's like above. We
> handle WM8350 PMIC access via a bus manager.

I think most such PMIC cases are best modeled as multi-function
devices, plugging into numerous different frameworks.  That may
be implied by "bus manager".

There are already at least two PMIC drivers in drivers/i2c/chips
in the mainstream kernel (tps65010.c and menelaus.c) and I'd think
one factor to review of this framework is whether those chips
could reasonbly be used in this framework.

So for example the tps65010 presumes that fuel gauging is done
by a separate chip (presumptively using HDQ/1-Wire), and in fact
that may be part of a battery pack.  And the DAC functions, like
touchscreens and (input) codecs, use other dedicated chips.  As
time goes by, those PMIC chips integrate lots more functionality..

- Dave


>	This controls IO access to
> the WM8350 so that client driver (including the regulator driver) IO
> does not collide. We also cache non volatile PMIC registers to speed up
> access. Please have a look at drivers/regulator/wm8350/wm8350-bus.c in
> the imx31 branch for details.
>
> Liam
>
