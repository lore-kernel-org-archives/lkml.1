Return-Path: <linux-kernel-owner+w=401wt.eu-S1754262AbYJ1RvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262AbYJ1RvB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 13:51:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752532AbYJ1Rux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 13:50:53 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:59811 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504AbYJ1Ruw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 13:50:52 -0400
Date: Tue, 28 Oct 2008 18:48:57 +0100
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: David Brownell <david-b@pacbell.net>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       Andrew Victor <linux@maxim.org.za>
Subject: Re: [patch 2.6.28-rc2] atmel_serial: keep clock off when it's not
 needed
Message-ID: <20081028184857.030d029a@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <200810281008.12874.david-b@pacbell.net>
References: <200810271406.24110.david-b@pacbell.net>
	<200810280920.19864.david-b@pacbell.net>
	<20081028173733.7ba951de@hskinnemo-gx745.norway.atmel.com>
	<200810281008.12874.david-b@pacbell.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 28 Oct 2008 17:48:38.0790 (UTC) FILETIME=[68946A60:01C93925]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell <david-b@pacbell.net> wrote:
> > > I verified it on AT91, where the console is normally DBGU and the
> > > other USARTs do get an open().
> > > 
> > > Didn't verify on AVR32, since 2.6.28-rc can't see the root FS because
> > > of that NOR flash problem.  Though I suppose I can try it on an older
> > > kernel.
> > > 
> > > As a rule the boot loader will be using that USART, and thus will
> > > have enabled its clock.  :)  
> > 
> > Hmm. But in the cases when "normally" and "as a rule" don't apply, the
> > board will lock up solid with no console output since it will wait
> > forever for the TXRDY bit to be set...
> > 
> > I'd like to know for sure that it cannot happen, please.  
> 
> I'd just like to know that this bug is fixed.  Do you have a
> better fix?  (And a board broken by this patch, to verify it?)

Fixing a bug by introducing a worse one isn't much of an improvement.
The bug may be difficult to trigger, but that makes it even worse,
IMO.

I'll see if I can come up with a fix. Basically, we need to enable the
clock when initializing the console, and disable it after calling
uart_add_one_port() if the port is the console.

Haavard
