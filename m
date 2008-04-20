Return-Path: <linux-kernel-owner+w=401wt.eu-S1757197AbYDTCZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197AbYDTCZQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 22:25:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753017AbYDTCZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 22:25:04 -0400
Received: from web36703.mail.mud.yahoo.com ([209.191.85.37]:30239 "HELO
	web36703.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752984AbYDTCZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 22:25:03 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=0sBBDoODFXB9HNAOyIZ71V4T/xIb8DhryToPKxZak7nXEg3jwNgcqNIVyBijzkbx2J8bkNE9QiNYKjDFW/26dvqqxkZDFWuwSkCQ8ruMG0gJE90XSJvj8FqoWVMT3UT35EiOTZ0zWiITU0D1MZ7lt9SuirrGvuZbwpqpk34iG6w=;
X-YMail-OSG: 5zF9zQYVM1k4H7bXrmNXezQLwK9fg0V5FBYTV7GIntFx5Cvm1ysZjWFxJoie3qzkKY6qznObVpSEki_1VLadyijTZpJXDTkjbgBJAkPr_T829TV6r23DI01_pA--
Date: Sat, 19 Apr 2008 19:25:01 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: Smartmedia/xd card support - request for comments
To: Thomas Gleixner <tglx@linutronix.de>
Cc: joern@logfs.org, linux-kernel@vger.kernel.org, ben@fluff.org
In-Reply-To: <alpine.LFD.1.10.0804190806110.3261@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <244375.57524.qm@web36703.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> That's all fine. Nobody asked for the backend to know about smartmedia
> on FLASH format details. The MTD NAND FLASH layer does not care about
> on FLASH data format at all. It provides merily access on the hardware
> level.
> 
> I agree that your approach of making the SM/XD layer capable of
> handling clever and dumb hardware adapters is a good one.
> 
> The point where I stringly disagree is that your implementation is
> forcing people with dumb hardware (see drivers/mtd/nand/*) to
> reimplement the (maybe already) existing drivers in order to make use
> of the ssfdc format, which will not work with the following real world
> example:
> 
> ------------------
> | NAND controller |----------| On board NAND
> | with HW ECC     |
> |                 |----------| SmartMedia Card
> ------------------
> 
> Having a separate driver infrastructure for clever controllers, which
> provide only semi raw access to the FLASH chip is fine simply because
> such controllers do not fit into the MTD layer.

Shouldn't both smartmedia and legacy memorystick controllers can be considered
"semi-raw"? In second case, media itself implements "semi-raw" flash interface.

> 
> > I meant here the ability of user to look and modify CIS page, as
> > well as look at the current block translation table.
> 
> Well, you probably do this with an iotctl anyway. So what's preventing
> you to modify the mtd block layer to handle client private ioctls.

I think ioctls are nowhere as convenient as sysfs file. I believe many people
share this point of view - after all, ioctls throw a lot of different
functionality into one basket, using cryptic codes.

> 
> Also there is no real requirement to use the mtd block layer at all
> for that. Putting your layer on top of the raw MTD device is fine IMO.

I see that raw mtd operates on buffer pointers, rather than scatterlists. From
my understanding, it demands "map" and possibly "bounce" operation elsewhere,
incurring sizable overhead on performance (for fast media, the waits in the
blocking read/write operations will also have considerable effect). Are there
any plans to address this issue?

> >
> > Revamping the underlying architecture of mtd will break a lot of
> > stuff in the process, doesn't it?
> 
> That's the best excuse I ever heard for not improving code which has
> shortcomings.
> 

Can't agree. It's one of the most commonly used, according to my experience.



      ____________________________________________________________________________________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ
