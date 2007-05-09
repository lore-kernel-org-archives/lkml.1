Return-Path: <linux-kernel-owner+w=401wt.eu-S1757476AbXEIRKG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476AbXEIRKG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 13:10:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755670AbXEIRJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 13:09:56 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48881 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755459AbXEIRJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 13:09:55 -0400
Date: Wed, 9 May 2007 10:09:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <greg@kroah.com>
cc: Cornelia Huck <cornelia.huck@de.ibm.com>, Adrian Bunk <bunk@stusta.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Please revert 5adc55da4a7758021bcc374904b0f8b076508a11
 (PCI_MULTITHREAD_PROBE)
In-Reply-To: <20070509164207.GA28633@kroah.com>
Message-ID: <alpine.LFD.0.98.0705091004270.4062@woody.linux-foundation.org>
References: <20070508153713.344cc881@gondolin.boeblingen.de.ibm.com>
 <20070508141149.GJ4226@stusta.de> <alpine.LFD.0.98.0705080819350.3974@woody.linux-foundation.org>
 <20070508183846.28a94797@gondolin.boeblingen.de.ibm.com> <20070509095302.GA13053@kroah.com>
 <20070509153813.52a7c397@gondolin.boeblingen.de.ibm.com>
 <20070509164207.GA28633@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 9 May 2007, Greg KH wrote:
> 
> Why is it dead?  Since when is PCI the only bus in the system?

Quite frankly, any probing strategy that isn't relevant to PCI simply 
isn't relevant - full stop!

No, it's not the only bus, but if something isn't relevant to PCI it 
shouldn't be in any general bus layer abstraction.  PCI is _that_ dominant 
(and all the modern variations are just extensions on PCI, PCI didn't go 
away just because it's called PCI-X or whatever).

I think buses like SCSI, USB etc are valid things to worry about as being 
very different from PCI, but they are not something that the generic bus 
probing code (as exemplified by the commit in question) should know/care 
about. Whatever probing semantics that a SCSI adapter ends up using for 
probing its bus should be up to the SCSI layer, and there is no point in 
thinking that it should be a "generic bus" abstraction.

In fact, different SCSI adapters would likely have different rules. iSCSI 
probably won't have anything in common with "normal" SCSI when it comes to 
probing, for example.

		Linus
