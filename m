Return-Path: <linux-kernel-owner+w=401wt.eu-S1754603AbYISPrK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbYISPrK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 11:47:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbYISPq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 11:46:57 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:35353 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752283AbYISPq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 11:46:56 -0400
Date: Fri, 19 Sep 2008 17:46:15 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Michael Trimarchi <trimarchimichael@yahoo.it>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Victor <linux@maxim.org.za>,
       Anti Sullin <anti.sullin@artecdesign.ee>
Subject: Re: [PATCH] atmel_serial: update the powersave handler to match
 serial core
Message-ID: <20080919174615.26db9e8a@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <393.6138.qm@web26208.mail.ukl.yahoo.com>
References: <393.6138.qm@web26208.mail.ukl.yahoo.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 19 Sep 2008 15:46:09.0782 (UTC) FILETIME=[D61E8960:01C91A6E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Trimarchi <trimarchimichael@yahoo.it> wrote:
> > +    /* we can not wake up if we're running on slow clock */
> > +    atmel_port->may_wakeup = device_may_wakeup(&pdev->dev);
> > +    if (atmel_serial_clk_will_stop())
> > +        device_set_wakeup_enable(&pdev->dev, 0);
> > +  
> This is not true, the wakeup in the slow clock is possible, configure the
> input pin of the serial device as a gpio, and wake up on gpio. Then you
> must reconfigure as a serial pin, and you can wake up on slow clock.

Yes, but the current driver doesn't actually support that, does it?

This patch doesn't really change that assumption anyway -- it just
implements it in a way more consistent with the current serial core.

Haavard
