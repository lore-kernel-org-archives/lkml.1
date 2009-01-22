Return-Path: <linux-kernel-owner+w=401wt.eu-S1755719AbZAVVTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719AbZAVVTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 16:19:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752273AbZAVVTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 16:19:11 -0500
Received: from wf-out-1314.google.com ([209.85.200.172]:32237 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbZAVVTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 16:19:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=U7KLA4oN03X0wOrvGp3TovyDxMKCHZZyODcnQ7vSX8hHbj03zur9rRTKZ0+sOVgG4k
         KKECfT8eVV9a2n6PJwsnq2+QHPxGwfrvXTYD0h19/z0o8v2awLnsdP/3BWEk3u8mip+o
         ikq3E/jvikrQzn0pwninGkqh/HrmNw9a/DnA8=
Subject: Re: [PATCH] w35und: fix usb_control_msg() error handling in
 wb35_probe()
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Pavel Machek <pavel@suse.cz>
Cc: Sandro Bonazzola <sandro.bonazzola@gmail.com>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20090122211052.GA1928@elf.ucw.cz>
References: <Pine.LNX.4.64.0901221205400.27341@melkki.cs.Helsinki.FI>
	 <20090122114237.GA13845@atrey.karlin.mff.cuni.cz>
	 <4978C812.90702@gmail.com>  <20090122211052.GA1928@elf.ucw.cz>
Content-Type: text/plain
Date: Thu, 22 Jan 2009 13:19:06 -0800
Message-Id: <1232659146.9701.76.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-22 at 22:10 +0100, Pavel Machek wrote:
> On Thu 2009-01-22 20:25:06, Sandro Bonazzola wrote:
> > -----BEGIN PGP SIGNED MESSAGE-----
> > Hash: SHA1
> > 
> > Pavel Machek ha scritto:
> > >> From: Pekka Enberg <penberg@cs.helsinki.fi>
> > >>
> > >> If successful, the usb_control_msg() function returns the number of
> > >> bytes transferred. Fix up wb35_probe() to only bail out if the function
> > >> returns a negative number.
> > >>
> > >> Reported-by: Sandro Bonazzola <sandro.bonazzola@gmail.com>
> > >> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> > > 
> > > Acked-by: Pavel Machek <pavel@suse.cz>
> > 
> > Ok, tested. Here is the result:
> > 
> > # uname -a
> > Linux arilinn 2.6.29-rc2-00013-gf3b8436-dirty #1 Thu Jan 22 19:39:23 CET 2009
> > x86_64 AMD Athlon(tm) 64 Processor 3500+ AuthenticAMD GNU/Linux
> > 
> > Inserting the USB device:
> > # dmesg
> > usb 1-3: new high speed USB device using ehci_hcd and address 4
> > usb 1-3: New USB device found, idVendor=18e8, idProduct=6201
> > usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> > usb 1-3: Product: Usb2Wlan
> > usb 1-3: Manufacturer: WINBOND
> > usb 1-3: SerialNumber: 101d350112
> > usb 1-3: configuration #1 chosen from 1 choice
> > w35und: module is from the staging directory, the quality is unknown, you have
> > been warned.
> > wmaster0 (usb): not using net_device_ops yet
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> This looks like a key clue...
> 
> Maybe you could try _current_ w35und on 2.6.28 or something like that?
> I have feeling that networking core changed in incompatible way here.
> 

I thought the net-device-ops conversion was opt in?  It shouldn't break
anything if the driver hasn't been converted yet.

Harvey

