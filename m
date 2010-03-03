Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab0CCMLY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 07:11:24 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36951 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751325Ab0CCMLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 07:11:23 -0500
Date: Wed, 3 Mar 2010 12:14:41 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Peter Feuerer <peter@piie.net>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] usb-serial / pl2302 corrupted receive
Message-ID: <20100303121441.622e271f@lxorguk.ukuu.org.uk>
In-Reply-To: <20100302235353.GB2196@kroah.com>
References: <cone.1267466820.296261.3385.1000@deskpiie>
	<20100302235353.GB2196@kroah.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Terminal1:
> > cat /dev/ttyUSB1
> > 
> > Terminal2:
> > while true; do echo 123456789012345678901234567890 > /dev/ttyUSB0 ; done
> 
> cat and echo are known to not work well with usb to serial devices.  Can
> you duplicate this with a "real" tty program like minicom or something
> else?

That should no longer be the case. The kfifo buffering implementation
fixed all the broken internal buffering in the usb tty code - or should
have done.

Definitely worthy of more investigation if the second open/closes are
disrupting stuff.
