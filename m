Return-Path: <linux-kernel-owner+w=401wt.eu-S965585AbXIGQll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965585AbXIGQll (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 12:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757872AbXIGQld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 12:41:33 -0400
Received: from smtp123.sbc.mail.re3.yahoo.com ([66.196.96.96]:25269 "HELO
	smtp123.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757676AbXIGQlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 12:41:32 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=cbnjHkhBfQkcry5i0bqaI74POFF/AT8gxdWAstNBi6Ua9EE9x5oBjRMVWySNWVhLEX0utHYwELEELA0mmd+QyPnns1RjzfJNpa1HsvxkB6OhWbDHZwoF8wuHcwte42dD6LViGjAGXXAYzwxNRDZfoOUfPaHGDTEq5GSnnaaPSQY=  ;
X-YMail-OSG: yfu3ilkVM1lcjRczKw4g8EzI9Bw4FTq2Uli8TojGZTYgc4RBeM1BoGYBFgbU5_am95X7NqA.pw--
Date: Fri, 07 Sep 2007 09:41:29 -0700
From: David Brownell <david-b@pacbell.net>
To: khali@linux-fr.org, dmitry.torokhov@gmail.com
Subject: Re: Platform device id
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
References: <20070907153559.17faf9d1@hyperion.delvare>
 <d120d5000709070758i1b54a37o3d3977304a84b2c1@mail.gmail.com>
In-Reply-To: <d120d5000709070758i1b54a37o3d3977304a84b2c1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20070907164129.65816B9389@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> If a device has a <name>.<instance> scheme this implies possibility of
> having several instances of said device in a box. There are a few of
> platform devices that can only have one instance

Like USB peripheral controllers.  Only one external "B" type
connector is allowed.


>	- for example i8042
> keyboard controller (the -1 special handling came from me because
> i80420 name was very confusing - there wasn't a dot separator in the
> name back then).

There were other devices with similar issues.


>	Drivers that allow multiple devices should not
> attempt to use -1 for the very first instance - this should eliminate
> potential for error and special handling that you are talking about.

For that matter, a *driver* should never create its own device node(s)
in the first place.  Device creation belongs elsewhere, like as part of
platform setup or, for busses with integral enumeration support like
PCI or USB, bus glue.  Linux is moving away from that legacy model.

I realize that may be more easily said than done in some cases,
like i8042 on non-PNP systems.

- Dave

