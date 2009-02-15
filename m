Return-Path: <linux-kernel-owner+w=401wt.eu-S1755871AbZBOV4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871AbZBOV4Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 16:56:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbZBOV4B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 16:56:01 -0500
Received: from hermes.cicese.mx ([158.97.1.34]:47857 "EHLO hermes.cicese.mx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751670AbZBOV4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 16:56:00 -0500
From: Serguei Miridonov <mirsev@cicese.mx>
To: Robert Hancock <hancockrwd@gmail.com>
Subject: Re: Intel ICH9M/M-E SATA error-handling/reset problems
Date: Sun, 15 Feb 2009 13:55:32 -0800
User-Agent: KMail/1.11.0 (Linux/2.6.27.12-170.2.5.fc10.i686; KDE/4.2.0; i686; ; )
Cc: linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       Tejun Heo <tj@kernel.org>
References: <200902141206.06419.mirsev@cicese.mx> <200902151141.44367.mirsev@cicese.mx> <499877C5.6090205@gmail.com>
In-Reply-To: <499877C5.6090205@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902151355.32596.mirsev@cicese.mx>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (hermes.cicese.mx [158.97.1.34]); Sun, 15 Feb 2009 13:55:37 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 February 2009, Robert Hancock wrote:
> Right now interface CRC error is considered an ATA bus error which
> always triggers a reset.

Well, my very strong opinion based just on general physics is that 
error rate on SATA can be (and will be) much higher than that one on 
PATA. PATA operates at lower frequencies and cables are much shorter. 
eSATA cables are longer and work at up to 3Gb/s. Moreover, consider 
all these consumer-grade connectors, cables, etc. So, CRC errors could 
be quite common and software needs to handle them properly to keep 
transfers fast and maintain the communication with a device.

> It's possible this could be relaxed in
> some cases, but the issue is that if CRC errors are occurring the
> link may be in an invalid state which simply retrying the command
> will not clear.

Let's think positively ;-). If CRC error occurs (in data or command 
sequence), the device just doesn't accept what it receives with the 
last transfer. So, it should wait what host says next. I think, before 
doing hard reset or whatever is necessary to completely restart the 
interface together with connected device - before doing that the 
kernel should try to check if link is up and the device is listenning. 
Why not to try a short request to let the device send something short 
in response?

> Tejun, any thoughts?
>
> > Another question is how the drive reacts to hard reset... My
> > error log shows that both drives do not like it for some reason -
> > they stop responding sometimes, so may be some additional
> > programming of drives is necessary after hard reset... Something
> > which is done in BIOS after power on... I don't know...
>
> The same hard reset is done (and generally has to be done) on
> driver initialization and when a drive is hot plugged, so it should
> work.

It depends... If hard reset is like a reboot for the driver firmware, 
it may take more that 30 seconds for Seagate external drive, though 
I'm not sure... Trying to push the interaface before the device is 
ready to receive commands may be considered by the drive as link 
problem and it may refuse to communicate. Well, again, I'm not 
familiar with this, just speculating...

> > ... Could you point me a link to the uncompressed
> > kernel tree where I can see source files?
>
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git is
> likely the easiest place to view..

Thank you, I'll take a look.


