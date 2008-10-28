Return-Path: <linux-kernel-owner+w=401wt.eu-S1753709AbYJ1RTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709AbYJ1RTe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 13:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753294AbYJ1RTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 13:19:23 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:36689 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752457AbYJ1RTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 13:19:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=jCFN7jBWYuJNGUNKkdy4XgM7KE2FWVK3lds6fTk0YGbJp4/vbBNMxWpf2XGk8QutEPEjujk7zbEGhQhbYawD84XHhXv2sBh1Kanij+Tt9bXmfHXv9YiyL/mjNp5ir+B8cEhYtbnYuuUh+h77E0bhwuu37lJfeGc+ut/L/SKwOzU=  ;
X-YMail-OSG: ZwgmKa8VM1n_L2HNUCO8m6e8lmy.UElnSlLnNNZX4tSZbMkbSgixAjMIQbWT892PA.A6LMjlCBkeM.TbxTuCVGqUV6oaBDQ_NOxmJUCXOrtwkuUwMNRsYzWEjgEoQIqiiV4kyaUgnJg1yah9D_NjT9ps
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: Re: [patch 2.6.28-rc2] atmel_serial: keep clock off when it's not needed
Date: Tue, 28 Oct 2008 10:08:12 -0700
User-Agent: KMail/1.9.10
Cc: lkml <linux-kernel@vger.kernel.org>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       Andrew Victor <linux@maxim.org.za>
References: <200810271406.24110.david-b@pacbell.net> <200810280920.19864.david-b@pacbell.net> <20081028173733.7ba951de@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <20081028173733.7ba951de@hskinnemo-gx745.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810281008.12874.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 October 2008, Haavard Skinnemoen wrote:
> David Brownell <david-b@pacbell.net> wrote:
> > On Tuesday 28 October 2008, Haavard Skinnemoen wrote:
> > > David Brownell <david-b@pacbell.net> wrote:
> > > > From: David Brownell <dbrownell@users.sourceforge.net>
> > > > 
> > > > The atmel_serial driver is mismanaging its clock by leaving it on
> > > > at all times ... the whole point of clock management is to leave
> > > > it off unless it's actively needed, which conserves power!!
> > > > 
> > > > Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> > > 
> > > Hmm...the only remaining clk_enable() is in atmel_serial_pm(). Is that
> > > really enough?
> > > 
> > > It looks like the serial core calls ->pm() to power the port up before
> > > doing anything that might touch the registers, but I can't see that the
> > > console layer does the same thing...
> > 
> > I verified it on AT91, where the console is normally DBGU and the
> > other USARTs do get an open().
> > 
> > Didn't verify on AVR32, since 2.6.28-rc can't see the root FS because
> > of that NOR flash problem.  Though I suppose I can try it on an older
> > kernel.
> > 
> > As a rule the boot loader will be using that USART, and thus will
> > have enabled its clock.  :)
> 
> Hmm. But in the cases when "normally" and "as a rule" don't apply, the
> board will lock up solid with no console output since it will wait
> forever for the TXRDY bit to be set...
> 
> I'd like to know for sure that it cannot happen, please.

I'd just like to know that this bug is fixed.  Do you have a
better fix?  (And a board broken by this patch, to verify it?)

- Dave

