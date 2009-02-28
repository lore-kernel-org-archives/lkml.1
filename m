Return-Path: <linux-kernel-owner+w=401wt.eu-S1754715AbZB1ULA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbZB1ULA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 15:11:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753239AbZB1UKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 15:10:51 -0500
Received: from n19.bullet.mail.mud.yahoo.com ([68.142.206.146]:38850 "HELO
	n19.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752932AbZB1UKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 15:10:50 -0500
X-Yahoo-Newman-Id: 857909.67316.bm@omp406.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=0tVJ/4iq2fRlEA5ZSndvMloGNRdkXCoUUSB3N05OLdynE/1+LzZlbe2h1c29G0ndemZG2stvFhYnHTOLYrBxxvgEux+e3yP7sGBtXfxYJykuxIm9xXNmJ6dlFVuDpBQJBldic2oUlxu51mxJkQS0804uH8+5BTL92CAtZHzKP1A=  ;
X-YMail-OSG: wDYpDDYVM1ll07OELGUPjpiesZLg5iVYI7lJKI8p5xrrhmAd77EgZg6BZap1LVSCzvQszlB7Mv6_tETmo32h4hBbPPQWA7k3UZ1S1Htop_mt.oicnZ7nb2gIzh4o_7r5JE9YCh6mFKDklV1j4yHtRK5C
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: lockdep and threaded IRQs
Date: Sat, 28 Feb 2009 12:10:46 -0800
User-Agent: KMail/1.9.10
Cc: me@felipebalbi.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       felipe.balbi@nokia.com, dmitry.torokhov@gmail.com, sameo@openedhand.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <200902271350.32380.david-b@pacbell.net> <49A91DE8.7000700@s5r6.in-berlin.de>
In-Reply-To: <49A91DE8.7000700@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902281210.46672.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 28 February 2009, Stefan Richter wrote:
> David Brownell wrote:
> > The other is that Linux needs real support for threaded
> > interrupts.  Almost every I2C (or SPI) device that raises
> > an IRQ needs its IRQ handler to run in a thread, and most
> > of them have the same type of workqueue-based hack to
> > get such a thread.  (Some others have bugs instead...)
> 
> Since when is having an IRQ handler scheduling a workqueue job a hack?

The only "hack" I recall mentioning was the need to
forcibly re-enable IRQs that lockdep wrongly disabled.


> In kernels whose IRQ handlers don't sleep, we don't pretend that they
> could; instead we defer sleeping work to a context which can sleep.
> 
> Or from another angle:  If a driver requires a kernel with sleeping IRQ
> handlers, why submit it for inclusion into a kernel which does not

(yet)

> provide nonatomic context to IRQ handlers?

Or from yet another angle:  how will progress ever happen
if nobody pushes the boundaries?  :)

We've known for ages that threaded IRQs will eventually
show up in mainline.  Better IMO to plan for that, and
expect minor changes to the drivers which have needed them
all along.

- Dave

