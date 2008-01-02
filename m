Return-Path: <linux-kernel-owner+w=401wt.eu-S1758225AbYABPi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225AbYABPi3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 10:38:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753644AbYABPiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 10:38:21 -0500
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:41830 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836AbYABPiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 10:38:20 -0500
Message-ID: <477BAF37.2020005@keyaccess.nl>
Date: Wed, 02 Jan 2008 16:35:19 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Ingo Molnar <mingo@elte.hu>, "David P. Reed" <dpreed@reed.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Rene Herman <rene.herman@gmail.com>,
       Paul Rolland <rol@as2917.net>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
References: <47667366.7010405@gmail.com>	<4766AE88.4080904@zytor.com>	<4766D175.7040807@reed.com>	<20071217212509.5edaa372@the-village.bc.nu>	<477A634C.8040000@reed.com>	<20080101161557.3ce2d5f8@the-village.bc.nu>	<20080101164338.GA901@elte.hu>	<20080101173212.1bba4939@the-village.bc.nu>	<20080101184524.GA6655@elte.hu>	<20080101210734.03414931@the-village.bc.nu>	<20080102100436.GB4389@elte.hu> <20080102134738.2d4c7464@the-village.bc.nu>
In-Reply-To: <20080102134738.2d4c7464@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02-01-08 14:47, Alan Cox wrote:

>> ok, you are right. How about we go with one of your suggestions: rename 
>> the API family to isa_*_p() in the affected ISA drivers? That makes it 
>> perfectly clear that this is an ISA related historic quirk that we just 
>> cannot properly emulate in an acceptable fashion. It will also make the 
>> least amount of changes to these truly historic drivers.
> 
> Works for me. We need to build two versions of 8390.c now but thats no
> big deal and sorts PCMCIA out too.

For no binary changes at all, and if going through all those outb_p() users 
anyway, might/could as well just manually split them then:

outb_p() --> outb();
              slow_down_io();

and then just leave out the slow_down_io() call in the non-ISA spots. 
slow_down_io() could be renamed isa_io_delay() or anything (paravirt is a 
little annoying there) if someone cares but then it's a complete identity 
transformation for any driver that does care.

Would IMO also make for a somewhat better API than an isa_outb_p() as 
there's nothing particurly ISA about the outb method itself -- many ISA 
drivers use plain outb() as well.

Rene.
