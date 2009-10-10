Return-Path: <linux-kernel-owner+w=401wt.eu-S1762113AbZJJUmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762113AbZJJUmb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 16:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762055AbZJJUma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 16:42:30 -0400
Received: from netrider.rowland.org ([192.131.102.5]:34451 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1762047AbZJJUm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 16:42:29 -0400
Date: Sat, 10 Oct 2009 16:41:51 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Josua Dietze <digidietze@draisberghof.de>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ben Efros <ben@pc-doctor.com>, fangxiaozhi <huananhu@huawei.com>,
       Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, Hugh Blemings <hugh@blemings.org>
Subject: Re: USB serial regression 2.6.31.1 -> 2.6.31.2
In-Reply-To: <Pine.LNX.4.44L0.0910101220540.3859-100000@netrider.rowland.org>
Message-ID: <Pine.LNX.4.44L0.0910101637030.6451-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Oct 2009, Alan Stern wrote:

> On Sat, 10 Oct 2009, Josua Dietze wrote:
...
> > This is one of the mode switching devices. It is switched to modem 
> > mode by "usb_stor_huawei_e220_init".
> > 
> > Something keeps resetting it to initial mode. It might be a 
> > powersave/suspend issue.
> 
> It's not related to powersave or suspend.  (Although both trace files
> show that the device's remote-wakeup feature did get enabled; I have no
> idea what code was responsible for doing that.  AFAIK it shouldn't
> happen unless the device is about to be suspended.)

It turns out that the remote-wakeup enable _is_ the mode-switch
command.  Don't ask me why the manufacturer decided to use an
pre-existing command to tell the device to switch modes.

Anyway, it's clear from the logs that the mode switch worked in both 
cases.  Initially the device shows only one interface, and after the 
mode switch it shows four.

Alan Stern

