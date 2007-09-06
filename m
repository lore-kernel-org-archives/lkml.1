Return-Path: <linux-kernel-owner+w=401wt.eu-S1757495AbXIFT4E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495AbXIFT4E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 15:56:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758234AbXIFTzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 15:55:50 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51413 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758256AbXIFTzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 15:55:48 -0400
Subject: Re: video4linux, bttv, vbi and missing lines in teletext...
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Manuel Reimer <Manuel.Spam@nurfuerspam.de>
Cc: linux-kernel@vger.kernel.org,
       Linux and Kernel Video <video4linux-list@redhat.com>
In-Reply-To: <fbp5ra$ih7$1@sea.gmane.org>
References: <fbdr9c$hqi$1@sea.gmane.org>  <fbp5ra$ih7$1@sea.gmane.org>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 06 Sep 2007 20:56:08 +0100
Message-Id: <1189108568.10203.19.camel@areia>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.91-1mdv2008.0 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Manuel,

I noticed you've opened a thread about this at both V4L ML and LKML. The
better place for you is to discuss this issue at V4L ML. LKML is very
generic and just a very small group of people working with those devices
could help you. Those are also listening at V4L, among with several
other guys.

Em Qui, 2007-09-06 às 17:25 +0200, Manuel Reimer escreveu:
> Manuel Reimer wrote:
> > Today I'll visit someone, who has a Windows PC. I've already removed the 
> > bt878 card from my PC. I'll try at his PC, if I get the same problem 
> > with the original driver and TV watching software. If this works, I'll 
> > boot Knoppix from his PC to get sure, that I also get the same problems 
> > on his PC with his video source. I'll tell you about the results of my 
> test.
> 
> I tried my card on the windows PC, but we wasn't able to install the 
> original driver, as it is outdated and didn't install on Windows XP. So 
> we used:
> 
> http://sourceforge.net/projects/btwincap
> 
> Using this driver, I had exactly the same problem, I also have on Linux. 
> I was able to get a second card, which is the same model, I have. I 
> tried the second one, too and also have the missing lines with the 
> second card.

Maybe the windows driver you took may be using the same VBI algorithm as
the Linux driver.

> Now I don't know, if this is a driver problem, or if this model of bt878 
> card is just cheap shit.

I suspect it is just a matter of proper settings.

The bttv hardware only provide "raw VBI". It means that it will return
to a program whatever stuff were sent during VBI (*). 

(*) VBI is a timing interval that exists at analog transmissions between
the end of one line and the start of another. It were meant to give some
time to the electron beam to move from one line to another.

For BTTV driver, you just set-up to adquire VBI or not. There are some
standard-based definitions, like the expected VBI intervals, and the
interval where VBI collect starts.

The hard work is doing at software decoding level, where a filtering
process takes place, to analise if the patterns makes some sense,
according with some specification, like teletext. If it makes sense, the
decoding occurs.

Maybe your board is collecting VBI sooner (or later) than expected, and
this is causing the missfunction of your userspace app.

Anyway, Michael Schimek send you some glues at V4L ML. He is one of the
authors of those VBI decoding tools. So, I'm sure he can guide you to a
proper solution.

Cheers,
Mauro


