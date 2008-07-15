Return-Path: <linux-kernel-owner+w=401wt.eu-S1758661AbYGOVYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758661AbYGOVYq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 17:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbYGOVYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 17:24:37 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:39258 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783AbYGOVYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 17:24:37 -0400
Message-ID: <487D158B.90603@garzik.org>
Date: Tue, 15 Jul 2008 17:24:27 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Marcel Holtmann <marcel@holtmann.org>,
       David Woodhouse <dwmw2@infradead.org>, Frans Pop <elendil@planet.nl>,
       arjan@infradead.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
References: <487C0365.5030203@garzik.org> <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org> <200807151757.10626.elendil@planet.nl> <1216149637.27242.65.camel@violet.holtmann.net> <alpine.LFD.1.10.0807151223290.3351@woody.linux-foundation.org> <1216150616.27455.377.camel@shinybook.infradead.org> <alpine.LFD.1.10.0807151244320.3351@woody.linux-foundation.org> <1216151640.27242.90.camel@violet.holtmann.net> <alpine.LFD.1.10.0807151301130.2867@woody.linux-foundation.org> <487D0801.4000206@garzik.org> <20080715204750.GM1369@1wt.eu>
In-Reply-To: <20080715204750.GM1369@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
> On Tue, Jul 15, 2008 at 04:26:41PM -0400, Jeff Garzik wrote:
>> To be extremely concrete, firmware-in-module is
>>
>> 	* add Kconfig option (kernel-wide or per-driver, dunno) asking
>> 	  "build firmware into drivers, as before?"
>>
>> 	* tweak build process to build firmware into foo.ko output,
>> 	  probably in a specially marked ELF section
>>
>> 	* get request_firmware() to automatically notice that the
>> 	  MODULE_FIRMWARE() was built into this driver, and to
>> 	  look at the special ELF section for its data
> 
> Jeff, just thinking, wouldn't it be slightly easier to move the firmware
> in a separate module on its own and just add a dependency, so that foo.ko
> automatically loads foo-fw.ko ? I know it will be slightly differente, but
> would not change in-site deployment workflows nor installed scripts.

Quite true.  That's definitely an option, but I feel that building the 
firmware into the driver module itself would be about the same level of 
difficulty, but carry with it additional benefits:

Users and distros can be _certain_ their driver setup will not break due 
to these changes, if you have Kconfig options available to reproduce 
exactly what 2.6.26 produced [firmware compiled into the driver itself].

If Kconfig options are set such that the outputs are the same in 2.6.26 
and 2.6.27 -- vmlinuz and kernel modules -- then that should close 
windows of regression both real and theoretical, by producing _exactly_ 
the same outputs.

	Jeff




