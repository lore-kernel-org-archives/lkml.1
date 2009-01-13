Return-Path: <linux-kernel-owner+w=401wt.eu-S1756783AbZAMVX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783AbZAMVX6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 16:23:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754316AbZAMVXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 16:23:42 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:41306 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbZAMVXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 16:23:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=e0+Z4vnVGrDVI5baDrCDRwkn7UJygNUe9ORy5dwIYMzlOtWmObU393E9Aq/N8R5hrI
         B7zv20rvZrf6ob0TqtSOBYWPNqwIoJ4+UBcJDf4qo3vVoNKGQMPiKQCRyEE8safaigyc
         OVRshqbpPJUqDFgIVFR8OF1Jn1JnzYa7Nd82w=
Message-ID: <496D0653.3040709@gmail.com>
Date: Tue, 13 Jan 2009 16:23:31 -0500
From: Connor Behan <connor.behan@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b1pre) Gecko/20080904135032 Shredder/3.0b1pre
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Grant Grundler <grundler@parisc-linux.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Linux PCI <linux-pci@vger.kernel.org>, Gary Hade <garyhade@us.ibm.com>
Subject: Re: Can't allocate resources for PCI video card behind bridge
References: <49665493.4070808@gmail.com> <200901082057.00170.rjw@sisk.pl> <200901081226.38909.jbarnes@virtuousgeek.org> <200901091530.58694.bjorn.helgaas@hp.com> <20090110200902.GA14664@colo.lackof.org> <496BFFAA.3000707@gmail.com> <alpine.LFD.2.00.0901121856150.6528@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0901121856150.6528@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> So those are the docking bridge resources, but if I understood correctly,
> what you have issues with is that you want a graphics card in the dock to
> work - and I can't even see it in the lspci output. I see this one:
>
> 	01:00.0 VGA compatible controller: ATI Technologies Inc Rage Mobility M3 AGP 2x (rev 02) (prog-if 00 [VGA controller])
>
> but that is the built-in laptop graphics. You say that you have another
> graphics card that used to be at 02:00.0, but it's not showing up at ALL,
> so this is more than some random resource allocation issue - this is a
> device not even even being enumerated. That's very different - it implies
> that some bridge isn't turned on at all.
>
> Can you do the dmesg and lspci for the kernel where this works?
>
> 		Linus
>    
I was about to say that the kernel where this worked once doesn't allow 
this to work again. I downgraded to 2.6.27 and got the same problem. But 
then I also downgraded udev, mkinitcpio, lilo, device-mapper, pciutils 
and hwdetect and reset the defaults on my BIOS and took out 
pci=assign-busses and then the card started working.

dmesg: http://pastebin.com/m68dd0ce
lspci: http://pastebin.com/m4c01d354

It's quite a bit different from when I remember it working the other 
time. The errors on BARs 7, 8 and 9 still show up and the card is on bus 
09. However after I did this I updated all those packages to the newest 
versions except I did so one at a time not all at once. Now I'm up to 
date and still have this card working. So I'm sorry to bother you with 
this, the kernel does not need to be patched for this at all. It's 
either a BIOS problem or a distro problem caused by updating too many 
packages at once. Either way it's fixed now. Thanks alot.
