Return-Path: <linux-kernel-owner+w=401wt.eu-S1762145AbZJJVVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762145AbZJJVVp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 17:21:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758610AbZJJVVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 17:21:44 -0400
Received: from gate.crashing.org ([63.228.1.57]:44152 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761622AbZJJVVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 17:21:43 -0400
Subject: Re: USB serial regression 2.6.31.1 -> 2.6.31.2
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Josua Dietze <digidietze@draisberghof.de>, Ben Efros <ben@pc-doctor.com>,
       fangxiaozhi <huananhu@huawei.com>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, Hugh Blemings <hugh@blemings.org>
In-Reply-To: <Pine.LNX.4.44L0.0910101637030.6451-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.0910101637030.6451-100000@netrider.rowland.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 11 Oct 2009 08:20:17 +1100
Message-Id: <1255209617.3387.9.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-10-10 at 16:41 -0400, Alan Stern wrote:
> On Sat, 10 Oct 2009, Alan Stern wrote:
> 
> > On Sat, 10 Oct 2009, Josua Dietze wrote:
> ...
> > > This is one of the mode switching devices. It is switched to modem 
> > > mode by "usb_stor_huawei_e220_init".
> > > 
> > > Something keeps resetting it to initial mode. It might be a 
> > > powersave/suspend issue.
> > 
> > It's not related to powersave or suspend.  (Although both trace files
> > show that the device's remote-wakeup feature did get enabled; I have no
> > idea what code was responsible for doing that.  AFAIK it shouldn't
> > happen unless the device is about to be suspended.)
> 
> It turns out that the remote-wakeup enable _is_ the mode-switch
> command.  Don't ask me why the manufacturer decided to use an
> pre-existing command to tell the device to switch modes.
> 
> Anyway, it's clear from the logs that the mode switch worked in both 
> cases.  Initially the device shows only one interface, and after the 
> mode switch it shows four.

Yes, that works, you can see the ttyUSBx ports showing up. It looks like
it may just be the resets coming from usb-storage that are breaking
things.

Cheers,
Ben.


