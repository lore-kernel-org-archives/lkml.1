Return-Path: <linux-kernel-owner+w=401wt.eu-S1762959AbXKIOtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762959AbXKIOtd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 09:49:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760068AbXKIOtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 09:49:25 -0500
Received: from wr-out-0506.google.com ([64.233.184.230]:19264 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759848AbXKIOtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 09:49:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=YZorQcPJY8fTNrFNUQWP0of2Fi7szdd7j1Q7eemfQA7HsL0LUPiOY+EJuR3T9W6Zh3BnA92sY/dxNzsnDi3rzRt/ZtiM8fSDs4WbVM+PLRK3LECdLOpWhMX5Z+Nw/qJyWgBLrhwpGhrObGIqTh9Y1igGpbsM/c3KsyxKJrxuZFQ=
Message-ID: <4734736C.5060003@gmail.com>
Date: Fri, 09 Nov 2007 16:49:16 +0200
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Jeff Garzik <jeff@garzik.org>, Mark Lord <liml@rtr.ca>,
       Riki Oktarianto <rkoktarianto@gmail.com>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-ide@vger.kernel.org
Subject: Re: [PATCH] Add quirk to set AHCI mode on ICH boards
References: <20071109020235.GA2031@ceren> <20071109023129.GA25581@havoc.gtf.org> <4733D421.7000505@rtr.ca> <20071109034622.GB25581@havoc.gtf.org> <20071109120425.543971bf@the-village.bc.nu>
In-Reply-To: <20071109120425.543971bf@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Thu, 8 Nov 2007 22:46:22 -0500
> Jeff Garzik <jeff@garzik.org> wrote:
>
>   
>> On Thu, Nov 08, 2007 at 10:29:37PM -0500, Mark Lord wrote:
>>     
>>> And I might even privately patch my own kernels to map the ACHI BAR
>>> in the cases where the BIOS didn't...
>>>       
>> The inability to do this in the general case is the main reason why
>> AHCI was not unconditionally enabled, even in IDE mode, when it was
>> originally added...  :/
>>     
>
> We've done it all the time for various devices without problems (eg S3
> video cards). I'd like to see it go in - although perhaps attached to a
> force_ahci boot param initially
>   

There is one problem with force enabling ahci. You'll loose the CDROM on
Dell laptops.
Prior to force-enabling ahci there is one "device" that sees the 2 sata
channels, and the 2 ide channels.
When you force-enable ahci, this device becomes the ahci controller (it
changes the device id),
and the IDE controller will appear as a separate new device (with
another device id), but it is disabled.

There are registers on the ICH7 that allows you to set enabled/disabled
status, but according to the documentation you should not enable a
device after it has been disabled. In practice I couldn't get the CDROM
to get re-enabled:
* either nothing happend
* spurious irqs were sent that nobody handles, unless I used irq=poll;
but still no cdrom.

Force-enabling AHCI, and not trying to enable the CDROM works, although
I occasionally got NCQ errors.

For a (long) discussion see this thread on the powertop mailing list:
http://www.bughost.org/pipermail/power/2007-June/000533.html
http://www.bughost.org/pipermail/power/2007-June/000573.html

And there is also another slightly different approach:
http://mjg59.livejournal.com/76062.html

Best regards,
--Edwin






