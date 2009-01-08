Return-Path: <linux-kernel-owner+w=401wt.eu-S1763007AbZAHWOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763007AbZAHWOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 17:14:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbZAHWOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 17:14:38 -0500
Received: from rv-out-0506.google.com ([209.85.198.238]:1986 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbZAHWOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 17:14:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=eTyXqJWY2nANNapsBHg12R4IgqCKk8OjLW54Gn0y1Z4Xv5QqKXt4xYjxCB2CFtKFHb
         +NACLp7hxI0iUWT62Wl5KeJSanaM85cDeHx0OK+91Q75lO5CP+njwQzx7hg+YfMKSkFG
         3Fmbx4Z7a0zjtYAUyZaWGdVGZe8V0cRCAByKY=
Message-ID: <82ecf08e0901081414u15af3c2dy9c88a242db024dc7@mail.gmail.com>
Date: Thu, 8 Jan 2009 20:14:36 -0200
From: "Thiago Galesi" <thiagogalesi@gmail.com>
To: "Hugo Villeneuve" <hugo@hugovil.com>
Subject: Re: FPGA programming driver architecture
Cc: "Florian Fainelli" <florian@openwrt.org>, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org
In-Reply-To: <20090108151827.72f50cee.hugo@hugovil.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081212150314.6ea24996.hugo@hugovil.com>
	 <200812131358.03010.florian@openwrt.org>
	 <20090108151827.72f50cee.hugo@hugovil.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Hi,
> > > I have written some code to program a FPGA in Linux, for two
> > > different types of boards: one uses a serial interface (SPI) and
> > > the second a parallel interface. I have been able to sucessfully
> > > program both boards. I'm now trying to clean my code and make it
> > > more generic, as well as better in line with the Linux driver
> > > model.

Considering the several FPGA models available and ways to program it,
I guess the important thing to consider is what can be made generic.
(that is what will become fpgaload)

Also, there may be cases where after FPGA is programmed it "becomes a
device" (PCI or whatever)

> >
> > - fpgaload-core which contains all the code that can be shared
> > between the drivers like requesting firmware, providing sysfs
> > attributes,
> > - fpgaload-spi would handle the low-level SPI connection
> > - fpgaload-par would handle the low-level parallel connection

I think this maybe split into three layers (maybe)

1 - low level connection: paralell / spi / i2c / whatever
2 - vendor: xylinx, altera, etc
3 - generic stuff

Take a look at the MTD and SPI drivers and how they split things

--
-
Thiago Galesi
