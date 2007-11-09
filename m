Return-Path: <linux-kernel-owner+w=401wt.eu-S1757696AbXKIWii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757696AbXKIWii (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 17:38:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754193AbXKIWia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 17:38:30 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:23218 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbXKIWi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 17:38:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent;
        b=Elfe5/DGwWjNtCk5NWTeE0xy48ZhA/H75DW7uQjXYhWgjnYrKpDrttzzrU29J35FKvov6wE7ePrcFm1pyTjxGQnA1ZFZiZVSIZFKSGCJLFkYCFEk/z6PLQ8hMvWZMJQWA5h7V3NtqxOdLiv0SO4tNwJzVVz2Q2RhxC4TBNDLQPE=
Date: Sat, 10 Nov 2007 05:38:02 +0700
From: Riki Oktarianto <rkoktarianto@gmail.com>
To: =?iso-8859-1?B?VPZy9ms=?= Edwin <edwintorok@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, Mark Lord <liml@rtr.ca>,
       linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org
Subject: Re: [PATCH] Add quirk to set AHCI mode on ICH boards
Message-ID: <20071109223802.GA23004@ceren>
References: <20071109020235.GA2031@ceren> <20071109023129.GA25581@havoc.gtf.org> <4733D421.7000505@rtr.ca> <20071109034622.GB25581@havoc.gtf.org> <20071109120425.543971bf@the-village.bc.nu> <4734736C.5060003@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4734736C.5060003@gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 09, 2007 at 04:49:16PM +0200, Török Edwin wrote:
> There is one problem with force enabling ahci. You'll loose the CDROM on
> Dell laptops.
> Prior to force-enabling ahci there is one "device" that sees the 2 sata
> channels, and the 2 ide channels.
> When you force-enable ahci, this device becomes the ahci controller (it
> changes the device id),
> and the IDE controller will appear as a separate new device (with
> another device id), but it is disabled.
> 
> There are registers on the ICH7 that allows you to set enabled/disabled
> status, but according to the documentation you should not enable a
> device after it has been disabled. In practice I couldn't get the CDROM
> to get re-enabled:
> * either nothing happend
> * spurious irqs were sent that nobody handles, unless I used irq=poll;
> but still no cdrom.
> 
> Force-enabling AHCI, and not trying to enable the CDROM works, although
> I occasionally got NCQ errors.
> 
> For a (long) discussion see this thread on the powertop mailing list:
> http://www.bughost.org/pipermail/power/2007-June/000533.html
> http://www.bughost.org/pipermail/power/2007-June/000573.html
> 
> And there is also another slightly different approach:
> http://mjg59.livejournal.com/76062.html
> 
> Best regards,
> --Edwin
> 

In the MacBook, after enabling ahci the IDE controller also appeared as a
separate new device, but it is enabled and handled correctly by piix.

I haven't got any problem, even suspend/resume works fine.

Lucky us who got the ABAR mapped by the BIOS...

-- 
Riki Oktarianto
