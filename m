Return-Path: <linux-kernel-owner+w=401wt.eu-S1756129AbYJVVw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129AbYJVVw7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 17:52:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751822AbYJVVwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 17:52:49 -0400
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:28546 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751564AbYJVVwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 17:52:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=3QiUaj9rgKuSioD72mgBJIe2nkXHvpcAnYRe/STHuPMaEqsfyI9UJ1SwgEK2pEOtXzoVLDOjmS2vuZ7xSGO4lLEn4clPkLxrqbB9ItPdof+JoPMh222kpom2U8133mdDKfh643stRmalN7XjlFA+2cAl25aBCJJwekwBiB3ysc0=  ;
X-YMail-OSG: GGcxoEkVM1kCf_XftE.6PgEZlnlU0l770jk1jhnUjHgPELoegVD2CqMSpo5IxMDYZa9WA2LEuo6vzms_RGE8kFTqrOxCysQ0cFQWMin3CjMfWUzmZzLDZJJVuLqE5PaRB44-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: avorontsov@ru.mvista.com
Subject: Re: [PATCH 4/7] gpiolib: implement dev_gpiochip_{add,remove} calls
Date: Wed, 22 Oct 2008 14:52:46 -0700
User-Agent: KMail/1.9.10
Cc: benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, i2c@lm-sensors.org,
       Jean Delvare <khali@linux-fr.org>, David Miller <davem@davemloft.net>
References: <20081016171222.GA24812@oksana.dev.rtsoft.ru> <200810221404.52798.david-b@pacbell.net> <20081022212217.GA32378@oksana.dev.rtsoft.ru>
In-Reply-To: <20081022212217.GA32378@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200810221452.46786.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 October 2008, Anton Vorontsov wrote:
> > 
> > > So if we register the board infos after 
> > > the controller registered, then nobody will probe the board infos.
> > 
> > See above.  If you're doing it right, there's no problem.
> > That is, scan the OF tables early.  Just like PNP tables
> > get scanned early, for example.
> 
> Heh. If we don't want to be able to make the OF-parsing code
> be a module then there is no problem at all. I can use the bus
> notifiers. And it is most straightforward solution then.
> 
> But I quite dislike to bloat the kernel image with
> maybe-never-used-on-this-board code.

So have it live in the __init text section.  If you're
building a kernel with support for several boards, you
know it's necessarily going to be larger than it would
be if only one board were supported.  But you can shrink
kernel size by judicious use of __init sections..



> My aim was to make the 
> OF-parsing part be a module too. Because in the long run we
> need the OF-parsing stuff for _every_ driver that needs
> platform data. It's quite expensive to have it always built-in,
> don't you think?

If it's discarded early, after translating the data from
OF format into what the drivers need, there will be no
RAM footprint.

- Dave


