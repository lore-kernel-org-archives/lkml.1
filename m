Return-Path: <linux-kernel-owner+w=401wt.eu-S1753341AbYJ1JVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbYJ1JVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 05:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752398AbYJ1JVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 05:21:10 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59200 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751527AbYJ1JVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 05:21:09 -0400
Date: Tue, 28 Oct 2008 09:21:08 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sebastian Kuzminsky <seb@highlab.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: getting configuration info into a driver at load-time
Message-ID: <20081028092108.5d517d30@lxorguk.ukuu.org.uk>
In-Reply-To: <4906499C.8090308@highlab.com>
References: <4906499C.8090308@highlab.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I thought about exposing this config structure in /sys or /proc (in a 
> per-board directory), and let the user poke in the config values after 
> the driver has loaded, but I'd really prefer to make the information 
> available at load-time.

Various drivers do load it after load time (and for one that allows you
to change the configuration without a restart which is usually a good
thing). In some cases driver that need a configuration to do sane things
fails other I/O with an error like EIO until a configuration is
established via ioctl or sysfs or similar.
 
> Currently the driver has a module param array of char*, with each 
> board's configuration encoded into an ascii string which gets decoded 
> "by hand" in the driver.  Pretty grotty.
> 
> Is there some easier/cleaner way to do this?

You can always request_firmware() the tables... bit hackish but works

Alan
