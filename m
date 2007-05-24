Return-Path: <linux-kernel-owner+w=401wt.eu-S1763230AbXEXFTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763230AbXEXFTq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 01:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758927AbXEXFTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 01:19:39 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:31255 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758517AbXEXFTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 01:19:38 -0400
Date: Wed, 23 May 2007 23:19:35 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [RFC PATCH] PCI MMCONFIG: add validation against ACPI motherboard
 resources
In-reply-to: <200705232040.53651.jbarnes@virtuousgeek.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Olivier Galibert <galibert@pobox.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, Len Brown <lenb@kernel.org>
Message-id: <46552067.8090107@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <4635510D.4060103@shaw.ca>
 <alpine.LFD.0.98.0705232016350.3890@woody.linux-foundation.org>
 <alpine.LFD.0.98.0705232018380.3890@woody.linux-foundation.org>
 <200705232040.53651.jbarnes@virtuousgeek.org>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> On Wednesday, May 23, 2007 8:20:14 Linus Torvalds wrote:
>> On Wed, 23 May 2007, Linus Torvalds wrote:
>>> Sure. I think mmconfig is perfectly sane if it falls back to conf1
>>> accesses for legacy stuff..
>> .. but without a regression, it's obviously a post-2.6.22 thing, I guess I
>> should make that clear, just because I think people send me patches after
>> -rc1 way too eagerly just because they think it fixes a bug.
>>
>> Basically if it's not somethign that has _ever_ worked some way, it's not
>> a bug, it's a feature ;)
> 
> No, I know better than to send something after your merge window closes.  I 
> have no desire to be flamed even further on this topic.  :)
> 
> And come to think of it, adding the enable/disable bits might be good even 
> with the patch to make legacy accesses go through type 1, since PCIe BAR 
> probing is probably done the same way (I haven't looked) and so we might run 
> into the same problems there.

I think that disabling decode on non-host-bridge devices during the BAR 
sizing is something we should at least try, indeed.

The issue I have with forcing legacy config space accesses to type1 is 
that it would make it much less obvious if the MMCONFIG access wasn't 
working properly. You'd likely be able to boot up but then wonder why 
something that does extended config space accesses didn't work or hung 
the box. As I mentioned before, either we trust the MMCONFIG or we 
don't, and if we decide that we don't on a particular box, we should 
really be shutting it off entirely. Hopefully with the ACPI reservation 
checking patch and the disable-decode-during-BAR-sizing patch
we wouldn't need to add that restriction.

But yes, post-2.6.22 for all of this :-)

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/
