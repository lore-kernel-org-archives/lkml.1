Return-Path: <linux-kernel-owner+w=401wt.eu-S1753831AbZEVJw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831AbZEVJw0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 05:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751764AbZEVJwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 05:52:18 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48142 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751042AbZEVJwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 05:52:18 -0400
Date: Fri, 22 May 2009 10:53:13 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kyle Moffett <kyle@moffetthome.net>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Alan Stern <stern@rowland.harvard.edu>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: How to tell whether a struct file is held by a process?
Message-ID: <20090522105313.63e309f0@lxorguk.ukuu.org.uk>
In-Reply-To: <f73f7ab80905211828te5c49dcx863a18c8e428a59f@mail.gmail.com>
References: <20090521095217.GU8633@ZenIV.linux.org.uk>
	<Pine.LNX.4.44L0.0905210945290.2886-100000@iolanthe.rowland.org>
	<ac3eb2510905211407l3aec14acx2572a2ad4e675b9@mail.gmail.com>
	<20090521231452.676d4898@lxorguk.ukuu.org.uk>
	<f73f7ab80905211828te5c49dcx863a18c8e428a59f@mail.gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> the OP), is to make there be a global "prevent kernel drivers from
> autobinding to  devices on his port" flag, and manage the rest with
> lockfiles in userspace.

Your "practical example" seems to bear no relation to the other stuff,
its a separate topic altogether.

Yes a "don't probe this port" would make sense. The fact kernel space
probes the USB devices by default like the fact we probe partitions by
default and scan scsi busses by default are all really mistakes inherited
from traditional OS designs which also mess up virtualisation the same
way.

So add a skip_ports= facility to the usb core code (or a general
auto_enumerate=0 and a udev interface to trigger scanning so your udev
rules can enumerate just the ports you want). That is probably cleaner
because it makes the identification of ports rather cleaner and clearer.

Alan
