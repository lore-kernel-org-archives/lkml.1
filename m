Return-Path: <linux-kernel-owner+w=401wt.eu-S1754121AbYEZHij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbYEZHij (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 03:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751884AbYEZHia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 03:38:30 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:55664 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbYEZHi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 03:38:29 -0400
Date: Mon, 26 May 2008 03:38:21 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Joe Perches <joe@perches.com>
cc: Jiri Slaby <jirislaby@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] SERIAL:  Simplify code using ARRAY_SIZE() macro.
In-Reply-To: <1211740916.8496.27.camel@localhost>
Message-ID: <alpine.LFD.1.10.0805260337410.29823@localhost.localdomain>
References: <alpine.LFD.1.10.0805250735560.23325@localhost.localdomain>  <483998EC.5080805@gmail.com>  <alpine.LFD.1.10.0805251308420.25842@localhost.localdomain> <1211740916.8496.27.camel@localhost>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 May 2008, Joe Perches wrote:

> On Sun, 2008-05-25 at 13:09 -0400, Robert P. J. Day wrote:
> > > > diff --git a/drivers/serial/68328serial.c b/drivers/serial/68328serial.c
> > > > index bbf5bc5..71c56c1 100644
> > > > --- a/drivers/serial/68328serial.c
> > > > +++ b/drivers/serial/68328serial.c
> > > > @@ -1413,10 +1413,10 @@ static void m68328_set_baud(void)
> > > >  	USTCNT = ustcnt & ~USTCNT_TXEN;
> > > >
> > > >  again:
> > > > -	for (i = 0; i < sizeof(baud_table) / sizeof(baud_table[0]); i++)
> > > > +	for (i = 0; i < BAUD_TABLE_SIZE); i++)
> > > typo? does this compile?
> > will resubmit.
>
> There are only two uses of BAUD_TABLE_SIZE
> and MCFRS_BAUD_TABLE_SIZE.
>
> I think it better to avoid
> 	#define SOME_SIZE ARRAY_SIZE(some_array)
> and use ARRAY_SIZE(some_array) where possible.
>
> NR_PORTS seems to be an exception.

yes, that cleanup could probably be simplified even further.

rday
--

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
