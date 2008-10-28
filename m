Return-Path: <linux-kernel-owner+w=401wt.eu-S1753994AbYJ1QUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbYJ1QUb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 12:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbYJ1QUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 12:20:22 -0400
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:32118 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752016AbYJ1QUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 12:20:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Ss0n7MMFdJIXT5L7RhsFaf+XJQSZtu5LCiJ49i+3tZO0igb+f4xuh71ki71V1cqTq6zdz7/m/sOPCd00uxddEPCXUdDWfK3ORwIqzJcRUNuKW0TaMp9NTwKRgO9HFIcoDWoxGPpdy/hbfSLNywne4tbugd/6emCGjp0dE3Hut50=  ;
X-YMail-OSG: sG_92TgVM1noJQjnKbn14LUIkir_.im9yS9EFm5T9y_yGJf4wSeN6ZOrK9cl606jaUeUqabnLQPlHrcRmCY6ruEOAWVcM6O8qPs2tJ2CDKfhw2HFygXR6m_NWVwD1Z_V4YxljVPen1ptqSzJ7sq3Fofm
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: Re: [patch 2.6.28-rc2] atmel_serial: keep clock off when it's not needed
Date: Tue, 28 Oct 2008 09:20:19 -0700
User-Agent: KMail/1.9.10
Cc: lkml <linux-kernel@vger.kernel.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       Andrew Victor <linux@maxim.org.za>
References: <200810271406.24110.david-b@pacbell.net> <20081028124526.6b9ccdf5@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <20081028124526.6b9ccdf5@hskinnemo-gx745.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810280920.19864.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 October 2008, Haavard Skinnemoen wrote:
> David Brownell <david-b@pacbell.net> wrote:
> > From: David Brownell <dbrownell@users.sourceforge.net>
> > 
> > The atmel_serial driver is mismanaging its clock by leaving it on
> > at all times ... the whole point of clock management is to leave
> > it off unless it's actively needed, which conserves power!!
> > 
> > Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> 
> Hmm...the only remaining clk_enable() is in atmel_serial_pm(). Is that
> really enough?
> 
> It looks like the serial core calls ->pm() to power the port up before
> doing anything that might touch the registers, but I can't see that the
> console layer does the same thing...

I verified it on AT91, where the console is normally DBGU and the
other USARTs do get an open().

Didn't verify on AVR32, since 2.6.28-rc can't see the root FS because
of that NOR flash problem.  Though I suppose I can try it on an older
kernel.

As a rule the boot loader will be using that USART, and thus will
have enabled its clock.  :)

- Dave


> 
> Haavard
> 
> 


