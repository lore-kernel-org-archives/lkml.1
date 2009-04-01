Return-Path: <linux-kernel-owner+w=401wt.eu-S1762628AbZDAQyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762628AbZDAQyQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 12:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758157AbZDAQx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 12:53:58 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:59351 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466AbZDAQx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 12:53:57 -0400
Date: Wed, 1 Apr 2009 17:53:45 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Azael Avalos <coproscefalo@gmail.com>
Cc: linux-acpi@vger.kernel.org, dsilvers@simtec.co.uk,
       toshiba_acpi@memebeam.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] toshiba-acpi: Support TOS1900-type devices
Message-ID: <20090401165345.GA13939@srcf.ucam.org>
References: <20090331214501.GC29489@srcf.ucam.org> <20090331214749.GD29489@srcf.ucam.org> <74962ea30903311506m41306659td0cd70c5736f6660@mail.gmail.com> <20090331221107.GA30383@srcf.ucam.org> <74962ea30903311519s2fb6087fxfe8859e3c570ac99@mail.gmail.com> <20090331230217.GA31599@srcf.ucam.org> <74962ea30904010950u31fbdca3w51eafb9b7ec1ca73@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74962ea30904010950u31fbdca3w51eafb9b7ec1ca73@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 09:50:59AM +1700, Azael Avalos wrote:
> On Wed, Apr 1, 2009 at 4:02 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > Ok, can you try this and let me know what codes it generates (if it
> > generates any)? It should go on top of the previous patches.
> 
> Nothing gets generated, even if I change the method to ".INFO" and hotkey
> events enabled with hci_write2(HCI_HOTKEY_EVENT, 1, 1, &hci_result) and
> TECF set to 1 (see my DSDT).
> 
> I was playing with the code yesterday trying to get some events reported, but no
> luck so far.
> 
> It appears that TOHK variable is _volatile_ and it just stores hotkey events
> temporarily and they don't get _stored_ like in the System Event FIFO.

Yes, you shouldn't be reading directly from TOHK at any point. It seems 
to be a purely internal variable - I'm fairly sure that the INFO method 
is the only one that should be called on event generation.

> On the patches I sent to the omnibook module I'm able to get events but they
> seem to get repeated 3 times, or perhaps I'm polling to often.

Hm. I don't have test hardware right now, I'm afraid. I'll look at some 
DSDTs a bit more and see if anything springs to mind.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
