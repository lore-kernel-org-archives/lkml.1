Return-Path: <linux-kernel-owner+w=401wt.eu-S1753687AbXKXBLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687AbXKXBLg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 20:11:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752587AbXKXBL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 20:11:28 -0500
Received: from gate.crashing.org ([63.228.1.57]:43227 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544AbXKXBL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 20:11:28 -0500
Subject: Re: radeonfb i2c regression post-2.6.18.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Jean Delvare <khali@linux-fr.org>
Cc: Michael Buesch <mb@bu3sch.de>, Roger Leigh <rleigh@whinlatter.ukfsn.org>,
       linux-kernel@vger.kernel.org, Dennis Munsie <dmunsie@cecropia.com>
In-Reply-To: <20071123232928.467378a7@hyperion.delvare>
References: <1195427766.7022.18.camel@pasglop>
	 <200711231700.53103.mb@bu3sch.de>
	 <20071123232928.467378a7@hyperion.delvare>
Content-Type: text/plain
Date: Sat, 24 Nov 2007 12:11:04 +1100
Message-Id: <1195866664.7195.28.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-11-23 at 23:29 +0100, Jean Delvare wrote:
> On Fri, 23 Nov 2007 17:00:52 +0100, Michael Buesch wrote:
> > This patch fixes my crash problem.
> 
> Out of curiosity, what kind of crash was it? I admit that I can't see
> how the code could crash.

Really sneaky... apparently, keeping the i2c lines asserted on his
laptop model would drain enough current through the pullups (or the
chip) that the temperature will raise significantly, causing a thermal
shutdown if the machine was already warm.

A bit scary... looks to me that a pullup is a bit too weak somewhere on
the motherboard.

That also means that this fix should reduce power consumption on the
battery significantly on those machines as it must take quite a bit of
power to increase the temperature that significantly (either that, or
the heating part sits just next to the sensor).

Cheers,
Ben. 

