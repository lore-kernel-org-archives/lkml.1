Return-Path: <linux-kernel-owner+w=401wt.eu-S1757663AbYEYSpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757663AbYEYSpw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 14:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755078AbYEYSpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 14:45:43 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:4079 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755455AbYEYSpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 14:45:43 -0400
Subject: Re: [PATCH] SERIAL:  Simplify code using ARRAY_SIZE() macro.
From: Joe Perches <joe@perches.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
In-Reply-To: <alpine.LFD.1.10.0805251308420.25842@localhost.localdomain>
References: <alpine.LFD.1.10.0805250735560.23325@localhost.localdomain>
	 <483998EC.5080805@gmail.com>
	 <alpine.LFD.1.10.0805251308420.25842@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 25 May 2008 11:41:56 -0700
Message-Id: <1211740916.8496.27.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-05-25 at 13:09 -0400, Robert P. J. Day wrote:
> > > diff --git a/drivers/serial/68328serial.c b/drivers/serial/68328serial.c
> > > index bbf5bc5..71c56c1 100644
> > > --- a/drivers/serial/68328serial.c
> > > +++ b/drivers/serial/68328serial.c
> > > @@ -1413,10 +1413,10 @@ static void m68328_set_baud(void)
> > >  	USTCNT = ustcnt & ~USTCNT_TXEN;
> > >
> > >  again:
> > > -	for (i = 0; i < sizeof(baud_table) / sizeof(baud_table[0]); i++)
> > > +	for (i = 0; i < BAUD_TABLE_SIZE); i++)
> > typo? does this compile?
> will resubmit.

There are only two uses of BAUD_TABLE_SIZE
and MCFRS_BAUD_TABLE_SIZE.

I think it better to avoid
	#define SOME_SIZE ARRAY_SIZE(some_array)
and use ARRAY_SIZE(some_array) where possible.

NR_PORTS seems to be an exception.


