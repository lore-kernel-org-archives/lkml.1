Return-Path: <linux-kernel-owner+w=401wt.eu-S1755403AbYDRIr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403AbYDRIr0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 04:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752524AbYDRIrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 04:47:17 -0400
Received: from web36707.mail.mud.yahoo.com ([209.191.85.41]:45926 "HELO
	web36707.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752508AbYDRIrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 04:47:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=L++fzLa9028g0W6cQsU6Cg33C1EXjaEvfamlAuiYlb6sNeHYk3U8Lh3/sho9YcKfjJMuGDQVxzD8J4YqShyBbXbUbj0XjrCir2imZhq//JguEd6ZIbIt/8NF6wXbN75H/6doxmt5rwbX3UQl8VicYv+E9W78Jq8ChWbr8/YX4UU=;
X-YMail-OSG: ZcY5G5MVM1l1.PcjSX2M5i_82kWbQFsGwMC8lp7rSA3g6Y1yqyc1_VHOYv2y.rGNljlq6rTQMUSAJfW7J8eke8EE0nCRpII0b1BhRH7W63Ai8bf1cCq5XL8QIw--
Date: Fri, 18 Apr 2008 01:47:12 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: Smartmedia/xd card support - request for comments
To: linux-kernel@vger.kernel.org
Cc: joern@logfs.org, tglx@linutronix.de, ben@fluff.org
In-Reply-To: <20080417212138.GA343@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <143829.94600.qm@web36707.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unfortunately, I must say, Smartmedia is not supported on linux for any reasonable definition of
the word.

First, with all the respect to Jorn, alauda driver can only be considered "proof of concept". It
does not try to abstract any smartmedia functionality.

Second, ssfdc is hopelessly obsolete and requires rewrite.

Third, there's no attempt made by mtd to support advanced functionality present in many smartmedia
and all memorystick readers: adapter side copy and multi page programming (this mostly relates to
memorystick, of course). I also failed to see any support for device writing policy, needed to
discern, for example, sequential page programmable devices vs. block programmable devices. I also
failed to see an unified approach to page-accessible devices, meaning duplication of "bouncing"
code in the backends.

In general, block device emulation layer of mtd is incomplete at best.

No infrastructure exists for exporting and manipulation of metadata in userspace.

And, in general, architecture of mtd is suboptimal, relying on blocking calls (as opposed to
callback based architecture).

Considering all this, amount of effort needed for satisfactory support of smartmedia through mtd
was found by me to be far greater than coming with stand-alone implementation. I do agree, that
eventually my work can be merged into mtd. I don't see what prevents merging of my implementation
as is on an interim basis, considering there are no real alternatives.

In case somebody is actually interested in looking at the code:

http://svn.berlios.de/wsvn/tifmxx/trunk/driver/#_trunk_driver_



      ____________________________________________________________________________________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ
