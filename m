Return-Path: <linux-kernel-owner+w=401wt.eu-S1751010AbXECIX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751010AbXECIX3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 04:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751076AbXECIX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 04:23:29 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:42008 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbXECIX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 04:23:26 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46399BDE.4040605@s5r6.in-berlin.de>
Date: Thu, 03 May 2007 10:22:54 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
CC: linux1394-devel@lists.sourceforge.net, olh@suse.de,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, krh@redhat.com
Subject: Re: [git pull] New firewire stack
References: <200705030004.l4304l8h012587@turbo.physics.adelaide.edu.au>
In-Reply-To: <200705030004.l4304l8h012587@turbo.physics.adelaide.edu.au>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Woithe wrote:
>> Olaf Hering wrote:
>>> NACK.
>>> Upgrade the current drivers/ieee1394/ with the new code, and keep all
>>> existing module names.
[...]
> However, as a compromise how about renaming the existing stack's modules and
> then reusing the existing names for the new stack?  Messy I know, but this
> way both stacks would still be available without recompilation for those who
> needed them and the sbp2-as-root dilemma raised by Olaf would also be
> covered.

I.e. new modules:
	ieee1394 (was fw-core)
	ohci1394 (was fw-ohci)
	sbp2     (was fw-sbp2)
	eth1394  (to be done) --- but that's a bad name anyway, it
                                  implements IP over 1394, not Ethernet
old modules, for example:
	ieee1394-old
	ohci1394-old
	sbp2-old
	eth1394-old
	pcilynx    (unless somebody plans to port it, then pcilynx-old)
	raw1394    (or rename it too?, it requires ieee1394-old)
	video1394  (ditto)
	dv1394     (ditto)

Looks... weird.

On the other hand, a 1394 module compilation cycle in order to do the
fallback is not such a huge issue, except that it requires the person to
be able to compile modules.  That's probably the main issue.

>> As for putting the new stack in drivers/ieee1394 - I don't know, I think it 
>> makes sense to keep the new stack in it's own directory.
> 
> My immediate thought it that it would be neater and clearer to have both
> stacks in different directories, but I could live with either.

We could rename some of the existing source files to make the
distinction clearer.

> Oh yes, it would be nice to have working PCILynx support again (although I
> acknowledge it's unlikely to happen).  Some of us do have these cards
> installed for sniffing purposes (using nosy) but it would be nice to be able
> to use them with libraw1394 as well.  It would for example save me having to
> swap cards depending on what I needed to do (I have insufficient PCI slots
> to have both the PCILynx and OHCI cards installed simultaneously).

But then, what is the actual utility of pcilynx?  (I mean the current
driver, not the card or a future driver.)  Last time I checked, sbp2 was
broken without OHCI's physical DMA, and AFAIK raw1394's newer iso API
and video1394 and dv1394 don't work with pcilynx either.

Porting pcilynx to the new low-level API would be quite resource
demanding --- seen in relation to which resources we have, what the
existing pcilynx driver's state of affairs is, and how rare the hardware
is.  (For those who have the hardware, the stand-alone Nosy is
undoubtedly the killer application, not pcilynx.)
-- 
Stefan Richter
-=====-=-=== -=-= ---==
http://arcgraph.de/sr/
