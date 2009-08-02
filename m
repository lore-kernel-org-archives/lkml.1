Return-Path: <linux-kernel-owner+w=401wt.eu-S1753836AbZHBVJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbZHBVJj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 17:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753657AbZHBVJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 17:09:39 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:65260 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646AbZHBVJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 17:09:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Wtinxsx2BFyrhdCwjCTbMl7UVC46iBFBYgv7gaRdnQtlqF9QqimglvXRlAOq5iJ/Rp
         rINqy6GgAspJ0uitB0V4hrbdXori674Ctc+PSm+cJP4FoYWZX0pxX+C4KMBNwR6WZiOO
         lDQLBWhXkKEjrC1SfTaMqdnBVrepKR+APkeaE=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.0908021650020.14120-100000@netrider.rowland.org>
References: <81b0412b0908021339s739c07edvd4d5eb4c21cfa167@mail.gmail.com>
	 <Pine.LNX.4.44L0.0908021650020.14120-100000@netrider.rowland.org>
Date: Sun, 2 Aug 2009 23:09:37 +0200
Message-ID: <81b0412b0908021409h73fc2fcfo64c4ba9ee1f0d552@mail.gmail.com>
Subject: Re: Oops in CDC ACM after an Openmoko phone (neo1973) changes its usb 
	interface from ACM to Ethernet
From: Alex Riesen <raa.lkml@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
       Oliver Neukum <oliver@neukum.name>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <greg@kroah.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 2, 2009 at 22:50, Alan Stern<stern@rowland.harvard.edu> wrote:
> On Sun, 2 Aug 2009, Alex Riesen wrote:
>
>> Any idea how to disable stack dumps so that there is more place
>> for other output on a laptop screen? (no chance for serial console)
>
> Put a "return" statement at the start of dump_stack().
>

That wasn't enough, but a "return" in die helped.

So, I connect the device, run its bootloader, which causes
a CDC ACM interface to appear. The /dev/ttyACM0 node
appears, and I open it (with minicom). Then I just switch
the device off and kernel oopses with:

uhci_hcd 0000:00:1d.0: release dev 4 ep81-INT, period 128, phase 0, 23 us
usb 5-1: uhci_result_common: failed with status 440000
usb 5-1: uhci_result_common: failed with status 440000
uhci_hcd 0000:00:1d.0: shutdown urb ffff88007de6bf00 ep3in-bulk
BUG: unable to handle kernel NULL pointer dereference at 0000000000000003
IP: [<ffffffffa005ce38>] acm_rx_tasklet+0x24e/0x3a3 [cdc_acm]
... something will be missing here
---[ end trace ...]---
Kernel panic - not syncing: Fatal exception in interrupt
