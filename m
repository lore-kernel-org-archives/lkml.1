Return-Path: <linux-kernel-owner+w=401wt.eu-S1753139AbYJ1Qhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139AbYJ1Qhh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 12:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbYJ1Qh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 12:37:29 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:57103 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954AbYJ1Qh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 12:37:28 -0400
Date: Tue, 28 Oct 2008 17:37:33 +0100
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: David Brownell <david-b@pacbell.net>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       Andrew Victor <linux@maxim.org.za>
Subject: Re: [patch 2.6.28-rc2] atmel_serial: keep clock off when it's not
 needed
Message-ID: <20081028173733.7ba951de@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <200810280920.19864.david-b@pacbell.net>
References: <200810271406.24110.david-b@pacbell.net>
	<20081028124526.6b9ccdf5@hskinnemo-gx745.norway.atmel.com>
	<200810280920.19864.david-b@pacbell.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 28 Oct 2008 16:37:15.0492 (UTC) FILETIME=[6F890240:01C9391B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell <david-b@pacbell.net> wrote:
> On Tuesday 28 October 2008, Haavard Skinnemoen wrote:
> > David Brownell <david-b@pacbell.net> wrote:
> > > From: David Brownell <dbrownell@users.sourceforge.net>
> > > 
> > > The atmel_serial driver is mismanaging its clock by leaving it on
> > > at all times ... the whole point of clock management is to leave
> > > it off unless it's actively needed, which conserves power!!
> > > 
> > > Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> > 
> > Hmm...the only remaining clk_enable() is in atmel_serial_pm(). Is that
> > really enough?
> > 
> > It looks like the serial core calls ->pm() to power the port up before
> > doing anything that might touch the registers, but I can't see that the
> > console layer does the same thing...
> 
> I verified it on AT91, where the console is normally DBGU and the
> other USARTs do get an open().
> 
> Didn't verify on AVR32, since 2.6.28-rc can't see the root FS because
> of that NOR flash problem.  Though I suppose I can try it on an older
> kernel.
> 
> As a rule the boot loader will be using that USART, and thus will
> have enabled its clock.  :)

Hmm. But in the cases when "normally" and "as a rule" don't apply, the
board will lock up solid with no console output since it will wait
forever for the TXRDY bit to be set...

I'd like to know for sure that it cannot happen, please.

Haavard
