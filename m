Return-Path: <linux-kernel-owner+w=401wt.eu-S1758615AbZAHONS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758615AbZAHONS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 09:13:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbZAHOM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 09:12:59 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:60258 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228AbZAHOM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 09:12:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=EXZrC9LkZOVe+uBEZO+6Wnsgzo/NiwWAllyL/0JTYBy4V8XOOLT38DJtpeyRrY4ASq
         X5tMIPHzi1gIyf6QeA1AL6ELeGgrPeCJen6OUoJSl2wxqe0k+Ay7B+5T035QZCOUrJbM
         zZ6WU9/xAgjr9DzfChp9aLk3ALAkRbIN6Lh70=
Message-ID: <8447d6730901080612r4a15a57k7d8621a7fd29b43b@mail.gmail.com>
Date: Thu, 8 Jan 2009 15:12:57 +0100
From: "Davide Rizzo" <elpa.rizzo@gmail.com>
To: "Ben Dooks" <ben-linux@fluff.org>
Subject: Re: [PATCH 2/3] Driver for user access to internal clocks
Cc: linux-kernel@vger.kernel.org, hjk@linutronix.de, gregkh@suse.de
In-Reply-To: <20090108121944.GN12431@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8447d6730901080150p217f5d71kd2512b124ed0ed4c@mail.gmail.com>
	 <20090108121944.GN12431@fluff.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> you've borken the const of the clk_get() call. I think that
> this is either something that the caller needs to deal with
> as all the drivers will be passing a 'dev' structure in to
> help identify common clocks.
>
As I modified it the clk_get() function it should be compatible with
the past, simply now it recognizes ALSO the format clkname.X to allow
a generic driver to have access to all clocks.
The other way to achieve this is to simulate a specific id in a fake
dev parameter, but it's awful.
For the driver to be generic, all low-level drivers should recognize
the clkname.X format. But this is the standard syntax for devices
name, so I think this should be correct.
Also clk_for_each() and clk_name() should be added to clock
infrastructure, so they should be implemented in all drivers.
Maybe this should be proposed and discussed with the clock
infrastructure maintainer, but I didn't find him in the MAINTAINER
list. Do you know who is ?
Where do you think the generic user access driver should be placed ?
