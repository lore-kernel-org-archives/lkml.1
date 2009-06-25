Return-Path: <linux-kernel-owner+w=401wt.eu-S1758345AbZFYPhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758345AbZFYPhf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 11:37:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbZFYPh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 11:37:28 -0400
Received: from smtp105.sbc.mail.gq1.yahoo.com ([67.195.14.108]:22296 "HELO
	smtp105.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751411AbZFYPh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 11:37:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=PfiWjhvlWmvyjrHXypDjI9umZPzGBMT6sXRPrGD2jz5iTL9AM3n5QfMH3OpkL+8V1RBL/+2zk8xWt8ojHbJEPDprEbWLVh/n2DIyIuzQdVgYQnEJuI+uBGz+SYMcDjbr0j4/rROgjzr3v+kr4ZuCZDoxzacFMgxvo6FbjVojzms=  ;
X-YMail-OSG: 6hgCJsAVM1mfrvTbKYnBhTV4UCnFvc05fk2B7hoN9j0B9T5qT6iyROWQdZMilXCwg2Jnq9olmfP_AOU50vQnmloyv8C57VPCwKEG.5h6MeTp1bRKzbTYhkTLyYD46MdxZLem828WAyIk8FzDKEDRSYoRO5RXuTY9KzlE0ua87WWgkUbi0kKOOqNIpEBdn0dVTfV9JmdO8ix9KA2Wd2Vnev.9XLzC6VIbex..ndzF4MpWdp4nGx6lvpLh6Fu9xM5oiAYv0pprBNsB5AIo
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] [drivers] [SPI] SPI_GPIO: add support for controllers with missing MISO pin
Date: Thu, 25 Jun 2009 08:36:52 -0700
User-Agent: KMail/1.9.10
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
       spi-devel-general@lists.sourceforge.net, kyungmin.park@samsung.com
References: <E4D3F24EA6C9E54F817833EAE0D912AC0228288531@bssrvexch01.BS.local> <200906231155.15339.david-b@pacbell.net> <000401c9f58e$c1369230$43a3b690$%szyprowski@samsung.com>
In-Reply-To: <000401c9f58e$c1369230$43a3b690$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200906250836.53027.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 June 2009, Marek Szyprowski wrote:
> > Thing is, this raises two related issues:  (a) there's the
> > analagous input-only case where MOSI isn't used, e.g. for
> > some kinds of sensor; and (b) there's also "real 3-wire SPI"
> > (spi->mode & SPI_3WIRE) where interactions are limited to
> > half duplex and one pin switches roles between MOSI and MISO.
> > 
> > Clearly this "output-only" case is a subset of SPI_3WIRE (the
> > MOMI/SISO pin can't switch direction) so one more change I
> > want to see is requiring that spi->mode flag be set in all
> > SPI devices registered when this mode is used.

Don't forget that change ...

 
> > If you have time, it would be good to generalize this patch
> > to cover all of those 3-wire modes ... accept all half
> > duplex calls, use gpio_direction_*() to switch direction.
> >
> > If not -- e.g. nothing to test that with! -- then I can
> > understand, but please make your changes with that model
> > in mind, and leave an appropriate FIXME in place.
> 
> I'm sorry, but I have only a hw board with missing MISO pin so I won't
> be able to properly check/debug any other configurations.

OK, then just stick to what you can test, and comment the issue.


