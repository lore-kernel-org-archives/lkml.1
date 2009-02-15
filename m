Return-Path: <linux-kernel-owner+w=401wt.eu-S1752691AbZBOTmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbZBOTmY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 14:42:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbZBOTly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 14:41:54 -0500
Received: from hermes.cicese.mx ([158.97.1.34]:58059 "EHLO hermes.cicese.mx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752285AbZBOTlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 14:41:53 -0500
From: Serguei Miridonov <mirsev@cicese.mx>
To: Robert Hancock <hancockrwd@gmail.com>
Subject: Re: Intel ICH9M/M-E SATA error-handling/reset problems
Date: Sun, 15 Feb 2009 11:41:44 -0800
User-Agent: KMail/1.11.0 (Linux/2.6.27.12-170.2.5.fc10.i686; KDE/4.2.0; i686; ; )
Cc: linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>
References: <200902141206.06419.mirsev@cicese.mx> <200902151000.16688.mirsev@cicese.mx> <4998593D.2050300@gmail.com>
In-Reply-To: <4998593D.2050300@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902151141.44367.mirsev@cicese.mx>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (hermes.cicese.mx [158.97.1.34]); Sun, 15 Feb 2009 11:41:46 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 February 2009, Robert Hancock wrote:
> Serguei Miridonov wrote:
> > On Saturday 14 February 2009, Robert Hancock wrote:
> >> Serguei Miridonov wrote:
> > ... something like 10
> > errors per 2GB transfer can not be the reason to give up. Vista,
> > at least, recovers and continues the data transfer. Linux simply
> > can not return the interface or connected device into operating
> > mode. Do you think it is normal?
>
> Could be that Linux is being a bit more aggressive on error
> handling. In your case, it looks like an error occurred, triggering
> a hard reset of the device, and the controller seemed unable to
> talk to the device afterwards. If the command had just been
> retried, maybe it would have worked better. However, doing that in
> general can cause issues since you don't know what the state of the
> link may be..

Hmm... I was sure there are general recommendations from chipset 
vendors regarding recovery procedures.

What is the behavior expected from a SATA connected device if it 
detects parity error in received data? I'm not familiar with PATA/SATA 
protocols but I suppose that it just doesn't send data to the physical 
disk for recording, asserts the error line and waits next command from 
the controller. If the data block was too big to keep it in the drive 
cache memory, it may also set number of successfully (physically) 
written bytes to prevent the software to send it again.

If the above is correct then the kernel should only log the error, do 
some housekeeping work for the controller and attempt to send data 
again. There is no need for hard reset right after first error.

Another question is how the drive reacts to hard reset... My error log 
shows that both drives do not like it for some reason - they stop 
responding sometimes, so may be some additional programming of drives 
is necessary after hard reset... Something which is done in BIOS after 
power on... I don't know...

Well, it becomes interesting... I've got datasheet for ICH9 but don't 
have a kernel driver source to check what messages in log file really 
mean. Could you point me a link to the uncompressed kernel tree where 
I can see source files?

