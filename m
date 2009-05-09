Return-Path: <linux-kernel-owner+w=401wt.eu-S1753782AbZEIRRI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782AbZEIRRI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 13:17:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752255AbZEIRQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 13:16:54 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52721 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751667AbZEIRQx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 13:16:53 -0400
Date: Sat, 9 May 2009 18:15:59 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Pantelis Koukousoulas <pktoss@gmail.com>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: usbfs, claiming entire usb devices
Message-ID: <20090509181559.664b141a@lxorguk.ukuu.org.uk>
In-Reply-To: <ac3eb2510905091000y4c7a6448uce799d00d500fffe@mail.gmail.com>
References: <ac3eb2510905071612v61a27760hffc684ee87df9249@mail.gmail.com>
	<Pine.LNX.4.44L0.0905081000140.3010-100000@iolanthe.rowland.org>
	<ac3eb2510905091000y4c7a6448uce799d00d500fffe@mail.gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Yes.  That is, a process shouldn't be allowed to access a locked device
> > unless that process is the lock holder.
> 
> You think the pid or the uid would make more sense?

How about neither ?

The standard Unix behaviour is to open the file O_EXCL if you want
exclusivity. Neither uid or pid are helpful or work in the many
environments where you want security - in particular where (as is very
common with user space driver type code) you want parts of your code
running setuid and parts not, as two processes with different pid and uid
values.

If O_EXCL is interpeted as exclusive access (versus kernel and re-open of
the same node) then you can implement the rest of the sematics in user
space.

Alan
