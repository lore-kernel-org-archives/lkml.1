Return-Path: <linux-kernel-owner+w=401wt.eu-S932131AbZCaWLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131AbZCaWLa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 18:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932097AbZCaWLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 18:11:14 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:45984 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763660AbZCaWLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 18:11:11 -0400
Date: Tue, 31 Mar 2009 23:11:07 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Azael Avalos <coproscefalo@gmail.com>
Cc: linux-acpi@vger.kernel.org, dsilvers@simtec.co.uk,
       toshiba_acpi@memebeam.org, linux-kernel@vger.kernel.org, lenb@intel.com
Subject: Re: [PATCH 2/2] toshiba-acpi: Support TOS1900-type devices
Message-ID: <20090331221107.GA30383@srcf.ucam.org>
References: <20090331214501.GC29489@srcf.ucam.org> <20090331214749.GD29489@srcf.ucam.org> <74962ea30903311506m41306659td0cd70c5736f6660@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74962ea30903311506m41306659td0cd70c5736f6660@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 01, 2009 at 03:06:12PM +1700, Azael Avalos wrote:

> Indeed, my Satellite X205-9800 uses that method, however, it only provides
> HCI call 0x001E (Hotkey Events) and no System Event FIFO (0x0016),
> instead, hotkeys are entered on a variable called TOHK (TOshiba HotKeys?).
> Located in my model in
> 
> PCI0.LPCB.EC0.TOHK

Ok, interesting. Looking at the DSDTs I have here, TOHK isn't always 
present on TOS1900 devices. However:

> and it appears that it can be _polled_ tru' method INFO
> (TOSH_INTERFACE_2 ".INFO"),
> perhaps a small change in the polling to reflect to that method for
> TOS1900 devices would be necessary.

The INFO method is, so this looks like a good call.

> 
> On my model the complete call would be:
> 
> \\_SB.VALZ.SPFC
> \\_SB.VALZ.INFO
> 
> Is it different from \\_SB_.VALZ.SPFC or it simply doesn't matter?

Yeah, that shouldn't matter. So it simply looks like in the notification 
function on these systems we should call the INFO method and that'll 
give us the key back? I'll send a test patch later (don't have any 
hardware to test right now).

-- 
Matthew Garrett | mjg59@srcf.ucam.org
