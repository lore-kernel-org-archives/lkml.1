Return-Path: <linux-kernel-owner+w=401wt.eu-S1752498Ab0AZHNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498Ab0AZHNk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 02:13:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752168Ab0AZHNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 02:13:38 -0500
Received: from smtp106.sbc.mail.gq1.yahoo.com ([67.195.14.109]:44359 "HELO
	smtp106.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750799Ab0AZHNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 02:13:37 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Jan 2010 02:13:37 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=i19jjokGdKifz83oKLcRIfb3B0zANn6RIpaTbGijZF3RQ+2afuLZe4H6HkJX10zRerubnde1wnQyDm4p0rQ8IDrZWaWhxlYmv81t3N9QoyAwIi54AuZomEkxPd8kKUfHZBaG7f/a+QeB8MrBBCe9ab2g00/iL1R88GRakN7oKjs=  ;
X-Yahoo-SMTP: 2V1ThQ.swBDh24fWwg9PZFuY7TTwFsTuVtXZ.8DKSgQ-
X-YMail-OSG: saO195YVM1kdPgmSZ_g2rUBp3CWAihHbvJgoPsGMj6DcktV3xRJvs.dtYrZ6fgIqzICMgXLpDqUrVizM4NHe.i8A6gqN59owWLYtdD2cvlPdeMefeZR9XUjQST72O_WvDD4GUV.LK2y70VfuNY9lpEunMzocA0QAX7sWVhAcV1dOZ2_z3iuPLhXwZ0V49KL7FlGkQV6PC4VgpU7cHy48gDTvLhPndy2SF3YhfRfyfD6e4pmVT0NdzmCDL1CmFCCY
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Felipe Balbi <felipe.balbi@nokia.com>
Subject: Re: [RFC/PATCH 0/4] twl4030 threaded_irq support
Date: Mon, 25 Jan 2010 23:06:55 -0800
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>,
       Aaro Koskinen <aaro.koskinen@nokia.com>,
       Linux USB Mailing List <linux-usb@vger.kernel.org>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Grazvydas Ignotas <notasas@gmail.com>,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Samuel Ortiz <sameo@openedhand.com>
References: <20091212183410.GF3092@sirena.org.uk> <1260786654-13294-1-git-send-email-felipe.balbi@nokia.com>
In-Reply-To: <1260786654-13294-1-git-send-email-felipe.balbi@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001252306.55625.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 December 2009, Felipe Balbi wrote:
> move twl4030 children to threaded irq.
> 
> Felipe Balbi (4):
>   input: keyboard: twl4030: move to request_threaded_irq
>   input: misc: twl4030: move to request_threaded_irq
>   rtc: twl4030: move to request_threaded_irq
>   usb: otg: twl4030: move to request_threaded_irq

But nothing in drivers/mfd ... the entry to the whole stack?

Did the threaded IRQ stuff ever get set up so that the top
level IRQ thread didn't have to hand off to another thread
each time?  (That's how the current stuff works.  One thread
calling out to each handler.)

If so, I'd like to see that be used here, rather than needlessly
spend all those pages on mostly-unused stacks.  


> 
>  drivers/input/keyboard/twl4030_keypad.c |   11 ++---------
>  drivers/input/misc/twl4030-pwrbutton.c  |   12 +-----------
>  drivers/rtc/rtc-twl4030.c               |   10 +---------
>  drivers/usb/otg/twl4030-usb.c           |   10 +---------
>  4 files changed, 5 insertions(+), 38 deletions(-)
> 
> 


