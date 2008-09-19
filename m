Return-Path: <linux-kernel-owner+w=401wt.eu-S1754422AbYISPNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbYISPNS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 11:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750927AbYISPNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 11:13:04 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:34893 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762AbYISPNC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 11:13:02 -0400
Date: Fri, 19 Sep 2008 17:11:15 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Anti Sullin <anti.sullin@artecdesign.ee>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] AT91 Serial: update the powersave handler to match
 serial core
Message-ID: <20080919171115.08594550@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <20080919155109.32dc282d@lxorguk.ukuu.org.uk>
References: <48CE42C8.1090608@artecdesign.ee>
	<20080919150938.08b2c7be@hskinnemo-gx745.norway.atmel.com>
	<48D3AE78.207@artecdesign.ee>
	<20080919161625.360e514d@hskinnemo-gx745.norway.atmel.com>
	<20080919155109.32dc282d@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 19 Sep 2008 15:11:05.0610 (UTC) FILETIME=[EFEF5EA0:01C91A69]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > Maybe the tty layer ensures that the buffer is empty before
> > suspending...would be interesting to know. In any case, any such bug  
> 
> It doesn't - but calling tty_wait_until_sent(tty, some_timeout) will do
> that for you providing you call it in a sleep capable context.

Looks like it doesn't matter -- the serial core shuts the port down
completely, which will among other things disable the DMA controller.

Haavard
