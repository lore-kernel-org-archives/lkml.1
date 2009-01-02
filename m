Return-Path: <linux-kernel-owner+w=401wt.eu-S1758467AbZABMBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758467AbZABMBj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 07:01:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757447AbZABMB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 07:01:29 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37491 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757384AbZABMB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 07:01:28 -0500
Date: Fri, 2 Jan 2009 13:01:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Scholz <scholz@fias.uni-frankfurt.de>
Cc: linux-kernel@vger.kernel.org, stern@rowland.harvard.edu, gregkh@suse.de,
       marcel@holtmann.org
Subject: Re: [BUG] Regression in v2.6.28 introduced by: 'USB: skip
	Set-Interface(0) if already in altsetting 0'
Message-ID: <20090102120109.GC3027@elte.hu>
References: <87ljtu7yvi.fsf@scholz.fias.uni-frankfurt.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ljtu7yvi.fsf@scholz.fias.uni-frankfurt.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Scholz <scholz@fias.uni-frankfurt.de> wrote:

> Hi,
> 
> In v2.6.28 my usb bluetooth device disappears after suspend to ram:
> 
> $ hcitool dev
> Devices:
> 	hci0	00:0D:93:15:D6:E8
> $ echo mem > /sys/power/state 
> $ hcitool dev
> Devices:
> $
> 
> The problem does not occur with the (older) hci_usb.ko, but only with
> btusb.ko.
>  
> This is the output of lsusb:
> Bus 001 Device 003: ID 05ac:8203 Apple Computer, Inc. Bluetooth HCI
> 
> Bisecting finds commit 24c0996 (USB: skip Set-Interface(0) if already in
> altsetting 0) as the first bad commit, and indeed if I use 2.6.28 with
> 24c0996 reverted, the bluetooth device survives suspend to ram.
> 
> If you need more information/test/etc please let me know.
> 
> Regards,
> Jan
> 
> > commit 24c0996a6b73e2554104961afcc8659534503e0d
> > Author: Alan Stern <stern@rowland.harvard.edu>
> > Date:   Mon Dec 1 10:24:41 2008 -0500
> >
> >     USB: skip Set-Interface(0) if already in altsetting 0
> >
> >     When a driver unbinds from an interface, usbcore always sends a
> >     Set-Interface request to reinstall altsetting 0.  Unforunately, quite
> >     a few devices have buggy firmware that crashes when it receives this
> >     request.
> >
> >     To avoid such problems, this patch (as1180) arranges to send the
> >     Set-Interface request only when the interface is not already in
> >     altsetting 0.
> >
> >     Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> >     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

here's a fix patch that appears to be dealing with aspects of this commit:

  http://lkml.org/lkml/2009/1/2/47

you might want to give it a try.

	Ingo
